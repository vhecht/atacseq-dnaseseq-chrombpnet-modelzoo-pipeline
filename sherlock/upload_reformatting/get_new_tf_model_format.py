import tensorflow as tf
from tensorflow.keras.models import load_model
import argparse
from tensorflow.keras.utils import get_custom_objects

parser = argparse.ArgumentParser(description="converting model types")
parser.add_argument("-i", "--input_model")
parser.add_argument("-o","--output_path")
args = parser.parse_args()

custom_objects={"tf": tf}
get_custom_objects().update(custom_objects) 
model=load_model(args.input_model,compile=False)
model.save(args.output_path)
#tf.saved_model.save(model,args.output_path) 

