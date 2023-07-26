import deepdish
import h5py
import numpy as np
import argparse
import os
import bigwig_helper
import context
import pandas as pd
import pyfaidx

NARROWPEAK_SCHEMA = ["chr", "start", "end", "1", "2", "3", "4", "5", "6", "summit"]

def fetch_modisco_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--scores_prefix", type=str, required=True, help="Prefix to counts/profile h5 files. Will use prefix.{profile,counts}_scores.h5")
    parser.add_argument("-p","--profile_or_counts", type=str, required=True, help="Scoring method to use, profile or counts scores")
    parser.add_argument("-o", "--output_prefix", type=str, required=True, help="Output directory")
    parser.add_argument("-r", "--regions", type=str, required=True, help="bed regions for modisco")
    parser.add_argument("-g", "--genome", type=str, required=True, help="Genome fasta")

    args = parser.parse_args()

    return args


if __name__=="__main__":

    args = fetch_modisco_args()    

    # check if the output directory exists

    scoring_type = args.profile_or_counts
    if scoring_type=='profile':
        scores_path = args.scores_prefix + '.profile_scores_compressed.h5'
        print(" Scores path is {}".format(scores_path))
    elif scoring_type=='counts':
        scores_path  = args.scores_prefix+ '.counts_scores_compressed.h5'
        print(" Scores path is {}".format(scores_path))
    else:
        print("Enter a valid scoring type: counts or profile")
        
    assert(os.path.exists(scores_path))
    scores = deepdish.io.load(scores_path)

    # fetch regions from bed files

    regions_df = pd.read_csv(args.regions, sep='\t', names=NARROWPEAK_SCHEMA)
    genome = pyfaidx.Fasta(args.genome)

    print(scores['shap']['seq'])
    seqs = context.get_seq(regions_df, genome, scores['shap']['seq'].shape[2])
    scores['raw'] = {}
    scores['raw']['seq'] = np.transpose(seqs, (0, 2, 1))
    
    print(scores['shap']['seq'].shape)
    print(scores['raw']['seq'].shape)

    assert(scores['shap']['seq'].shape==scores['raw']['seq'].shape)

    deepdish.io.save("{}_temp_{}_scores.h5".format(args.output_prefix,scoring_type),
      scores,
      compression='blosc')

