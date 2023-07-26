#!/bin/sh

experiment=$1

odir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/full_deepshaps/bigwigs/ATAC"

if [[ -f $odir/$experiment/mean_bigwig/full_mean_$experiment".counts.bigwig" ]] ; then
	echo 'mean counts file exists'
else
	echo $odir/$experiment/mean_bigwig/
	mkdir  $odir/$experiment/mean_bigwig/
	cores=2
	sbatch --export=ALL --requeue \
	-J $experiment.mean.counts \
	-p owners,akundaje \
	-t 00:20:00 -c $cores --mem=50G \
	-o $odir/$experiment/mean_bigwig/counts.file.log.o \
	-e $odir/$experiment/mean_bigwig/counts.file.log.e \
	run_combine_bigwig_counts.sh  $experiment
fi






