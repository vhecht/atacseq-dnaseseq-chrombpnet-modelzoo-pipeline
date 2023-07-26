#!/bin/sh

experiment=$1
dir=$2
oak_dir=$3

#cp -r /oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/$experiment/preprocessing $dir/
#wait

cd gc_matched_negatives
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash gc_negatives.sh $experiment $dir/preprocessing/downloads/peaks.bed.gz $dir/negatives_data/
wait
#cp -r $dir/negatives_data/ $oak_dir



