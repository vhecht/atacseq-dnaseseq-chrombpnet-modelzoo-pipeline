#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
fold=$5

if [[ -f $oak_dir/$experiment/preprocessing/bigWigs/$experiment.bigWig ]] ; then
    if [[ -f $oak_dir/$experiment/preprocessing/negatives_data_new/fold_"$fold"/"$experiment"_negatives.bed ]] ; then
        echo "skipping creation of gc-matching"
    else
        mkdir $oak_dir/$experiment/preprocessing/negatives_data_new/
        mkdir $oak_dir/$experiment/preprocessing/negatives_data_new/fold_"$fold"
        echo "mkdir $oak_dir/$experiment/preprocessing/negatives_data_new/fold_$fold"
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.gc_matching \
            -p owners,akundaje -t 02:00:00 \
            -c $cores --mem=10G \
            -o $oak_dir/$experiment/preprocessing/negatives_data_new/fold_$fold/gc_matching.log.o \
            -e $oak_dir/$experiment/preprocessing/negatives_data_new/fold_$fold/gc_matching.log.e \
            run_gc_matching.sh $experiment $oak_dir/$experiment/ $oak_dir/$experiment/ $fold
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi






