#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

#cp -r /oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference /scratch/groups/akundaje/anusri/chromatin_atlas/

if [[ -d $output_dir/$experiment ]] ; then
    echo "skipping experiment directory creation"
    #rm -r $output_dir/$experiment
    #wait
    #rm -r $oak_dir/$experiment
    #wait
    #mkdir $output_dir/$experiment
    #mkdir $oak_dir/$experiment
else
    mkdir $output_dir/$experiment
    mkdir $oak_dir/$experiment
fi


if [[ -f $oak_dir/$experiment/preprocessing/bigWigs/$experiment.bigWig ]] ; then
    echo "skipping preprocessing step"
else
    echo $experiment
    rm -r $output_dir/$experiment/preprocessing 
    rm -r $oak_dir/$experiment/preprocessing
    mkdir $output_dir/$experiment/preprocessing
    mkdir $oak_dir/$experiment/preprocessing
    cores=2
    sbatch --export=ALL --requeue \
        -J $experiment.preprocessing.bam \
        -p owners,akundaje -t 10:00:00 \
        -c $cores --mem=200G \
        -o $output_dir/$experiment/preprocessing/preprocessing.log.o \
        -e $output_dir/$experiment/preprocessing/preprocessing.log.e \
        run_preprocessing.sh $experiment $metadata_tsv $output_dir/$experiment/ $oak_dir/$experiment/
fi
