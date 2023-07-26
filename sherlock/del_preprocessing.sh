#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4


if [[ -d $output_dir/$experiment ]] ; then
    if [[ -f $output_dir/$experiment/chrombpnet_model/chrombpnet_wo_bias.h5 ]] ; then
        echo "exiting"	
    else
        rm -r $output_dir/$experiment/chrombpnet_model
    fi
else
    echo "skipping experiment directory creation"
fi

