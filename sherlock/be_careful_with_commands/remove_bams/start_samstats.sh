#!/bin/sh

experiment=$1
model_name=$2
oak_dir=$3

if [[ -d $oak_dir/$experiment/preprocessing ]] ; then
    echo "preprocessing folder found"
    cores=20
    sbatch --export=ALL --requeue \
        -J $experiment.samstats \
        -p owners,akundaje -t 02:00:00 \
        -c $cores --mem=50G \
        -o $oak_dir/$experiment/preprocessing/samstats.log.o \
        -e $oak_dir/$experiment/preprocessing/samstats.log.e \
        run_samstats.sh $experiment $model_name
else
    echo "nothing to do"
fi
