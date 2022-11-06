import tensorflow as tf
import numpy as np
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

    def getOutput(self,input):

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

    def getOutput(self, encoder_output,targets):
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
        head_num=2,
        ffn_unit_num=400,
        target_maxlen=100,
        source_maxlen=100,
        encoder_layer_num=4,
        decoder_layer_num=1,
        vocabulary_len=34
        ):    
        super().__init__()
        self.loss_metric = tf.metrics.Mean(name='loss')
        self.decoder_layer_num = decoder_layer_num
        self.target_maxlen = target_maxlen
        self.vocabulary_len = vocabulary_len

        