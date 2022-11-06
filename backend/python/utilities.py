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

class SpeechFeatureEmbedding(keras.layers.Layer):

    # extract features to be fed to the encoder
    def __init__(self, kernel_num):
        self.conv_layer1 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')
        self.conv_layer2 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')
        self.conv_layer3 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')

    def call(self, input):
        output = self.conv_layer1(input)
        output = self.conv_layer2(output)
        output = self.conv_layer3(output)
        
        return output

if __name__ ==  "__main__":
    pass