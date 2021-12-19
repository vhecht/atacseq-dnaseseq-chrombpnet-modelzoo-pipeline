version 1.0

task run_modelling {
	input {
		String experiment		
		File reference_file
		File chrom_sizes
		Array [File] bigwigs
		File peaks
		File non_peaks
		File bias_model
		File fold_json
  	}	
	command {
		#create data directories and download scripts
		cd /; mkdir my_data
		cd /my_data
		git clone https://github.com/kundajelab/chromatin-atlas-anvil.git
		chmod -R 777 chromatin-atlas-anvil
		cd chromatin-atlas-anvil/anvil/modeling

		## modelling

		echo "run modelling_pipeline.sh" ${experiment} ${reference_file} ${chrom_sizes} ${sep=',' bigwigs} ${peaks} ${non_peaks} ${bias_model} ${fold_json}

		bash run modelling_pipeline.sh ${experiment} ${reference_file} ${chrom_sizes} ${sep=',' bigwigs} ${peaks} ${non_peaks} ${bias_model} ${fold_json}

		echo "copying all files to cromwell_root folder"
		
		mkdir /cromwell_root/model/
		cp /project/model/*.h5 /cromwell_root/

		cp /project/model/chrombpnet_norm_jsd.txt /cromwell_root/chrombpnet_norm_jsd.txt
		cp /project/model/chrombpnet_wo_bias_norm_jsd.txt /cromwell_root/chrombpnet_wo_bias_norm_jsd.txt
		cp /project/model/bias_norm_jsd.txt /cromwell_root/bias_norm_jsd.txt


		cp /project/model/chrombpnet_pearson_cor.txt /cromwell_root/chrombpnet_cts_pearson_peaks.txt
		cp /project/model/chrombpnet_wo_bias_pearson_cor.txt /cromwell_root/chrombpnet_wo_bias_cts_pearson_peaks.txt
		cp /project/model/bias_pearson_cor.txt /cromwell_root/bias_cts_pearson_peaks.txt

		cp /project/model/tn5_footprints/chrombpnet_wo_bias_footprints_score.txt /cromwell_root/bias_correction_status.txt
		
	}
	
	output {
		Array[File] model = glob("model/*")
		String bias_correction_status = read_string("bias_correction_status.txt")
		Float chrombpnet_profile_jsd_peaks = read_float("chrombpnet_norm_jsd.txt")
		Float chrombpnet_wo_bias_profile_jsd_peaks = read_float("chrombpnet_wo_bias_norm_jsd.txt")
		Float bias_profile_jsd_peaks = read_float("bias_norm_jsd.txt")
		Float chrombpnet_cts_pearson_peaks = read_float("chrombpnet_cts_pearson_peaks.txt")
		Float chrombpnet_wo_bias_cts_pearson_peaks = read_float("chrombpnet_wo_bias_cts_pearson_peaks.txt")
		Float bias_cts_pearson_peaks = read_float("bias_cts_pearson_peaks.txt")
	
	}

	runtime {
		docker: 'kundajelab/chrombpnet-lite'
		memory: 32 + "GB"
		bootDiskSizeGb: 100
		disks: "local-disk 250 HDD"
		gpuType: "nvidia-tesla-p100"
		gpuCount: 1
		nvidiaDriverVersion: "418.87.00"
		preemptible: 1
  		maxRetries: 3 
	}
}

workflow modelling {
	input {
		String experiment		
		File reference_file
		File chrom_sizes
		Array [File] bigwigs
		File peaks
		File non_peaks
		File bias_model
		File fold_json
	}

	call run_modelling {
		input:
			experiment = experiment,
			reference_file = reference_file,
			chrom_sizes = chrom_sizes,
			bigwigs = bigwigs,
			peaks = peaks,
			non_peaks = non_peaks,
			bias_model = bias_model,
			fold_json = fold_json
 	}
	output {
		Array[File] model = run_modelling.model
		String bias_correction_status = run_modelling.bias_correction_status
		Float chrombpnet_profile_jsd_peaks = run_modelling.chrombpnet_profile_jsd_peaks
		Float chrombpnet_wo_bias_profile_jsd_peaks = run_modelling.chrombpnet_wo_bias_profile_jsd_peaks
		Float bias_profile_jsd_peaks = run_modelling.bias_profile_jsd_peaks
		Float chrombpnet_cts_pearson_peaks = run_modelling.chrombpnet_cts_pearson_peaks
		Float chrombpnet_wo_bias_cts_pearson_peaks = run_modelling.chrombpnet_wo_bias_cts_pearson_peaks
		Float bias_cts_pearson_peaks = run_modelling.bias_cts_pearson_peaks
			
	}
}