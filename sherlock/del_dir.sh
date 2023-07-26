#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4

if [[ -d $oak_dir/$experiment ]] ; then
    cp -r  $oak_dir/$experiment/ $output_dir/
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment

fi






