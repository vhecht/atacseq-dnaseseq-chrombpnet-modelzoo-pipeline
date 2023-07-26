#!/bin/sh

experiment=$1
oak_dir=$2

if [[ -f $oak_dir/$experiment//negatives_data/candidates.tsv ]] ; then
    if [[ -f $oak_dir/$experiment/negatives_data/test/test.fold_4.filtered.negatives_with_summit.bed ]] ; then
        echo "skipping creation of gc-matching"
    else
        mkdir $oak_dir/$experiment/negatives_data/test/
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.$fold.gc_matching \
            -p owners,akundaje -t 01:00:00 \
            -C NO_GPU \
            -c $cores --mem=40G \
            -o $oak_dir/$experiment/negatives_data/test/test.gc_matching.log.o \
            -e $oak_dir/$experiment/negatives_data/test/test.gc_matching.log.e \
            run_gc_matching.sh $experiment $oak_dir/$experiment/ $oak_dir/$experiment/
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment

fi






