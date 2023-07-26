#!/bin/sh

experiment=$1
model_name=$2

module load biology
module load samtools/1.16.1

python get_samstats.py -m $model_name -n $experiment 
