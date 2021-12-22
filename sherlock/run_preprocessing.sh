#!/bin/sh

experiment=$1
metadata_tsv=$2
dir=$3

cd preprocessing
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash create_params.sh $experiment $metadata_tsv $dir/preprocessing/
wait
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash run_preprocess.sh $dir/preprocessing/params_file.json YB2UY72X wz4crdoninxbg7u7 $dir/preprocessing/

