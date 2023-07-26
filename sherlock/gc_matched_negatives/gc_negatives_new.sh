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
foldn=$4

blacklist=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/blacklist_slop1057.bed
reference_dir=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/
fold=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/splits/$foldn".json"

# create the log file
logfile=$project_dir/test/$foldn.$experiment"_test.log"
touch $logfile


echo $( timestamp ): "
python get_gc_matched_negatives_test.py \\
        --candidate_negatives $project_dir/candidates.tsv \\
        --foreground_gc_bed  $project_dir/foreground.gc.bed \\
        --output_prefix $project_dir/test/test.$foldn.negatives \\
        --chr_fold_path $fold" | tee -a $logfile 

python get_gc_matched_negatives_test.py \
        --candidate_negatives $project_dir/candidates.tsv \
        --foreground_gc_bed  $project_dir/foreground.gc.bed \
        --output_prefix $project_dir/test/test.$foldn".negatives" \
        --chr_fold_path $fold

# convert negatives bed file to summit centered version

echo $( timestamp ): "awk -v OFS=\"\t\" '{print \$1, \$2, \$3, \".\",  \".\", \".\", \".\", \".\", \".\", \"1057\"}' $project_dir/test/test.$foldn.negatives.bed \\
                > $project_dir/test/test.$foldn.negatives_with_summit.bed" | tee -a $logfile 

awk -v OFS="\t" '{print $1, $2, $3, ".",  ".", ".", ".", ".", ".", "1057"}' $project_dir/test/test.$foldn.negatives.bed > $project_dir/test/test.$foldn.negatives_with_summit.bed

wait

echo $( timestamp ): "
python filter_edge_regions.py \\
        --chromsizes $reference_dir/chrom.sizes \\
        --nonpeaks $project_dir/test/test.$foldn.negatives_with_summit.bed \\
        --out $project_dir/test/test.$foldn.filtered.negatives_with_summit.bed" | tee -a $logfile

python filter_edge_regions.py \
        --chromsizes $reference_dir/chrom.sizes \
        --nonpeaks $project_dir/test/test.$foldn.negatives_with_summit.bed \
        --out $project_dir/test/test.$foldn.filtered.negatives_with_summit.bed 
 
