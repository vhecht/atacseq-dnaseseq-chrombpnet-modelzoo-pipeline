#!/bin/sh

experiment=$1
modelname=$2
oak_dir=$3

if [[ -f $oak_dir/$experiment/$experiment"bias.bw" ]] ; then
    echo "bias bigwig file found"
    mkdir log_files/$experiment
    cores=1
    sbatch --export=ALL --requeue \
        -J $experiment.bw.del \
        -p owners,akundaje -t 00:10:00 \
        -c $cores --mem=2G \
        -o log_files/$experiment/del.bias.bw.log.o \
        -e log_files/$experiment/del.bias.bw.log.e \
        run_bias_bigwig_del.sh $experiment $modelname
else
    echo "nothing to do"
fi
