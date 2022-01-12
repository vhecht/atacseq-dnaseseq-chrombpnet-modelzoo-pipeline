#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

#cp -r /oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference /scratch/groups/akundaje/anusri/chromatin_atlas/

if [[ -d $output_dir/$experiment ]] ; then
    echo "skipping experiment directory creation"
else
    mkdir $output_dir/$experiment
    mkdir $oak_dir/$experiment
fi

if [[ -d $output_dir/$experiment/preprocessing ]] ; then
    echo "skipping preprocessing step"
else
    mkdir $output_dir/$experiment/preprocessing
    mkdir $oak_dir/$experiment/preprocessing
    cores=2
    sbatch --export=ALL --requeue \
        -J $experiment.preprocessing.bam_na_rerun \
        -p owners,akundaje -t 12:00:00 \
        -c $cores --mem=100G \
        -o $output_dir/$experiment/preprocessing/preprocessing.log.o \
        -e $output_dir/$experiment/preprocessing/preprocessing.log.e \
        run_preprocessing.sh $experiment $metadata_tsv $output_dir/$experiment/ $oak_dir/$experiment/
fi
