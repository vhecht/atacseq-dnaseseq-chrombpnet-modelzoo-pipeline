#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

mkdir $output_dir/$experiment/
#cp -r /oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/$experiment/preprocessing $output_dir/$experiment/
#wait 

if [[ -d $output_dir/$experiment ]] ; then
    if [[ -d $output_dir/$experiment/negatives_data ]] ; then
        echo "skipping creation of gc-matching"
    else
        mkdir $output_dir/$experiment/negatives_data
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.gc_matching2 \
            -p owners,akundaje -t 720 \
            -c $cores --mem=40G \
            -o $output_dir/$experiment/negatives_data/gc_matching.log.o \
            -e $output_dir/$experiment/negatives_data/gc_matching.log.e \
            run_gc_matching.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment

fi






