reference_fasta=$1
regions=$2
output_prefix=$3
model_h5=$4
logfile=$5

function timestamp {
    # Function to get the current time with the new line character
    # removed

    # current time
    date +"%Y-%m-%d_%H-%M-%S" | tr -d '\n'
}

# create the log file
if [ -z "$logfile" ]
  then
    echo "No logfile supplied - creating one"
    logfile=$output_prefix".interpet.log"
    touch $logfile
fi

cd chrombpnet
echo $( timestamp ): "python $PWD/src/evaluation/interpret/interpret.py --genome=$reference_fasta --regions=$regions --output_prefix=$output_prefix --model_h5=$model_h5 --profile_or_counts counts" | tee -a $logfile
python $PWD/src/evaluation/interpret/interpret.py --genome=$reference_fasta --regions=$regions --output_prefix=$output_prefix --model_h5=$model_h5 --profile_or_counts counts
