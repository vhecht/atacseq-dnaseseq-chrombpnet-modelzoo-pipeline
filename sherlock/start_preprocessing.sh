#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3

if [[ -d $output_dir/$experiment ]] ; then
    echo "skipping experiment directory creation"
else
    mkdir $output_dir/$experiment
fi

if [[ -d $output_dir/$experiment/preprocessing ]] ; then
    echo "skipping preprocessing step"
else
    mkdir $output_dir/$experiment/preprocessing
    cores=2
    sbatch --export=ALL --requeue \
        -J $experiment.preprocessing \
        -p owners,akundaje -t 720 \
        -c $cores --mem=40G \
        -o $output_dir/$experiment/preprocessing/preprocessing.log.o \
        -e $output_dir/$experiment/preprocessing/preprocessing.log.e \
        run_preprocessing.sh $experiment $metadata_tsv $output_dir/$experiment/
fi
