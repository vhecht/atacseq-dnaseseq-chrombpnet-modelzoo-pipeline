#!/bin/sh


experiment=$1
dir=$2
oak_dir=$3


cd chrombpnet
reference_fasta=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/hg38.genome.fa

zcat $dir/preprocessing/downloads/peaks_no_blacklist.bed.gz | shuf -n 30000  > $dir/preprocessing/downloads/30K.subsample.overlap.bed
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif nvidia-smi
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile.sh $reference_fasta $dir/preprocessing/downloads/30K.subsample.overlap.bed $dir/chrombpnet_model/interpret/$experiment $dir/chrombpnet_model/chrombpnet_wo_bias.h5
wait
cp -r $dir/chrombpnet_model/interpret $oak_dir


