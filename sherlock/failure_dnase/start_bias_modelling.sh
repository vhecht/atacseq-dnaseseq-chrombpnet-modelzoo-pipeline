#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
bias_threshold=$5
fold_num=$6
  
if [[ -f  $oak_dir/$experiment/preprocessing/bigWigs/$experiment.bigWig ]] ; then
    if [[ -f $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num/bias_model/models/$experiment"_bias.h5" ]] ; then
        echo "skipping modeling"
        if [[ -f $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num/bias_model/evaluation/$experiment"_overall_report.pdf" ]] ; then
            echo "skipping html creation"
            #echo $experiment"  "
        else
            #echo $experiment" no html  "
            echo "  "
            #cores=1
            #sbatch --export=ALL --requeue \
            #    -J $experiment.html \
            #    -p owners,akundaje -t 15:00:00 \
            #    -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            #    --mem=30G \
            #    -o $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num/bias_model/evaluation/log.o \
            #    -e $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num/bias_model/evaluation/log.e \
            #    run_bias_modelling_html.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/ $bias_threshold $fold_num chrombpnet_model_feb20_fold_$fold_num
        fi
    else
        #echo $experiment" no model  "
        mkdir $output_dir/$experiment/
        #rm -r $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num/bias_model/
        mkdir $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num
        mkdir $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num/bias_model/
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.modelling \
            -p owners,akundaje -t 24:00:00 \
            -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            --mem=30G \
            -o $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num/bias_model/modelling.log.o \
            -e $output_dir/$experiment/chrombpnet_model_feb20_fold_$fold_num/bias_model/modelling.log.e \
            run_bias_modelling.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/ $bias_threshold $fold_num chrombpnet_model_feb20_fold_$fold_num
        echo " "

    fi
else
    echo "skipping experiment directory creation"
    echo "do preprocessing first for dataset "$experiment
    echo " "
fi






