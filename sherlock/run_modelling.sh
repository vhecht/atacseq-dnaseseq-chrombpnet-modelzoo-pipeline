#!/bin/sh


experiment=$1
dir=$2

cd chrombpnet

reference_fasta=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/hg38.genome.fa
bigwig_path=$dir/preprocessing/bigWigs/$experiment.bigWig
overlap_peak=$dir/preprocessing/downloads/peaks.bed.gz
nonpeaks=$dir/negatives_data/negatives_with_summit.bed
fold=/scratch/groups/akundaje/anusri/chromatin_atlas/splits/fold_0.json
bias_model=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/atac.bias.2114.1000.h5
output_dir=$dir/chrombpnet_model/

singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash step6_train_chrombpnet_model.sh $reference_fasta $bigwig_path $overlap_peak $nonpeaks $fold $bias_model $output_dir
