# Functions for image preprocessing and plotting and saving results

import numpy as np
import os
import matplotlib.pyplot as plt
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from sklearn.metrics import classification_report, confusion_matrix, ConfusionMatrixDisplay

class imgUtils:
    def __init__(self, img_size):
        self.img_size = img_size
        
    def preprocess(self, img, std, mean):
        img /= 255
        centered = np.subtract(img, mean)
        standardized = np.divide(centered, std)
        return self.img
        return standardized
    
    def dataGen(self, rotation, h_shift, w_shift):
        TTA_datagen = ImageDataGenerator(
                                   preprocessing_function=self.preprocess,
                                   height_shift_range=h_shift,
                                   width_shift_range=w_shift,
                                   rotation_range=rotation,
                                   zoom_range=0.05,
                                   brightness_range=[0.9,1.1],
                                   fill_mode='constant',
                                   horizontal_flip=True
                                                                            )
        nTTA_datagen = ImageDataGenerator(
                                          preprocessing_function=self.preprocess
                                                                            )
        
        return TTA_datagen, nTTA_datagen
    
    def generator(self, batch_size, train, test, train_dir, test_dir):
        train_generator = train.flow_from_directory(train_dir, 
                                     target_size = (self.img_size, self.img_size), 
                                     class_mode = 'binary', 
                                     color_mode ='rgb', 
                                     batch_size = batch_size,
                                     interpolation = 'lanczos'
                                                    )
        test_generator = test.flow_from_directory(test_dir, 
                                        target_size = (self.img_size, self.img_size), 
                                        class_mode = 'binary',
                                        color_mode = 'rgb', 
                                        batch_size = batch_size,
                                        interpolation ='lanczos'
                                                        )
        return train_generator, test_generator
    
    # The train and test generators used for ensembling
    def testGenerator(self, batch_size, test, data_dir):
        test_generator = test.flow_from_directory(data_dir, 
                                        target_size = (self.img_size, self.img_size), 
                                        class_mode = 'binary',
                                        color_mode = 'rgb', 
                                        batch_size = batch_size,
                                        interpolation ='lanczos',
                                        shuffle = False
                                                        )
        return test_generator
    
    def plot_save(self, history, save_dir, exp_name):
        if not os.path.exists(save_dir + 'save_plots_initial/{}'.format(exp_name)):
            os.makedirs(save_dir + 'save_plots_initial/{}'.format(exp_name))
            
        plt.plot(history.history['acc'])
        plt.plot(history.history['val_acc'])
        plt.title('Model accuracy')
        plt.ylabel('Accuracy')
        plt.xlabel('Epoch')
        plt.legend(['Train', 'Val'], loc='upper left')
        plt.savefig(os.path.join(save_dir, 'save_plots_initial/{}/loss'.format(exp_name)))
        plt.show()
        
        plt.plot(history.history['loss'])
        plt.plot(history.history['val_loss'])
        plt.title('Model loss')
        plt.ylabel('Loss')
        plt.xlabel('Epoch')
        plt.legend(['Train', 'Val'], loc='upper left')
        plt.savefig(os.path.join(save_dir, 'save_plots_initial/{}/loss'.format(exp_name)))
        plt.show()
        
        plt.plot(history.history['auc'])
        plt.plot(history.history['val_auc'])
        plt.title('Model auc')
        plt.ylabel('AUC')
        plt.xlabel('Epoch')
        plt.legend(['Train', 'Val'], loc='upper left')
        plt.savefig(os.path.join(save_dir, 'save_plots_initial/{}/auc_hist'.format(exp_name)))
        plt.show()
        
        plt.plot(history.history['precision'])
        plt.plot(history.history['val_precision'])
        plt.title('Model precision')
        plt.ylabel('Precision')
        plt.xlabel('Epoch')
        plt.legend(['Train', 'Val'], loc='upper left')
        plt.savefig(os.path.join(save_dir, 'save_plots_initial/{}/prec'.format(exp_name)))
        plt.show()
        
        plt.plot(history.history['recall'])
        plt.plot(history.history['val_recall'])
        plt.title('Model recall')
        plt.ylabel('Recall')
        plt.xlabel('Epoch')
        plt.legend(['Train', 'Val'], loc='upper left')
        plt.savefig(os.path.join(save_dir, 'save_plots_initial/{}/recall'.format(exp_name)))
        plt.show()
    
    # Generates confusion matrix
    def confusionMatrix(self, test_generator, ensemble_pred_round):
        print('Confusion Matrix for {size1}x{size2} images'.format(size1 = self.img_size, size2 = self.img_size))
        cm = confusion_matrix(test_generator.classes, ensemble_pred_round)
        target_names = ['COVID-Neg', 'COVID-Pos']
        disp = ConfusionMatrixDisplay(cm, display_labels=target_names)
        disp = disp.plot(cmap='Blues', values_format='.0f')
        plt.show()
        print('Classification Report')
        print(classification_report(test_generator.classes, ensemble_pred_round, target_names=target_names))
        return cm
        
