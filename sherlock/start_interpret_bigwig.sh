#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
bw_oak_dir=$4
oak_dir=$5


if [[ -d $oak_dir/$experiment ]] ; then
    if [[ -f $oak_dir/$experiment/chrombpnet_model/chrombpnet_wo_bias.h5 ]] ; then
        if [[ -f $oak_dir/$experiment/chrombpnet_model/interpret/full_$experiment.counts_scores.h5 ]] ; then
            if [[ -f $bw_oak_dir/$experiment/full_$experiment.counts.bigwig ]] ; then
                echo "bigwig found"
            else
                cores=1
                mkdir $bw_oak_dir/$experiment/
                sbatch --export=ALL --requeue \
                    -J $experiment.interpret.bigwig \
                    -p akundaje,owners -t 00:30:00 \
                    -c $cores \
                    --mem=50G \
                    -o $bw_oak_dir/$experiment/bigwig.interpret.counts.log.o \
                    -e $bw_oak_dir/$experiment/bigwig.interpret.counts.log.e \
                    run_interpret_bigwig.sh $experiment $output_dir/$experiment/ $bw_oak_dir/$experiment/ $oak_dir/$experiment/ chrombpnet_model

            fi
        fi
    else
        echo "skipping interpretation - model not found"
    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
fi






