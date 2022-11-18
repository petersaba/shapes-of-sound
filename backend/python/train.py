import tensorflow as tf
import transformer
import utilities
keras = tf.keras

if __name__ == '__main__':
    data = utilities.getAudioTranscriptions()
    validation_split = int(len(data) * 0.99)
    train_data = data[: validation_split]
    validation_data = data[validation_split :]


    train_dataset = utilities.createFullDataset(train_data, 32)
    validation_dataset = utilities.createFullDataset(validation_data)

    test_batch = next(iter(validation_dataset)) # batch to be used when testing once every 5 epochs
    display_test = transformer.DisplayOutputs(test_batch)

    model = transformer.Transformer()
    loss = keras.losses.CategoricalCrossentropy(label_smoothing=0.1, from_logits=True)

    learning_rate = transformer.CustomSchedule(steps_per_epoch=len(train_dataset))
    optimizer = keras.optimizers.Adam(learning_rate)
    model.compile(optimizer, loss=loss)

    model.fit(train_dataset, validation_data=validation_dataset, callbacks=[display_test], epochs=150)

    model_json = model.to_json()
    with open('./model/model.json', 'w') as file:
        file.write(model_json)
    model.save_weights('./model/model_weights.h5')