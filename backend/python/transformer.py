import tensorflow as tf
import numpy as np
from utilities import WordEmbedding, SpeechFeatureEmbedding
keras = tf.keras

class TransformerEncoder(keras.layers.Layer):
    def __init__(self, heads_num, key_dimension, ffn_layer1_unit_num, normalization_epsilon=1e-6, dropout=0.1):
        self.multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)
        self.dropout_layer1 = keras.layers.Dropout(dropout)
        self.normalization_layer1 = keras.layers.LayerNormalization(normalization_epsilon)
        self.dropout_layer2 = keras.layers.Dropout(dropout)
        self.normalization_layer2 = keras.layers.LayerNormalization(normalization_epsilon)

        self.ffn = keras.models.Sequential([
            keras.layers.Dense(ffn_layer1_unit_num, activation='relu'),
            keras.layers.Dense(key_dimension)
        ])

    def call(self,input):

        output = self.multiheaded_attention_layer(input, input)
        output = self.dropout_layer1(output, training=True)
        output = self.normalization_layer1(input + output)

        ffn_output = self.ffn(output)
        output = self.dropout_layer2(ffn_output, training=True)
        output = self.normalization_layer2(ffn_output + output)

        return output

class TransformerDecoder(keras.layers.Layer):
    
    def __init__(
        self,
        heads_num,
        key_dimension,
        ffn_unit_num,
        normalization_epsilon=1e-6,
        dropout1=0.5,
        dropout2=0.1
    ):
        self.multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)
        self.masked_multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)

        self.masked_multiheaded_attention_dropout = keras.layers.Dropout(dropout1)
        self.multiheaded_attention_dropout = keras.layers.Dropout(dropout2)
        self.ffn_dropout = keras.layers.Dropout(dropout2)

        self.masked_multiheaded_attention_normalization = keras.layers.LayerNormalization(normalization_epsilon)
        self.multiheaded_attention_normalization = keras.layers.LayerNormalization(normalization_epsilon)
        self.ffn_normalization = keras.layers.LayerNormalization(normalization_epsilon)

        self.ffn = keras.models.Sequential([
            keras.layers.Dense(ffn_unit_num, activation='relu'),
            keras.layers.Dense(key_dimension)
        ])

    def getMultiHeadedAttentionMask(self, batch_size, length):
        x = tf.range(length)
        y = tf.range(length)[:, None] # each value is in its own array

        mask = y >= x
        mask = tf.reshape(mask, [1, length, length])
        mult = tf.constant([batch_size, 1, 1])

        return tf.tile(mask, mult)

    def call(self, encoder_output, targets):
        batch_size = np.shape(targets)[0]
        length =np.shape(targets)[1]

        multiheaded_attention_mask = self.getMultiHeadedAttentionMask(batch_size, length)
        masked_multiheaded_attention_output = self.masked_multiheaded_attention_layer(targets, targets, attention_mask=multiheaded_attention_mask)
        masked_multiheaded_attention_output = self.masked_multiheaded_attention_dropout(masked_multiheaded_attention_output)
        output = self.masked_multiheaded_attention_normalization(targets + masked_multiheaded_attention_output)

        multiheaded_attention_output = self.multiheaded_attention_layer(output, encoder_output)
        multiheaded_attention_output = self.multiheaded_attention_dropout(multiheaded_attention_output)
        output = self.multiheaded_attention_normalization(output + multiheaded_attention_output)

        ffn_output = self.ffn(output)
        ffn_output = self.ffn_dropout(ffn_output)
        ffn_output = self.ffn_normalization(ffn_output + output)

        return ffn_output

class Transformer(keras.Model):
    def __init__(
        self,
        key_dimension=64,
        heads_num=2,
        ffn_unit_num=400,
        target_maxlen=100,
        # source_maxlen=100,
        encoder_layer_num=4,
        decoder_layer_num=1,
        vocabulary_len=34
        ):    
        super().__init__()
        self.loss_metric = tf.metrics.Mean(name='loss')
        self.decoder_layer_num = decoder_layer_num
        self.target_maxlen = target_maxlen
        self.vocabulary_len = vocabulary_len

        self.encoder_input = SpeechFeatureEmbedding(key_dimension)
        self.decoder_input = WordEmbedding(max_sentence_length=target_maxlen)

        self.encoder = keras.Sequential(
            [self.encoder_input] +
            [
                TransformerEncoder(heads_num, key_dimension, ffn_unit_num) for _ in range(encoder_layer_num)
            ]
        )

        for i in range(decoder_layer_num):
            setattr(self, f'decoder_layer_{i}', TransformerDecoder(heads_num, key_dimension, ffn_unit_num))

        self.classifier = keras.layers.Dense(vocabulary_len)

    def decode(self, encoder_output, target):
        output = self.decoder_input(target)
        for i in range(self.decoder_layer_num):
            output = getattr(self, f'decoder_layer_{i}')(encoder_output, output)
        
        return output

    @property
    def metrics(self):
        return [self.loss_metric]

    def call(self, inputs):
        x = inputs[0]
        y = inputs[1]

        encoder_output = self.encoder(x)
        decoder_output = self.decode(encoder_output, y)

        linear_fct_output = self.classifier(decoder_output)

        return linear_fct_output

    def train_step(self, batch):
        input = batch['x']
        target = batch['y']

        decoder_input = target[:, :-1]
        decoder_target = target[:, 1:]
        
        with tf.GradientTape as tape:
            predictions = self([input, decoder_input])
            vectorized_target = tf.one_hot(decoder_target, depth=self.vocabulary_len)
            mask = decoder_target != 0
            loss = self.compiled_loss(vectorized_target, predictions, sample_weight=mask)
        trainable_variables = self.trainable_variables
        gradients = tape.gradient(loss, trainable_variables)
        self.optimizer.apply_gradients(zip(gradients, trainable_variables))
        self.loss_metric.update_state(loss)
        loss_mean = self.loss_metric.result()

        return {'loss': loss_mean}

    def test_step(self, batch):
        input = batch[0]
        target = batch[1]
        decoder_input = target[:, :-1]
        decoder_target = target[:, 1:]

        predictions = self([input, decoder_input])
        vectorized_target = tf.one_hot(decoder_target, depth=self.vocabulary_len)
        mask = decoder_target != 0
        loss = self.compiled_loss(predictions, vectorized_target, sample_weight=mask)

        self.loss_metric.update_state(loss)
        loss_mean = self.loss_metric.result()

        return {'loss': loss_mean}

    def generateOutput(self, batch, start_token_id=2):
        batch_size = tf.shape(batch)[0]
        encoder_output = self.encoder(batch)
        # start every output sentence with the start char id
        decoder_input = tf.ones((batch_size, 1), dtype=tf.int32) * start_token_id

        for i in range(self.target_maxlen - 1):
            decoder_output = self.decode(encoder_output, decoder_input)
            output = self.classifier(decoder_output)
            # getting the index of each character with the highest probability
            output = tf.argmax(output, axis=-1, output_type=tf.int32)
            last_chars_index = tf.expand_dims(output[:, -1], axis=-1)
