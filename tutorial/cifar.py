import os
import numpy as np
import pickle
from keras import models, layers, utils, optimizers

def collect_data(f):
    with open(f, 'rb') as fo:
        batch = pickle.load(fo, encoding='bytes')
        # Reshape to 10000x3072 to 10000x32x32x3
        X = batch[b'data'].reshape(batch[b'data'].shape[0], 3, 32, 32).transpose(0, 2, 3, 1)
        y = batch[b'labels']
        return X, y

if __name__=="__main__":
    save_dir = os.path.join(os.getcwd(), 'saved_models')
    model_name = 'keras_cifar10'
    split_idx = 40000

    cifar_files = ['cifar-10-batches-py/data_batch_%d' % i for i in range(1, 6)]
    X_batches = []
    y_batches = []
    for cifar_file in cifar_files:
        X, y = collect_data(cifar_file)
        X_batches.append(X)
        y_batches.append(y)

    X = np.concatenate(X_batches)
    y = np.concatenate(y_batches)

    X_train, y_train, X_test, y_test = X[:split_idx], y[:split_idx], X[split_idx:], y[split_idx:]

    y_train = utils.to_categorical(y_train, 10)
    y_test  = utils.to_categorical(y_test, 10)

    cnn = models.Sequential()

    cnn.add(layers.Conv2D(32, (3, 3), input_shape=X_train.shape[1:]))
    cnn.add(layers.Activation('relu'))
    cnn.add(layers.Conv2D(32, (3, 3)))
    cnn.add(layers.Activation('relu'))
    cnn.add(layers.MaxPooling2D(pool_size=(2, 2)))
    cnn.add(layers.Dropout(0.25))
    cnn.add(layers.Dense(10, activation='softmax'))

    cnn.add(layers.Flatten())
    cnn.add(layers.Dense(512))
    cnn.add(layers.Activation('relu'))
    cnn.add(layers.Dropout(0.5))
    cnn.add(layers.Dense(10))
    cnn.add(layers.Activation('softmax'))

    opt = optimizers.rmsprop(lr=0.0001, decay=1e-6)

    cnn.compile(loss='categorical_crossentropy',
                optimizer=opt,
                metrics=['accuracy'])

    X_train = X_train.astype('float32')
    X_test = X_test.astype('float32')
    X_train /= 255
    X_test /= 255

    cnn.fit(X_train, y_train, validation_data=(X_test, y_test), batch_size=32, epochs=5, shuffle=True)

    if not os.path.isdir(save_dir):
        os.makedirs(save_dir)
    model_path = os.path.join(save_dir, model_name)
    cnn.save(model_path)
    print('Saved trained model at %s ' % model_path)

    scores = cnn.evaluate(x_test, y_test, verbose=1)
    print('Test loss:', scores[0])
    print('Test accuracy:', scores[1])

