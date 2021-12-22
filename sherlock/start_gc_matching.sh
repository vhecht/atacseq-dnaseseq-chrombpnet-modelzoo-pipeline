#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3

if [[ -d $output_dir/$experiment ]] ; then
    if [[ -d $output_dir/$experiment/negatives_data ]] ; then
        echo "skipping creation of gc-matching"
    else
        mkdir $output_dir/$experiment/negatives_data
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiement.gc_matching \
            -p owners,akundaje -t 720 \
            -c $cores --mem=40G \
            -o $output_dir/$experiment/negatives_data/gc_matching.log.o \
            -e $output_dir/$experiment/negatives_data/gc_matching.log.e \
            run_gc_matching.sh $experiment $output_dir/$experiment/
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment

fi






