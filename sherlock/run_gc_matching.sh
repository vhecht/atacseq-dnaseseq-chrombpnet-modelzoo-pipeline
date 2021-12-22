#!/bin/sh

experiment=$1
dir=$2

cd gc_matched_negatives
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash gc_negatives.sh $experiment $dir/preprocessing/downloads/peaks.bed.gz $dir/negatives_data/



