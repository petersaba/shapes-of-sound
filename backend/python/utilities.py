import tensorflow as tf
import tensorflow_io as tfio
import numpy as np

keras = tf.keras
vocabulary = ["-", "#", "<", ">"] + [chr(i + 96) for i in range(1, 27)] + [" ", ".", ",", "?"]

char_to_id = {}
id_to_char = {}
for i, char in enumerate(vocabulary):
    char_to_id[char] = i
    id_to_char[i] = char

VOCABULARY_SIZE = len(vocabulary)
OUTPUT_VECTOR_LENGTH = 200
MAX_SENTENCE_LENGTH = 200 # max number of characters

class WordEmbedding(keras.layers.Layer):
    def __init__(self, vocabulary_size=VOCABULARY_SIZE, max_sentence_length=MAX_SENTENCE_LENGTH, output_vector_length=OUTPUT_VECTOR_LENGTH):
        super().__init__()
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
AUDIOS_PATH = 'data\LJSpeech-1.1\wavs'

def getAudioTranscriptions(csv_path=CSV_PATH):
    data = []
    with open(csv_path, 'r', encoding='utf-8') as file:
        for line in file:
            line = line.strip().split('|')
            audio = line[0]
            transcription = line[2].replace(';', '.')
            pair = {'audio': audio, 'text': transcription}
            data.append(pair)

    return data

def vectorizeText(text, max_length=MAX_SENTENCE_LENGTH):
    text = text.lower()
    text = text[: max_length]
    text = f"<{text}>"

    padding_length = max_length - len(text)
    vectorized_text = [char_to_id.get(char, 1) for char in text] + [0] * padding_length

    return vectorized_text

def createTextDataset(data):
    texts = [pair['text'] for pair in data]
    vectorized_texts = [vectorizeText(text) for text in texts]
    texts_dataset = tf.data.Dataset.from_tensor_slices(vectorized_texts)

    return texts_dataset

def readDataFromAudio(audio_path):
    encrypted_content = tf.io.read_file(audio_path)
    signal, sample_rate = tf.audio.decode_wav(encrypted_content, desired_channels=1)
    signal = tf.squeeze(signal, axis=-1) # changing shape from (x, 1) to (x)

    stft = tf.signal.stft(signal, frame_length=200, frame_step=80, fft_length=256)
    stft = tf.math.pow(tf.abs(stft), 0.5)

    means = tf.math.reduce_mean(stft, axis=1, keepdims=True)
    standarad_deviations = tf.math.reduce_std(stft, axis=1, keepdims=True)

    stft = (stft - means) / standarad_deviations # normalizing the stfts

    desired_audio_length = 2754 # (sample rate / frame step) * desired duration: here the desired duration is 10seconds

    paddings = tf.constant([[0, desired_audio_length], [0, 0]])
    stft = tf.pad(stft, paddings)[: desired_audio_length] # in case the audio length is bigger than desired length only the desired length is returned

    return stft

def createAudioDataset(data):
    audios = []
    for pair in data:
        audio_name = pair['audio']
        audio_path = f'{AUDIOS_PATH}\{audio_name}.wav'
        audios.append(audio_path)

    audios_dataset = tf.data.Dataset.from_tensor_slices(audios)
    stft_dataset = audios_dataset.map(readDataFromAudio, num_parallel_calls=tf.data.AUTOTUNE)

    return stft_dataset

def createFullDataset(data, batch_size=4):
    audio_dataset = createAudioDataset(data)
    text_dataset = createTextDataset(data)
    dataset = tf.data.Dataset.zip((audio_dataset, text_dataset))
    dataset = dataset.map(lambda audio, text: {'source': audio, 'target': text})
    dataset = dataset.batch(batch_size)
    dataset = dataset.prefetch(tf.data.AUTOTUNE)

    return dataset

if __name__ ==  "__main__":
    pass