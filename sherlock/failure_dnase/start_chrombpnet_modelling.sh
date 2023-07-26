#!/bin/sh

experiment=$1
output_dir=$2
metadata_tsv=$3
oak_dir=$4
fold_num=$5

if [[ -f  $output_dir/$experiment/chrombpnet_model_feb22_fold_0/bias_model/models/$experiment"_bias.h5" ]] ; then
    if [[ -f $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/models/$experiment"_chrombpnet_nobias.h5" ]] ; then
	
        echo "skipping modeling"
	#rm -r $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/

        #echo " "
        #if [[ -f $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/evaluation/$experiment"_overall_report.pdf" ]] ; then
        #    echo " "
        #else
        #    echo $experiment" no html"
        #    #ls $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/evaluation/
        #    #ls $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/auxiliary/

        #    cores=1
        #    sbatch --export=ALL --requeue \
        #        -J $experiment.html \
        #        -p owners,akundaje -t 12:00:00 \
        #        -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
        #        --mem=80G \
        #       -o $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/evaluation/log.o \
        #        -e $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/evaluation/log.e \
        #        run_chrombpnet_modelling_html.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/  $fold_num chrombpnet_model_feb22_fold_$fold_num
        #
        #fi
    else
       # echo $experiment" no model"
         echo " "
       #  mkdir $output_dir/$experiment/
	if [ -d $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/ ]; then
	        rm -r $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/
	fi
        #mkdir $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num
        mkdir $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/
        cores=1
        sbatch --export=ALL --requeue \
            -J $experiment.modelling \
            -p owners,akundaje -t 24:00:00 \
            -G 1 -C "GPU_MEM:40GB|GPU_MEM:32GB|GPU_MEM:24GB|GPU_MEM:16GB|GPU_SKU:A100_PCIE|GPU_SKU:A100_SXM4|GPU_SKU:P100_PCIE|GPU_SKU:V100_PCIE|GPU_SKU:TITAN_V|GPU_SKU:V100S_PCIE|GPU_SKU:V100_SXM2" \
            --mem=80G \
            -o $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/modelling.log.o \
            -e $output_dir/$experiment/chrombpnet_model_feb22_fold_$fold_num/chrombpnet_model/modelling.log.e \
            run_chrombpnet_modelling_train.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/ $fold_num chrombpnet_model_feb22_fold_$fold_num  chrombpnet_model_feb22_fold_0
            #run_chrombpnet_modelling.sh $experiment $output_dir/$experiment/ $oak_dir/$experiment/ $fold_num chrombpnet_model_feb22_fold_$fold_num  chrombpnet_model_feb22_fold_0
    fi
else
    echo " "
    #echo "skipping experiment directory creation"
    #echo "train bias model first for dataset "$experiment

fi






