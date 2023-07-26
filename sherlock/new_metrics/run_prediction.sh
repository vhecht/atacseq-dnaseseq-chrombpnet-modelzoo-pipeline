#!/bin/sh

experiment=$1
dir=$2
modelname=$3
foldn=$4

cd ../chrombpnet

model_dir=$dir/$modelname/
genome=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/hg38.genome.fa
nonpeaks=$dir/negatives_data/test/test.$foldn.filtered.negatives_with_summit.bed 
fold=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/splits/$foldn".json"


echo "singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash new_metrics.sh $genome $dir/preprocessing/bigWigs/$experiment.bigWig $nonpeaks $fold  $model_dir"
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash new_metrics.sh $genome $dir/preprocessing/bigWigs/$experiment.bigWig $nonpeaks $fold  $model_dir

