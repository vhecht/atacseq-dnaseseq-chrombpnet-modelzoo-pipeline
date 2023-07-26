#!/bin/sh

experiment=$1
dir=$2
oak_dir=$3


cd ../gc_matched_negatives
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash gc_negatives_new.sh $experiment $dir/preprocessing/downloads/peaks.bed.gz $dir/negatives_data/ fold_0
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash gc_negatives_new.sh $experiment $dir/preprocessing/downloads/peaks.bed.gz $dir/negatives_data/ fold_1
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash gc_negatives_new.sh $experiment $dir/preprocessing/downloads/peaks.bed.gz $dir/negatives_data/ fold_2
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash gc_negatives_new.sh $experiment $dir/preprocessing/downloads/peaks.bed.gz $dir/negatives_data/ fold_3
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash gc_negatives_new.sh $experiment $dir/preprocessing/downloads/peaks.bed.gz $dir/negatives_data/ fold_4


