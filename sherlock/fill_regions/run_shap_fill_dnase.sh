#!/bin/sh

input_dir=$1
model1=$2
output=$3
experiment=$4
type=$5
bigwigp=$6

echo "singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif python get_bed_regions_to_fill_dnase.py -i $input_dir -if $model1  -o $output -e $experiment -t $type"
singularity exec /home/groups/akundaje/anusri/simg/tf-atlas_latest.sif python get_bed_regions_to_fill_dnase.py -i $input_dir -if $model1  -o $output -e $experiment -t $type

cd ../chrombpnet/

reference_fasta=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/hg38.genome.fa
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif nvidia-smi

function timestamp {
    # Function to get the current time with the new line character
    # removed

    # current time
    date +"%Y-%m-%d_%H-%M-%S" | tr -d '\n'
}

model_h5=$input_dir/$model1/chrombpnet_wo_bias.h5
chrom_sizes=/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/reference/chrom.sizes
old_output_prefix=$input_dir/$model1/interpret/full_$experiment
old_region=$input_dir/$model1/interpret/full_$experiment".interpreted_regions_"$type".bed"

echo $old_region


if [[ -f $old_region ]] ; then
	echo $old_region
else
	old_region=$input_dir/$model1/interpret/full_$experiment".interpreted_regions.bed"
	if [[ -f  $old_region ]] ; then
		echo $old_region
	else
		echo $old_region
		echo "not found"
		exit
	fi
fi

#output_prefix=$output
#output_bigwig_prefix=$bigwigp

mkdir /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/DNASE/$experiment/
mkdir /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/DNASE/$experiment/$model1/
mkdir /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/bigwigs/$experiment/
mkdir /scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/bigwigs/$experiment/$model1/

output_prefix=/scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/DNASE/$experiment/$model1/$experiment
output_bigwig_prefix=/scratch/groups/akundaje/anusri/chromatin_atlas/full_deepshaps/bigwigs/$experiment/$model1/$experiment

regions=$output".final."$type".bed"

echo $( timestamp ): " singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif python $PWD/src/evaluation/interpret/interpret_compressed_filling.py --genome=$reference_fasta --regions=$regions --old_regions=$old_region --output_prefix=$output_prefix --old_output_prefix=$old_output_prefix --model_h5=$model_h5 --profile_or_counts $type --chrom_sizes $chrom_sizes --output_bigwig_prefix $output_bigwig_prefix" | tee -a $logfile
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif python $PWD/src/evaluation/interpret/interpret_compressed_filling.py --genome=$reference_fasta --regions=$regions --old_regions=$old_region --output_prefix=$output_prefix --old_output_prefix=$old_output_prefix --model_h5=$model_h5 --profile_or_counts $type --chrom_sizes $chrom_sizes --output_bigwig_prefix $output_bigwig_prefix

