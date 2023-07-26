#!/bin/sh


experiment=$1
dir=$2
oak_dir=$3

cp -r $oak_dir $dir/

cd chrombpnet
reference_fasta=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/hg38.genome.fa

##chrombpnet_model_encsr880cub_bias
#chrombpnet_model_feb15
#chrombppnet_model_encsr283tme_bias
#chrombpnet_model_encsr146kfx_bias

if [[ ! -f $dir/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5 ]] ; then
    cp $oak_dir/chrombpnet_model_encsr146kfx_bias/* $dir/chrombpnet_model_encsr146kfx_bias/
fi
wait

#if [[ -f $dir/preprocessing/downloads/peaks_no_blacklist.bed.gz ]] ; then
#    zcat $dir/preprocessing/downloads/peaks_no_blacklist.bed.gz | shuf -n 30000  > $dir/preprocessing/downloads/30K.subsample.overlap.bed
#else
#    zcat $dir/preprocessing/downloads/peaks.bed.gz | shuf -n 30000  > $dir/preprocessing/downloads/30K.subsample.overlap.bed
#fi

#cat  $dir/chrombpnet_model_encsr146kfx_bias/filtered.peaks.bed | shuf -n 30000  > $dir/preprocessing/downloads/30K.subsample.overlap.bed
sort -k 8gr,8gr $dir/chrombpnet_model_encsr146kfx_bias/filtered.peaks.bed  | head -n 30000 > $dir/preprocessing/downloads/30K.ranked.subsample.overlap.bed
cat  $dir/chrombpnet_model_encsr146kfx_bias/filtered.peaks.bed | shuf -n 100  > $dir/preprocessing/downloads/testing.bed

singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif nvidia-smi

#singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile.sh $reference_fasta $dir/preprocessing/downloads/30K.subsample.overlap.bed $dir/chrombpnet_model_encsr146kfx_bias/interpret/$experiment $dir/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5
#singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile.sh $reference_fasta $dir/preprocessing/downloads/30K.ranked.subsample.overlap.bed $dir/chrombpnet_model_encsr146kfx_bias/interpret/ranked_$experiment $dir/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile.sh $reference_fasta $dir/preprocessing/downloads/peaks.bed.gz $dir/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment $dir/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5
#singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif bash interpret_profile.sh $reference_fasta $dir/preprocessing/downloads/testing.bed $dir/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment $dir/chrombpnet_model_encsr146kfx_bias/chrombpnet_wo_bias.h5



wait
mkdir $oak_dir/interpret/
cp -r $dir/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment.counts_scores.h5 $oak_dir/interpret/
cp -r $dir/chrombpnet_model_encsr146kfx_bias/interpret/full.counts3.interpret.log.o $oak_dir/interpret/
cp -r $dir/chrombpnet_model_encsr146kfx_bias/interpret/full.counts3.interpret.log.e $oak_dir/interpret/
cp -r $dir/chrombpnet_model_encsr146kfx_bias/interpret/full_$experiment.interpreted_regions.bed $oak_dir/interpret/
wait




