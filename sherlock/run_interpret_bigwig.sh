#!/bin/sh


experiment=$1
dir=$2
oak_dir=$3
old_oak_dir=$4
modelname=$5

cd chrombpnet

#$modelname

chrom_sizes=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/chrom.sizes
#regions=$dir/$modelname/interpret/full_$experiment.interpreted_regions.bed
#h5file=$dir/$modelname/interpret/full_$experiment.counts_scores.h5
regions=$old_oak_dir/$modelname/interpret/full_$experiment.interpreted_regions.bed
h5file=$old_oak_dir/$modelname/interpret/full_$experiment.counts_scores.h5

outfile=$oak_dir/full_$experiment.counts.bigwig
outstats=$oak_dir/full_$experiment.counts.stats

#singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash make_interpretation_bigwig.sh $chrom_sizes $regions $h5file $outfile $outstats


chrom_sizes=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/chrom.sizes
#regions=$dir/$modelname/interpret/full_$experiment.interpreted_regions.bed
#h5file=$dir/$modelname/interpret/full_$experiment.profile_scores.h5

regions=$old_oak_dir/$modelname/interpret/full_$experiment.interpreted_regions.bed
h5file=$old_oak_dir/$modelname/interpret/full_$experiment.profile_scores.h5
outfile=$oak_dir/full_$experiment.profile.bigwig
outstats=$oak_dir/full_$experiment.profile.stats


singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash make_interpretation_bigwig.sh $chrom_sizes $regions $h5file $outfile $outstats




