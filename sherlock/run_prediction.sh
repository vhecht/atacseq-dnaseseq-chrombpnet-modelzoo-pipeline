#!/bin/sh

experiment=$1
dir=$2
oak_dir=$3
modelname=$4

cd chrombpnet

model_dir=$dir/$modelname/
#regions=$dir/$modelname/interpret/full_$experiment.interpreted_regions_counts.bed
regions=$dir/preprocessing/downloads/peaks.bed.gz
#genome=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/hg38.genome.fa
genome=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/hg38.genome.fa
outfile=$oak_dir/all.$experiment
#chrom_size=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/chrom.sizes
chrom_size=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/chrom.sizes


##cp $dir/preprocessing/bigWigs/$experiment.bigWig $oak_dir/

echo "singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash make_prediction_bigwig.sh $model_dir $regions $genome $outfile $chrom_size"
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash make_prediction_bigwig.sh $model_dir $regions $genome $outfile $chrom_size


