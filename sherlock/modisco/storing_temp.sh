        if [[ $output_dir/$experiment/chrombpnet_model/interpret/full_$experiment.profile_scores.h5 ]] ; then
            cp -r $output_dir/$experiment/chrombpnet_model/interpret/ $oak_old_dir/$experiment/chrombpnet_model/
            mkdir $oak_dir/$experiment/
            mkdir $oak_dir/$experiment/full_feb15/
            modisco_dir=$oak_dir/$experiment/full_feb15/
            scores_prefix=$oak_old_dir/$experiment/chrombpnet_model/interpret/full_$experiment
            regions_prefix=$oak_old_dir/$experiment/chrombpnet_model/interpret/full_$experiment.interpreted_regions_profile.bed
            cell_type=$experiment

            cores=20
            score_type=profile
            sbatch --export=ALL --requeue \
                -J $experiment.modisco \
                -p owners,akundaje \
                -t 48:00:00 -c $cores --mem=150G \
                -o $modisco_dir/profile1.file.log.o \
                -e $modisco_dir/profile1.file.log.e \
                run_modisco_compressed.sh  $scores_prefix $modisco_dir $score_type $cell_type $output_dir/$experiment/ $oak_dir/$experiment/ $regions_prefix

        fi
