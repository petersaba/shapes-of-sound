import sys
import utilities
import tensorflow as tf

if __name__ == "__main__":
    if sys.argv[1][-4:] != '.wav':
        exit()

    audio_path = sys.argv[1]
    audio_data = utilities.readDataFromAudio(audio_path)
    
    # the input passed to predict needs to have 3 dimensions
    audio_data = tf.expand_dims(audio_data, 0) # becomes a batch with one sample
    