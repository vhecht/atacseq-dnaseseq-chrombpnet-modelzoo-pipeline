#!/bin/sh


experiment=$1
dir=$2
oak_dir=$3

rm $dir/preprocessing/downloads/peaks.bed.gz
rm $dir/preprocessing/downloads/peaks_no_blacklist.bed.gz
rm $oak_dir/preprocessing/downloads/peaks.bed.gz 
rm $oak_dir/preprocessing/downloads/peaks_no_blacklist.bed.gz

tag=$dir/preprocessing/intermediates/sorted_$experiment".bam"
prefix=$dir/peak_calling/$experiment
blacklist=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/blacklist_slop1057.bed
peakfile=$dir/preprocessing/downloads/peaks.bed.gz

pval_thresh=0.01
NPEAKS=200000 # capping number of peaks called from MACS2
smooth_window=150 # default
shiftsize=$(( -$smooth_window/2 ))
gensz="hs"

macs2 callpeak \
    -t $tag -f BAM -n $prefix -g $gensz -p $pval_thresh \
   --shift $shiftsize  --extsize $smooth_window --nomodel --keep-dup all --call-summits

singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif bash peak_calling/script.sh "$prefix"_peaks.narrowPeak $blacklist "$prefix"_peaks_filtered.narrowPeak

# Sort by Col8 in descending order and replace long peak names in Column 4 with Peak_<peakRank>
sort -k 8gr,8gr "$prefix"_peaks_filtered.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | head -n ${NPEAKS} | gzip -nc > $peakfile

cp -r $dir/peak_calling/ $oak_dir/
cp $dir/preprocessing/downloads/peaks.bed.gz $oak_dir/preprocessing/downloads/peaks.bed.gz
