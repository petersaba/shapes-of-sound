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

class WordEmbedding(keras.layers.Layer):
    def __init__(self, vocabulary_size=VOCABULARY_SIZE, max_sentence_length=MAX_SENTENCE_LENGTH, output_vector_length=OUTPUT_VECTOR_LENGTH):
        self.word_embedding_layer = keras.layers.Embedding(vocabulary_size, output_vector_length)
        self.positional_embedding_layer = keras.layers.Embedding(max_sentence_length, output_vector_length)

    def call(self, words):
        max_length = np.shape(words)[-1]
        char_positions = tf.range(max_length)
        word_embedding = self.word_embedding_layer(words)
        positional_embedding = self.positional_embedding_layer(char_positions)

        return word_embedding + positional_embedding

class SpeechFeatureEmbedding(keras.layers.Layer):

    # extract features to be fed to the encoder
    def __init__(self, kernel_num):
        super().__init__()
        self.conv_layer1 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')
        self.conv_layer2 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')
        self.conv_layer3 = keras.layers.Conv1D(kernel_num, 11, strides=2, activation='relu')

    def call(self, input):
        output = self.conv_layer1(input)
        output = self.conv_layer2(output)
        output = self.conv_layer3(output)
        
        return output

CSV_PATH = 'data\LJSpeech-1.1\metadata.csv'

def getAudioTranscriptions(csv_path=CSV_PATH):
    data = []
    with open(csv_path, 'r', encoding='utf-8') as file:
        for line in file:
            line = line.strip().split('|')
            audio = line[0]
            transcription = line[2]
            pair = {'audio': audio, 'text': transcription}
            data.append(pair)

    return data

def vectorizeText(text):
    pass

if __name__ ==  "__main__":
    pass