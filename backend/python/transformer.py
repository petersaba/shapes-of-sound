import tensorflow as tf
import numpy as np
keras = tf.keras

def createTransformerEncoder(heads_num, key_dimension, ffn_layer1_unit_num, ffn_layer2_unit_num, normalization_epsilon, dropout):
    multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)
    dropout_layer1 = keras.layers.Dropout(dropout)
    normalization_layer1 = keras.layers.LayerNormalization(normalization_epsilon)
    dropout_layer2 = keras.layers.Dropout(dropout)
    normalization_layer2 = keras.layers.LayerNormalization(normalization_epsilon)

    ffn = keras.models.Sequential([
        keras.layers.Dense(ffn_layer1_unit_num, activation='relu'),
        keras.layers.Dense(key_dimension)
    ])

    return multiheaded_attention_layer, dropout_layer1, dropout_layer2, normalization_layer1, normalization_layer2, ffn

def getTransformerEncoderOutput(
        input, 
        heads_num, 
        key_dimension, 
        ffn_layer1_unit_num, 
        ffn_layer2_unit_num, 
        normalization_epsilon=1e-6, 
        dropout=0.1
        ):

    ( multiheaded_attention_layer,
        dropout_layer1, 
        dropout_layer2, 
        normalization_layer1, 
        normalization_layer2, 
        ffn ) = createTransformerEncoder(
            heads_num, key_dimension, ffn_layer1_unit_num, ffn_layer2_unit_num, normalization_epsilon, dropout
        )

    output = multiheaded_attention_layer(input, input)
    output = dropout_layer1(output, training=True)
    output = normalization_layer1(input + output)

    ffn_output = ffn(output)
    output = dropout_layer2(ffn_output, training=True)
    output = normalization_layer2(ffn_output + output)

    return output

def createTransformerDecoder(
    heads_num,
    key_dimension,
    ffn_unit_num,
    normalization_epsilon=1e-6,
    dropout1=0.5,
    dropout2=0.1
):
    multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)
    masked_multiheaded_attention_layer = keras.layers.MultiHeadAttention(heads_num, key_dimension)

    masked_multiheaded_attention_dropout = keras.layers.Dropout(dropout1)
    multiheaded_attention_dropout = keras.layers.Dropout(dropout2)
    ffn_dropout = keras.layers.Dropout(dropout2)

    masked_multiheaded_attention_normalization = keras.layers.LayerNormalization(normalization_epsilon)
    multiheaded_attention_normalization = keras.layers.LayerNormalization(normalization_epsilon)
    ffn_normalization = keras.layers.LayerNormalization(normalization_epsilon)

    ffn = keras.models.Sequential([
        keras.layers.Dense(ffn_unit_num, activation='relu'),
        keras.layers.Dense(key_dimension)
    ])

    return (
        multiheaded_attention_layer,
        masked_multiheaded_attention_layer,

        masked_multiheaded_attention_dropout,
        multiheaded_attention_dropout,
        ffn_dropout,

        masked_multiheaded_attention_normalization,
        multiheaded_attention_normalization,
        ffn_normalization,

        ffn
    )

def getMultiHeadedAttentionMask(batch_size, length):
    
    x = tf.range(length)
    y = tf.range(length)[:, None] # each value is in its own array

    mask = y >= x
    mask = tf.reshape(mask, [1, length, length])
    mult = tf.constant([batch_size, 1, 1])

    return tf.tile(mask, mult)

def getTransformerDecoderOutput(
    encoder_output,
    targets,
    heads_num,
    key_dimension,
    ffn_unit_num
):
    batch_size = np.shape(targets)[0]
    length =np.shape(targets)[1]
    
    ( multiheaded_attention_layer,
        masked_multiheaded_attention_layer,

        masked_multiheaded_attention_dropout,
        multiheaded_attention_dropout,
        ffn_dropout,

        masked_multiheaded_attention_normalization,
        multiheaded_attention_normalization,
        ffn_normalization,

        ffn ) = createTransformerDecoder(heads_num, key_dimension, ffn_unit_num)

    multiheaded_attention_mask = getMultiHeadedAttentionMask(batch_size, length)
    masked_multiheaded_attention_output = masked_multiheaded_attention_layer(targets, targets, attention_mask=multiheaded_attention_mask)
    masked_multiheaded_attention_output = masked_multiheaded_attention_dropout(masked_multiheaded_attention_output)
    output = masked_multiheaded_attention_normalization(targets + masked_multiheaded_attention_output)

    multiheaded_attention_output = multiheaded_attention_layer(output, encoder_output)
    multiheaded_attention_output = multiheaded_attention_dropout(multiheaded_attention_output)
    output = multiheaded_attention_normalization(output + multiheaded_attention_output)

    ffn_output = ffn(output)
    ffn_output = ffn_dropout(ffn_output)
    ffn_output = ffn_normalization(ffn_output + output)

    return ffn_output

class Transformer(keras.Model):
    def __init__(
        self,
        head_num=2,
        ffn_unit_num=400,
        target_maxlen=100,
        source_maxlen=100,
        encoder_layer_num=4,
        decoder_lyaer_num=1,
        vocabulary_len=34
        ):    
        pass