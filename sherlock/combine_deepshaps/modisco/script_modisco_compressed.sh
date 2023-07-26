scores_prefix=$1
score_type=$2
output_dir=$3
seqlets=$4
crop=$5
regions=$6
genome=$7

python run_modisco_compressed.py -s $scores_prefix -p $score_type -o $output_dir -m $seqlets -c $crop -r $regions -g $genome

