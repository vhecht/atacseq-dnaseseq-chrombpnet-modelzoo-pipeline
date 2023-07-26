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

if [[ ! -f $dir/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5 ]] ; then
    cp $oak_dir/chrombpnet_model_encsr146kfx_bias/* $dir/chrombpnet_model_encsr146kfx_bias/
fi

wait

if [[ ! -f $dir/preprocessing/downloads/peaks.bed.gz ]] ; then
    mkdir $dir/preprocessing/
    mkdir $dir/preprocessing/downloads/
    cp $oak_dir/preprocessing/downloads/peaks.bed.gz $dir/preprocessing/downloads/
fi
wait


if [[ ! -f $dir/preprocessing/downloads/ccre_regions_not_in_100K_sig_peaks.bed ]] ; then
    mkdir $dir/preprocessing/
    mkdir $dir/preprocessing/downloads/
    cp $oak_dir/preprocessing/downloads/ccre_regions_not_in_100K_sig_peaks.bed $dir/preprocessing/downloads/
fi
wait


singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif nvidia-smi

bigwig_prefix=$bigwig_dir/full_$experiment

singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_full_compressed.sh $reference_fasta $dir/preprocessing/downloads/ccre_regions_not_in_100K_sig_peaks.bed $dir/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment $dir/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5 $bigwig_prefix $dir/preprocessing/downloads//100K.ranked.subsample.overlap.bed

#singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_full_compressed.sh $reference_fasta $dir/preprocessing/downloads/temp.bed $dir/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment $dir/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5 $bigwig_prefix $dir/preprocessing/downloads//100K.ranked.subsample.overlap.bed

wait
cp -r $dir/chrombpnet_model_encsr146kfx_bias/interpret/ $oak_dir/chrombpnet_model_encsr146kfx_bias/
wait




