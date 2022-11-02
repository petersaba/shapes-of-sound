import tensorflow as tf
import numpy as np

keras = tf.keras
vocabulary = ["-", "#", "<", ">"] + [chr(i + 96) for i in range(1, 27)] + [" ", ".", ",", "?"]

char_to_id = {}

for i, char in enumerate(vocabulary):
    char_to_id[char] = i

# words is a 3d having all sentences, their words each represented by array of relevant char id
def applyWordEmbedding(words, vocabulary_size=len(vocabulary), output_vector_length=64):
    word_embedding_layer = keras.layers.Embedding(vocabulary_size, output_vector_length)
    word_embedding = word_embedding_layer(words)

    return word_embedding

def applyPositionalEmbedding(max_length=200, output_vector_length=64):
    char_positions = tf.range(max_length)
    positional_embedding_layer = keras.layers.Embedding(max_length, output_vector_length)
    positional_embedding = positional_embedding_layer(char_positions)

    return positional_embedding


if __name__ ==  "__main__":

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
    # print(tf.shape(a)[0])
    # print(tf.shape(a))

    # print('----------------------------')
    # print(np.shape(a)[-1])

    print(np.shape(applyPositionalEmbedding()))
