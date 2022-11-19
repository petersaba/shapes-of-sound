import tensorflow as tf
import numpy as np
from utilities import WordEmbedding, SpeechFeatureEmbedding, id_to_char, getTranscriptionFromIds
keras = tf.keras

class TransformerEncoder(keras.layers.Layer):
    def __init__(self, heads_num, key_dimension, ffn_layer1_unit_num, normalization_epsilon=1e-6, dropout=0.1):
        super().__init__()
        self.multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)
        self.dropout_layer1 = keras.layers.Dropout(dropout)
        self.normalization_layer1 = keras.layers.LayerNormalization(epsilon=normalization_epsilon)
        self.dropout_layer2 = keras.layers.Dropout(dropout)
        self.normalization_layer2 = keras.layers.LayerNormalization(epsilon=normalization_epsilon)

        self.ffn = keras.Sequential([
            keras.layers.Dense(ffn_layer1_unit_num, activation='relu'),
            keras.layers.Dense(key_dimension)
        ])

    def call(self,input, training):

        output = self.multiheaded_attention_layer(input, input)
        output = self.dropout_layer1(output, training=training)
        output = self.normalization_layer1(input + output)

        ffn_output = self.ffn(output)
        ffn_output = self.dropout_layer2(ffn_output, training=training)
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
        super().__init__()
        self.multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)
        self.masked_multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)

        self.masked_multiheaded_attention_dropout = keras.layers.Dropout(dropout1)
        self.multiheaded_attention_dropout = keras.layers.Dropout(dropout2)
        self.ffn_dropout = keras.layers.Dropout(dropout2)

        self.masked_multiheaded_attention_normalization = keras.layers.LayerNormalization(epsilon=normalization_epsilon)
        self.multiheaded_attention_normalization = keras.layers.LayerNormalization(epsilon=normalization_epsilon)
        self.ffn_normalization = keras.layers.LayerNormalization(epsilon=normalization_epsilon)

        self.ffn = keras.Sequential([
            keras.layers.Dense(ffn_unit_num, activation='relu'),
            keras.layers.Dense(key_dimension)
        ])

    def getMultiHeadedAttentionMask(self, batch_size, length):
        x = tf.range(length)
        y = tf.range(length)[:, None] # each value is in its own array

        mask = y >= x
        mask = tf.reshape(mask, [1, length, length])
        mult = tf.concat(
            [tf.expand_dims(batch_size, -1), tf.constant([1, 1], dtype=tf.int32)], 0
        )

        return tf.tile(mask, mult)

    def call(self, encoder_output, targets):
        batch_size = tf.shape(targets)[0]
        length =tf.shape(targets)[1]

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
        key_dimension=200,
        heads_num=2,
        ffn_unit_num=400,
        target_maxlen=200,
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
        source = inputs[0]
        target = inputs[1]

        encoder_output = self.encoder(source)
        decoder_output = self.decode(encoder_output, target)

        linear_fct_output = self.classifier(decoder_output)

        return linear_fct_output

    def train_step(self, batch):
        input = batch['source']
        target = batch['target']

        decoder_input = target[:, :-1]
        decoder_target = target[:, 1:]
        
        with tf.GradientTape() as tape:
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
        input = batch['source']
        target = batch['target']
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

        # predicting character by character in each sentence in the batch
        for i in range(self.target_maxlen - 1):
            decoder_output = self.decode(encoder_output, decoder_input)
            output = self.classifier(decoder_output)
            # getting the index of each character with the highest probability
            output = tf.argmax(output, axis=-1, output_type=tf.int32)
            last_chars_index = tf.expand_dims(output[:, -1], axis=-1)

            decoder_input = tf.concat([decoder_input, last_chars_index], axis=-1)
        return decoder_input

class DisplayOutputs(keras.callbacks.Callback):

    def __init__(self, batch, start_char_id=2, end_char_id=3):
        self.batch = batch # always showing outputs on the same batch
        self.start_char_id = start_char_id
        self.end_char_id = end_char_id

    def on_epoch_end(self, epoch, logs=None):
        if epoch % 5 != 0:
            return

        source = self.batch['source']
        target = self.batch['target'].numpy()
        batch_size = tf.shape(source)[0]

        predictions = self.model.generateOutput(source, self.start_char_id)
        predictions = predictions.numpy()
        
        for i in range(batch_size):
            target_text = ''.join([id_to_char[index] for index in target[i]])
            prediction = getTranscriptionFromIds(predictions)
            
            print()
            print(f"target: {target_text.replace('-', '')}")
            print(f"prediction: {prediction}")
            print('-----------------------------------------------')

class CustomSchedule(keras.optimizers.schedules.LearningRateSchedule):

    def __init__(
        self,
        steps_per_epoch,
        init_lr=0.00001,
        lr_after_warmup=0.001,
        final_lr=0.00001,
        warmup_epochs=15,
        decay_epochs=85
    ):
        super().__init__()
        self.steps_per_epoch = steps_per_epoch
        self.init_lr = init_lr
        self.lr_after_warmup = lr_after_warmup
        self.final_lr = final_lr
        self.warmup_epochs = warmup_epochs
        self.decay_epochs = decay_epochs

    def calculateLearningRate(self, epoch):
        warmup_lr = self.init_lr + epoch * (self.lr_after_warmup - self.init_lr) / (self.warmup_epochs - 1)

        decay_lr = tf.math.maximum(
            self.final_lr,
            self.lr_after_warmup 
            - (epoch - self.warmup_epochs) 
            * (self.lr_after_warmup - self.final_lr) 
            / self.decay_epochs
        )

        return tf.math.minimum(warmup_lr, decay_lr)

    def __call__(self, step):
        epoch = step // self.steps_per_epoch
        return self.calculateLearningRate(epoch)