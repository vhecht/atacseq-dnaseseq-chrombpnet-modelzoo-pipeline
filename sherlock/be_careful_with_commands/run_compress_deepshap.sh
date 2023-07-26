#!/bin/sh

experiment=$1
model_name=$2
oakdir=$3

singularity exec /home/groups/akundaje/anusri/simg/modisco_lite.sif python run_compress_deepshap.py -m $model_name -n $experiment -d $oakdir
