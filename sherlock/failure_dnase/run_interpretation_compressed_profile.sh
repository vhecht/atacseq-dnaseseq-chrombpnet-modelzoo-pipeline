#!/bin/sh


experiment=$1
dir=$2
oak_dir=$3
bigwig_dir=$4


cd ../chrombpnet
reference_fasta=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/hg38.genome.fa


if [[ ! -f $dir/preprocessing/downloads/100K.ranked.subsample.overlap.bed ]] ; then
    zcat $dir/preprocessing/downloads/peaks.bed.gz | sort -k 8gr,8gr  | head -n 100000 > $dir/preprocessing/downloads/100K.ranked.subsample.overlap.bed
fi

singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif nvidia-smi

bigwig_prefix=$bigwig_dir/full_$experiment

singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile_compressed.sh $reference_fasta $dir/preprocessing/downloads/100K.ranked.subsample.overlap.bed $oak_dir/interpret/full_$experiment $oak_dir/models/chrombpnet_nobias.h5 $bigwig_prefix




