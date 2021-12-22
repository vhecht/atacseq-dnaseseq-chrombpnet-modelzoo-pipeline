#!/bin/bash

function timestamp {
    # Function to get the current time with the new line character
    # removed 
    
    # current time
    date +"%Y-%m-%d_%H-%M-%S" | tr -d '\n'
}


experiment=$1
peaks=$2
project_dir=$3


blacklist=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/blacklist_slop1057.bed
reference_dir=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/

# create the log file
logfile=$project_dir/$experiment.log
touch $logfile


echo $( timestamp ): "
python get_gc_content.py \\
       --input_bed $peaks \\
       --ref_fasta $reference_dir/hg38.genome.fa \\
       --out_prefix $project_dir/foreground.gc.bed \\
       --flank_size 1057" | tee -a $logfile 

python get_gc_content.py \
       --input_bed $peaks \
       --ref_fasta $reference_dir/hg38.genome.fa \
       --out_prefix $project_dir/foreground.gc.bed \
       --flank_size 1057


echo $( timestamp ): "
bedtools slop -i $peaks -g $reference_dir/chrom.sizes -b 1057 > $project_dir/${1}_inliers_slop.bed" | tee -a $logfile

bedtools slop -i $peaks -g $reference_dir/chrom.sizes -b 1057 > $project_dir/${1}_inliers_slop.bed 

echo $( timestamp ): "
bedtools intersect -v -a \\
    $reference_dir/genomewide_gc_hg38_stride_50_inputlen_2114.bed \\
    -b $project_dir/${1}_inliers_slop.bed $blacklist > $project_dir/candidates.tsv" | \
    tee -a $logfile 

bedtools intersect -v -a \
$reference_dir/genomewide_gc_hg38_stride_50_inputlen_2114.bed \
-b $project_dir/${1}_inliers_slop.bed $blacklist > $project_dir/candidates.tsv

echo $( timestamp ): "
python get_gc_matched_negatives.py \\
        --candidate_negatives $project_dir/candidates.tsv \\
        --foreground_gc_bed  $project_dir/foreground.gc.bed \\
        --out_prefix $project_dir/negatives.bed" | tee -a $logfile 

python get_gc_matched_negatives.py \
        --candidate_negatives $project_dir/candidates.tsv \
        --foreground_gc_bed  $project_dir/foreground.gc.bed \
        --out_prefix $project_dir/negatives.bed

# convert negatives bed file to summit centered version

echo $( timestamp ): "awk -v OFS=\"\t\" '{print \$1, \$2, \$3, \".\",  \".\", \".\", \".\", \".\", \".\", \"1057\"}' $project_dir/negatives.bed \\
                > $project_dir/negatives_with_summit.bed" | tee -a $logfile 

awk -v OFS="\t" '{print $1, $2, $3, ".",  ".", ".", ".", ".", ".", "1057"}' $project_dir/negatives.bed > $project_dir/negatives_with_summit.bed

rm $project_dir/${1}_inliers_slop.bed

