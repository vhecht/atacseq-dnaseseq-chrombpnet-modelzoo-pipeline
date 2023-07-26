#!/bin/sh

experiment=$1
dir=$2
modelname=$3
foldn=$4
modelpre=$5


modelp=$dir/$modelname/$modelpre".h5"
modelo=$dir/$modelname/new_model_formats/$modelpre

if [[ -f $modelo".tar.gz" ]] ; then
	rm $modelo".tar.gz"
fi

echo "singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif python get_new_tf_model_format.py -i $modelp -o $modelo"
singularity exec --nv /home/groups/akundaje/anusri/simg/tf-atlas_gcp-modeling.sif  python get_new_tf_model_format.py -i $modelp -o $modelo


if [[ -f $modelo/saved_model.pb ]] ; then
	cd $dir/$modelname/new_model_formats/
	tar -cf $modelpre".tar" $modelpre/
	rm -r $modelpre/
fi
