#!/bin/sh

experiment=$1
model_name=$2

python remove_ranked_files.py -m $model_name -n $experiment


