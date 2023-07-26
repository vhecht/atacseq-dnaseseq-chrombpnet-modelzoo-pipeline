#!/bin/sh

experiment=$1
model_name=$2

python remove_bias_bigwigs.py -m $model_name -n $experiment


