import tensorflow as tf
import transformer
import utilities
keras = tf.keras

if __name__ == '__main__':
    data = utilities.getAudioTranscriptions()
    validation_split = int(len(data) * 0.99)
    
    train_data = data[: validation_split]
    validation_data = [validation_split :]

    train_dataset = utilities.createFullDataset(train_data, 64)
    validation_dataset = utilities.createFullDataset(validation_data)