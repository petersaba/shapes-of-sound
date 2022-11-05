import tensorflow as tf
import numpy as np

keras = tf.keras
vocabulary = ["-", "#", "<", ">"] + [chr(i + 96) for i in range(1, 27)] + [" ", ".", ",", "?"]

char_to_id = {}
for i, char in enumerate(vocabulary):
    char_to_id[char] = i

VOCABULARY_SIZE = len(vocabulary)
OUTPUT_VECTOR_LENGTH = 64
MAX_SENTENCE_LENGTH = 200 # max number of characters

# words is a 3d having all sentences, their words each represented by array of relevant char id
def applyWordEmbedding(words, vocabulary_size=VOCABULARY_SIZE, output_vector_length=OUTPUT_VECTOR_LENGTH):
    word_embedding_layer = keras.layers.Embedding(vocabulary_size, output_vector_length)
    word_embedding = word_embedding_layer(words)

    return word_embedding

def applyPositionalEmbedding(max_sentence_length=MAX_SENTENCE_LENGTH, output_vector_length=OUTPUT_VECTOR_LENGTH):
    char_positions = tf.range(max_sentence_length)
    positional_embedding_layer = keras.layers.Embedding(max_sentence_length, output_vector_length)
    positional_embedding = positional_embedding_layer(char_positions)

    return positional_embedding

def addEmbeddings(words, vocabulary_size=len(vocabulary), max_sentence_length=MAX_SENTENCE_LENGTH, output_vector_length=OUTPUT_VECTOR_LENGTH):
    word_embedding = applyWordEmbedding(words, vocabulary_size, output_vector_length)
    positional_embedding = applyPositionalEmbedding(max_sentence_length, output_vector_length)

    return word_embedding + positional_embedding

# extract features to be fed to the encoder
def applySpeechFeatureEmbedding(input, kernel_num):
    conv_layer1 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')
    conv_layer2 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')
    conv_layer3 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')

    output = conv_layer1(input)
    output = conv_layer2(output)
    output = conv_layer3(output)
    
    return output

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

def casual_attention_mask(batch_size, length):
    
    x = tf.range(length)
    y = tf.range(length)[:, None] # each value is in its own array

    mask = y >= x
    mask = tf.reshape(mask, [1, length, length])
    mult = tf.constant([batch_size, 1, 1])

    return tf.tile(mask, mult)


if __name__ ==  "__main__":

    print(causal_attention_mask(0, 5))

    # a = tf.constant([
    #     [
    #         [1,2,3,4,5],
    #         [3,4,5,6,7]
    #     ],
    #     [
    #         [5,4,3,2,1],
    #         [7,6,5,4,3]
    #     ]
    # ])
    # print(applyWordEmbedding(a))

    # tensor1 = tf.range(10)[: ,None]
    # # tensor2 = tf.range(start=9, limit=-1, delta=-1)
    # tensor2 = tf.range(10)

    # # print(tensor1)
    # # print(tensor1 + 10)
    # # print(tensor2)

    # result = tensor1 >= tensor2
    # print(result)
    # print('-------------------------------------------------')
    # print(tf.cast(result, tf.float32))
    # print('-------------------------------------------------')
    # print(tf.reshape(result, [1, 10, 10]))

    # tensor1 = tf.expand_dims(10, -1)
    # print(tf.concat([ tensor1, tensor2], 0))
    pass