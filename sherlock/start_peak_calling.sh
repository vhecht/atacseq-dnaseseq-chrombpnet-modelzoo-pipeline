#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

if [[ -f $oak_dir/$experiment/preprocessing/intermediates/sorted_$experiment.bam ]] ; then
    if [[ -d $oak_dir/$experiment/peak_calling ]] ; then
        echo "skipping peak-calling"
    else
        mkdir $oak_dir/$experiment/peak_calling
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.peak_calling \
            -p owners,akundaje -t 720 \
            -c $cores --mem=40G \
            -o $oak_dir/$experiment/peak_calling/log.o \
            -e $oak_dir/$experiment/peak_calling/log.e \
            run_peak_calling.sh $experiment $oak_dir/$experiment/ $oak_dir/$experiment/
    fi
else
    echo "do preprocessing first for dataset $experiment"

fi






