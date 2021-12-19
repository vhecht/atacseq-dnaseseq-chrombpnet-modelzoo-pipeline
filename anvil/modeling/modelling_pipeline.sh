#!/bin/bash

function timestamp {
    # Function to get the current time with the new line character
    # removed 
    
    # current time
    date +"%Y-%m-%d_%H-%M-%S" | tr -d '\n'
}

experiment=$1
reference_file=$2
chrom_sizes=$3
bigwigs=$4
peaks=$5
non_peaks=$6
bias_model=$7
fold=$8

mkdir /project
project_dir=/project

# create the log file
logfile=$project_dir/${1}_modeling.log
touch $logfile

# create the data directory
data_dir=$project_dir/data
echo $( timestamp ): "mkdir" $data_dir | tee -a $logfile
mkdir $data_dir

# create the reference directory
reference_dir=$project_dir/reference
echo $( timestamp ): "mkdir" $reference_dir | tee -a $logfile
mkdir $reference_dir

# create the model directory
model_dir=$project_dir/model
echo $( timestamp ): "mkdir" $model_dir | tee -a $logfile
mkdir $model_dir

# create the predictions directory with all peaks and all chromosomes
predictions_dir_all_peaks_all_chroms=$project_dir/predictions_and_metrics_all_peaks_all_chroms
echo $( timestamp ): "mkdir" $predictions_dir_all_peaks_all_chroms| tee -a $logfile
mkdir $predictions_dir_all_peaks_all_chroms

# create the predictions directory with all peaks and test chromosomes
predictions_dir_all_peaks_test_chroms=$project_dir/predictions_and_metrics_all_peaks_test_chroms
echo $( timestamp ): "mkdir" $predictions_dir_all_peaks_test_chroms| tee -a $logfile
mkdir $predictions_dir_all_peaks_test_chroms


echo $( timestamp ): "cp" $reference_file ${reference_dir}/hg38.genome.fa | \
tee -a $logfile 

echo $( timestamp ): "cp" $chrom_sizes ${reference_dir}/chrom.sizes |\
tee -a $logfile 

echo $( timestamp ): "cp" $chroms_txt ${reference_dir}/hg38_chroms.txt |\
tee -a $logfile 


# copy down data and reference

cp $reference_file $reference_dir/hg38.genome.fa
cp $chrom_sizes $reference_dir/chrom.sizes
cp $chroms_txt $reference_dir/hg38_chroms.txt


# Step 1: Copy the bigwig and peak files

echo $bigwigs | sed 's/,/ /g' | xargs cp -t $data_dir/

echo $( timestamp ): "cp" $bigwigs ${data_dir}/ |\
tee -a $logfile 

# copy peaks
echo $( timestamp ): "cp" $peaks ${data_dir}/${experiment}_peaks.bed.gz |\
tee -a $logfile 

cp $peaks ${data_dir}/${experiment}_peaks.bed.gz

echo $( timestamp ): "gunzip" ${data_dir}/${experiment}_peaks.bed.gz |\
tee -a $logfile 

gunzip ${data_dir}/${experiment}_peaks.bed.gz

#copy non-peaks
echo $( timestamp ): "cp" $non_peaks ${data_dir}/${experiment}_non_peaks.bed.gz |\
tee -a $logfile 

cp $non_peaks ${data_dir}/${experiment}_non_peaks.bed.gz

echo $( timestamp ): "gunzip" ${data_dir}/${experiment}_non_peaks.bed.gz |\
tee -a $logfile 

gunzip ${data_dir}/${experiment}_non_peaks.bed.gz

#set threads based on number of peaks

if [ $(wc -l < ${data_dir}/${experiment}_peaks.bed) -lt 3500 ];then
    threads=1
else
    threads=2
fi


bigwig_path=${data_dir}/$experiment.bigWig
overlap_peak=${data_dir}/${experiment}_peaks.bed
nonpeaks=${data_dir}/${experiment}_non_peaks.bed 

# defaults
inputlen=2114
outputlen=1000
filters=512
n_dilation_layers=8
negative_sampling_ratio=0.1
# this script does the following -  
# (1) filters your peaks/nonpeaks (removes outliers and removes edge cases and creates a new filtered set)
# (2) scales the given bias model on the non-peaks
# (3) Calculates the counts loss weight 
# # (4) Creates a TSV file that can be loaded into the next step
python src/helpers/hyperparameters/find_chrombpnet_hyperparams.py \
       --genome=${reference_dir}/hg38.genome.fa \
       --bigwig=$bigwig_path \
       --peaks=$overlap_peak \
       --nonpeaks=$nonpeaks \
       --negative-sampling-ratio=$negative_sampling_ratio \
       --outlier_threshold=0.99 \
       --chr_fold_path=$fold \
       --inputlen=$inputlen \
       --outputlen=$outputlen \
       --max_jitter=10 \
       --filters=$filters \
       --n_dilation_layers=$n_dilation_layers \
       --bias_model_path=$bias_model \
       --output_dir=$model_dir 

# this script does the following -  
# (1) trains a model on the given peaks/nonpeaks
# (2) The pearmetes file input to this script should be TSV seperated and should have the following values
# (3) Calculates the counts loss weight 
# (4) Creates a TSV file that can be loaded into the next step
python src/training/train.py \
       --genome=${reference_dir}/hg38.genome.fa \
       --bigwig=$bigwig_path \
       --peaks=$model_dir/filtered.peaks.bed \
       --nonpeaks=$model_dir/filtered.nonpeaks.bed \
       --params=$model_dir/chrombpnet_model_params.txt \
       --output_prefix=$model_dir/model_new.0 \
       --negative-sampling-ratio=$negative_sampling_ratio \
       --chr_fold_path=$fold \
       --epochs=1 \
       --max_jitter=10 \
       --batch_size=64 \
       --architecture_from_file=src/training/models/chrombpnet_with_bias_model.py \
       --trackables logcount_predictions_loss loss logits_profile_predictions_loss val_logcount_predictions_loss val_loss val_logits_profile_predictions_loss 

# # predictions and metrics on the chrombpnet model trained
python src/training/predict.py \
        --genome=${reference_dir}/hg38.genome.fa \
        --bigwig=$bigwig_path \
        --peaks=$model_dir/filtered.peaks.bed \
        --nonpeaks=$model_dir/filtered.nonpeaks.bed \
        --chr_fold_path=$fold \
        --inputlen=$inputlen \
        --outputlen=$outputlen \
        --output_prefix=$model_dir/chrombpnet \
        --batch_size=256 \
        --model_h5=$model_dir/model_new.0.h5 \

# # predictions and metrics on the chrombpnet model without bias trained
python src/training/predict.py \
        --genome=${reference_dir}/hg38.genome.fa \
        --bigwig=$bigwig_path \
        --peaks=$model_dir/filtered.peaks.bed \
        --nonpeaks=$model_dir/filtered.nonpeaks.bed \
        --chr_fold_path=$fold \
        --inputlen=$inputlen \
        --outputlen=$outputlen \
        --output_prefix=$model_dir/chrombpnet_wo_bias \
        --batch_size=256 \
        --model_h5=$model_dir/model_new.0_wo_bias.h5 \

# # # predictions and metrics on the bias model trained
python src/training/predict.py \
        --genome=${reference_dir}/hg38.genome.fa \
        --bigwig=$bigwig_path \
        --peaks=$model_dir/filtered.peaks.bed \
        --nonpeaks=$model_dir/filtered.nonpeaks.bed \
        --chr_fold_path=$fold \
        --inputlen=$inputlen \
        --outputlen=$outputlen \
        --output_prefix=$model_dir/bias \
        --batch_size=256 \
        --model_h5=$model_dir/bias_model_scaled.h5 \


mkdir $model_dir/tn5_footprints
python src/evaluation/marginal_footprints/marginal_footprinting.py \
        -g ${reference_dir}/hg38.genome.fa \
        -r $model_dir/filtered.nonpeaks.bed \
        -chr "chr1" \
        -m $model_dir/model_new.0_wo_bias.h5 \
        -bs 256 \
        -o $model_dir/tn5_footprints/chrombpnet_wo_bias \
        -pwm_f src/evaluation/marginal_footprints/motif_to_pwm.tsv \
        -mo tn5_1,tn5_2,tn5_3,tn5_4,tn5_5
