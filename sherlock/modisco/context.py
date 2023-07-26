import os
import sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../chrombpnet/src/training/')))
#import utils.losses as losses
#from utils.data_utils import get_seq
from utils.data_utils import one_hot
#import tensorflow as tf
import numpy as np

def get_seq(peaks_df, genome, width):
    """
    Same as get_cts, but fetches sequence from a given genome.
    """
    vals = []
    peaks_used = []
    for i, r in peaks_df.iterrows():
        sequence = str(genome[r['chr']][(r['start']+r['summit'] - width//2):(r['start'] + r['summit'] + width//2)])
        vals.append(sequence)

    return one_hot.dna_to_one_hot(vals)


