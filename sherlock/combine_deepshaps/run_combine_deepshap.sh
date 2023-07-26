#!/bin/sh

input_dir=$1
model1=$2
model2=$3
model3=$4
model4=$5
model5=$6
output=$7
experiment=$8
type=$9

echo "singularity exec /home/groups/akundaje/anusri/simg/modisco_lite.sif python combine_deepshap.py -i $input_dir -if $model1 $model2 $model3 $model4 $model5 -o $output -e $experiment -t $type"
singularity exec /home/groups/akundaje/anusri/simg/modisco_lite.sif python combine_deepshap.py -i $input_dir -if $model1 $model2 $model3 $model4 $model5 -o $output -e $experiment -t $type


