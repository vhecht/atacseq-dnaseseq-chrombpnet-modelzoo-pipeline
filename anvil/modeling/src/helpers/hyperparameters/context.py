import os
import sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../../training/')))
import utils.losses as losses
import utils.one_hot as one_hot

import tensorflow as tf
import tensorflow_probability as tfp


def load_model_wrapper(model_h5):
    # read .h5 model
    import tensorflow as tf
    from tensorflow.keras.utils import get_custom_objects
    from tensorflow.keras.models import load_model
    custom_objects={"tf": tf, "multinomial_nll":losses.multinomial_nll}    
    get_custom_objects().update(custom_objects)    
    model=load_model(model_h5)
    print("got the model")
    model.summary()
    return model

