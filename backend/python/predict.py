import sys
import utilities
import tensorflow as tf
import transformer
import os

# disabling all tensorflow logs and error/warning messages
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import logging
tf.get_logger().setLevel(logging.ERROR)

keras = tf.keras

if __name__ == "__main__":
    if sys.argv[1][-4:] != '.wav':
        exit()

    audio_path = sys.argv[1]
    audio_data = utilities.readDataFromAudio(audio_path)
    
    # the input passed to predict needs to have 3 dimensions
    audio_data = tf.expand_dims(audio_data, 0) # becomes a batch with one sample

    model = transformer.Transformer()
    loss = keras.losses.CategoricalCrossentropy(label_smoothing=0.1, from_logits=True)
    optimizer = keras.optimizers.Adam(0) # model will not be trained here, learning rate is useless in that case
    model.compile(optimizer, loss)
    model.load_weights('./saved_model/model')

    transcription_in_ids = model.generateOutput(audio_data).numpy()[0]
    
    print(utilities.getTranscriptionFromIds(transcription_in_ids))