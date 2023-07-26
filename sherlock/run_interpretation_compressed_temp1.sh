#!/bin/sh


experiment=$1
dir=$2
oak_dir=$3
bigwig_dir=$4


cd chrombpnet
reference_fasta=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/hg38.genome.fa

#chrombppnet_model_encsr283tme_bias
##chrombpnet_model_encsr880cub_bias
#chrombpnet_model_feb15
#chrombpnet_model
#chrombpnet_model_encsr146kfx_bias

if [[ ! -f $dir/chrombpnet_model_feb15/chrombpnet_wo_bias.h5 ]] ; then
    cp $oak_dir/chrombpnet_model_feb15/* $dir/chrombpnet_model_feb15/
fi
wait

if [[ ! -f $dir/preprocessing/downloads/peaks.bed.gz ]] ; then
    mkdir $dir/preprocessing/
    mkdir $dir/preprocessing/downloads/
    cp $oak_dir/preprocessing/downloads/peaks.bed.gz $dir/preprocessing/downloads/
fi
wait


#if [[ -f $dir/preprocessing/downloads/peaks_no_blacklist.bed.gz ]] ; then
#    zcat $dir/preprocessing/downloads/peaks_no_blacklist.bed.gz | shuf -n 30000  > $dir/preprocessing/downloads/30K.subsample.overlap.bed
#else
#    zcat $dir/preprocessing/downloads/peaks.bed.gz | shuf -n 30000  > $dir/preprocessing/downloads/30K.subsample.overlap.bed
#fi

#cat  $dir/chrombpnet_model_feb15/filtered.peaks.bed | shuf -n 30000  > $dir/preprocessing/downloads/30K.subsample.overlap.bed
#sort -k 8gr,8gr $dir/chrombpnet_model_feb15/filtered.peaks.bed  | head -n 30000 > $dir/preprocessing/downloads/30K.ranked.subsample.overlap.bed
#sort -k 8gr,8gr $dir/chrombpnet_model_feb15/filtered.peaks.bed  | head -n 0000 > $dir/preprocessing/downloads/30K.ranked.subsample.overlap.bed
#zcat $dir/preprocessing/downloads/peaks.bed.gz | sort -k 8gr,8gr  | head -n 100000 > $dir/preprocessing/downloads/100K.ranked.subsample.overlap.bed
#cat  $dir/chrombpnet_model_feb15/filtered.peaks.bed | shuf -n 100  > $dir/preprocessing/downloads/testing.bed



singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif nvidia-smi

bigwig_prefix=$bigwig_dir/full_$experiment


#singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile_compressed.sh $reference_fasta $dir/preprocessing/downloads/30K.subsample.overlap.bed $dir/chrombpnet_model_feb15/interpret/$experiment $dir/chrombpnet_model_feb15/chrombpnet_wo_bias.h5
#singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile_compressed.sh $reference_fasta $dir/preprocessing/downloads/30K.ranked.subsample.overlap.bed $dir/chrombpnet_model_feb15/interpret/ranked_$experiment $dir/chrombpnet_model_feb15/chrombpnet_wo_bias.h5 $bigwig_prefix
#singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile_compressed.sh $reference_fasta $dir/preprocessing/downloads/peaks.bed.gz $dir/chrombpnet_model_feb15/interpret/full_$experiment $dir/chrombpnet_model_feb15/chrombpnet_wo_bias.h5 $bigwig_prefix
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile_compressed_v2.sh $reference_fasta $dir/preprocessing/downloads/peaks.bed.gz $dir/chrombpnet_model_feb15/interpret/full_$experiment $dir/chrombpnet_model_feb15/chrombpnet_wo_bias.h5 $bigwig_prefix
#singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile_compressed.sh $reference_fasta $dir/preprocessing/downloads/testing.bed $dir/chrombpnet_model_feb15/interpret/ranked_$experiment $dir/chrombpnet_model_feb15/chrombpnet_wo_bias.h5 $bigwig_prefix


wait
cp -r $dir/chrombpnet_model_feb15/interpret/ $oak_dir/chrombpnet_model_feb15/
wait




