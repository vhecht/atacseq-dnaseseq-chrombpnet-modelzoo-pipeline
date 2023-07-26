#!/bin/sh

experiment=$1
dir=$2
modelname=$3
foldn=$4

peaks=$dir/$modelname/filtered.peaks.bed
nonpeaks=$dir/$modelname/filtered.nonpeaks.bed
out=$dir/$modelname/train_test_regions/
fold=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/splits/$foldn".json"
nonpeakstest=$dir/negatives_data/test/test.$foldn.filtered.negatives_with_summit.bed


echo "singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif python get_train_test_regions.py -ip $peaks -inp $nonpeaks -f $fold -o $out -inpt $nonpeakstest"
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif python get_train_test_regions.py -ip $peaks -inp $nonpeaks -f $fold -o $out -inpt $nonpeakstest
