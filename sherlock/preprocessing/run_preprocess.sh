#!/bin/bash

# Chrom-Atlas pipeline
# Step 1. Copy reference files from gcp
# Step 2. Download bams and peaks file for the experiment
# Step 3. Process bam files to generate bigWigs
# Step 4. Generate PWM from bigwig

# import the utils script
source ./utils.sh


# path to json file with pipeline params
pipeline_json=$1

# get params from the pipleine json
experiment=`jq .experiment $pipeline_json | sed 's/"//g'` 



assembly=`jq .assembly $pipeline_json | sed 's/"//g'`

unfiltered_alignments=`jq .unfiltered_alignments $pipeline_json | sed 's/"//g'`

unfiltered_alignments_md5sums=\
`jq .unfiltered_alignments_md5sums $pipeline_json | sed 's/"//g'`

alignments=`jq .alignments $pipeline_json | sed 's/"//g'`

alignments_md5sums=`jq .alignments_md5sums $pipeline_json | sed 's/"//g'`


peaks=`jq .peaks $pipeline_json | sed 's/"//g'`

peaks_md5sum=`jq .peaks_md5sum $pipeline_json | sed 's/"//g'`

assay_type=`jq .assay_type $pipeline_json | sed 's/"//g'`


encode_access_key=$2

encode_secret_key=$3
dst_dir=$4

# the place where the results of the pipeline run will be stored
# either mnt or gcp. If "mnt" then output files are stored in 
# --mnt target, or if "gcp" then the files are uploaded to gcp


# create log file
logfile=$dst_dir/preprocess_$experiment.log
touch $logfile


blacklist=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/blacklist_slop1057.bed

# Step 0. Create all required directories

reference_dir=/scratch/groups/akundaje/anusri/chromatin_atlas/reference/

# directory to store downloaded files
downloads_dir=${dst_dir}downloads
echo $( timestamp ): "mkdir" $downloads_dir | tee -a $logfile
mkdir $downloads_dir

# directory to store intermediate preprocessing files
# (merged bams, bedGraphs)
intermediates_dir=${dst_dir}intermediates
echo $( timestamp ): "mkdir" $intermediates_dir | tee -a $logfile
mkdir $intermediates_dir

# directory to store bigWigs
bigWigs_dir=${dst_dir}bigWigs
echo $( timestamp ): "mkdir" $bigWigs_dir | tee -a $logfile
mkdir $bigWigs_dir


# Step 2. download bam files and peaks file

# 2.1 download unfiltered alignments bams
download_file "$unfiltered_alignments" "bam" \
"$unfiltered_alignments_md5sums" 1 $logfile $encode_access_key \
$encode_secret_key $downloads_dir

# 2.2 download alignments bams
download_file "$alignments" "bam" "$alignments_md5sums" 1 $logfile \
$encode_access_key $encode_secret_key $downloads_dir


if [ "$has_control" = "True" ]
then
    # 2.3 download control unfiltered alignmentsbams
    download_file "$control_unfiltered_alignments" "bam" \
    "$control_unfiltered_alignments_md5sums" 1 $logfile $encode_access_key \
    $encode_secret_key $downloads_dir

    # 2.4 download control alignments bams
    download_file "$control_alignments" "bam" "$control_alignments_md5sums" 1 \
    $logfile $encode_access_key $encode_secret_key $downloads_dir
fi

# 2.5 download peaks file
download_file $peaks "bed.gz" $peaks_md5sum 1 $logfile $encode_access_key \
$encode_secret_key $downloads_dir

wait_for_jobs_to_finish "Download"

echo "mv $downloads_dir/*.bed.gz $downloads_dir/peaks.bed.gz"

mv $downloads_dir/*.bed.gz $downloads_dir/peaks.bed.gz

echo $( timestamp ): [$!] " bedtools intersect -v -a" $downloads_dir"/peaks.bed.gz -b" $blacklist "| gzip >" $downloads_dir/peaks_no_blacklist.bed.gz

bedtools intersect -v -a $downloads_dir/peaks.bed.gz -b $blacklist | gzip > $downloads_dir/peaks_no_blacklist.bed.gz

# Step 3. preprocess

# 3.1 preprocess experiment bams
./preprocessing.sh $experiment "$unfiltered_alignments" "$alignments" \
$downloads_dir $intermediates_dir $bigWigs_dir  $reference_dir \
$logfile  $assay_type&

echo $( timestamp ): [$!] "./preprocessing.sh" $experiment \
\"$unfiltered_alignments\" \"$alignments\" $downloads_dir $intermediates_dir \
$bigWigs_dir $reference_dir $logfile $assay_type | tee -a $logfile

wait_for_jobs_to_finish "Preprocessing"

# Step 4. Check if ATAC/DNASE shifts are correct
# create pwm image form bigwig
tag=""

if [ "$assay_type" = "DNase-seq" ] ; then

    echo $( timestamp ): "
        build_pwm_from_bigwig.py \\
        -i $bigWigs_dir/$experiment$tag.bigWig \\
        -g $reference_dir/hg38.genome.fa \\
        -o $bigWigs_dir/$experiment$tag.png \\
        -c \"chr20\" \\
        -cz $reference_dir/chrom.sizes \\
        -pw 8 \\
        -pg dnase_motif_pwm_8width.json" | tee -a $logfile
    
    python \
        build_pwm_from_bigwig.py \
        -i $bigWigs_dir/$experiment$tag.bigWig \
        -g $reference_dir/hg38.genome.fa \
        -o $bigWigs_dir/$experiment$tag.png \
        -c "chr20" \
        -cz $reference_dir/chrom.sizes \
        -pw 8 \
        -pg dnase_motif_pwm_8width.json 

elif [ "$assay_type" = "ATAC-seq" ] ; then

    echo $( timestamp ): "
        build_pwm_from_bigwig.py \\
        -i $bigWigs_dir/$experiment$tag.bigWig \\
        -g $reference_dir/hg38.genome.fa \\
        -o $bigWigs_dir/$experiment$tag.png \\
        -c \"chr20\" \\
        -cz $reference_dir/chrom.sizes \\
        -pw 24 \\
        -pg tn5_motif_pwm_24width.json" | tee -a $logfile
    
    python \
        build_pwm_from_bigwig.py \
        -i $bigWigs_dir/$experiment$tag.bigWig \
        -g $reference_dir/hg38.genome.fa \
        -o $bigWigs_dir/$experiment$tag.png \
        -c "chr20" \
        -cz $reference_dir/chrom.sizes \
        -pw 24 \
        -pg tn5_motif_pwm_24width.json 

else
    echo "unknown assay type " $assay_type
    exit 1
fi

