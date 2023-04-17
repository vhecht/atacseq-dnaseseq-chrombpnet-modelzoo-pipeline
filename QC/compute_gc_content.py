import numpy as np
import os
import h5py
import argparse
import pandas as pd
import scipy

def parse_args():
	parser = argparse.ArgumentParser()
	parser.add_argument("-m", "--modisco_dir", required=True, type=str)
	args = parser.parse_args()
	return args

def dna_to_one_hot(seqs):
	"""
	Converts a list of DNA ("ACGT") sequences to one-hot encodings, where the
	position of 1s is ordered alphabetically by "ACGT". `seqs` must be a list
	of N strings, where every string is the same length L. Returns an N x L x 4
	NumPy array of one-hot encodings, in the same order as the input sequences.
	All bases will be converted to upper-case prior to performing the encoding.
	Any bases that are not "ACGT" will be given an encoding of all 0s.
	"""
	seq_len = len(seqs[0])
	assert np.all(np.array([len(s) for s in seqs]) == seq_len)

	# Join all sequences together into one long string, all uppercase
	seq_concat = "".join(seqs).upper()

	one_hot_map = np.identity(5)[:, :-1]

	# Convert string into array of ASCII character codes;
	base_vals = np.frombuffer(bytearray(seq_concat, "utf8"), dtype=np.int8)

	# Anything that's not an A, C, G, or T gets assigned a higher code
	base_vals[~np.isin(base_vals, np.array([65, 67, 71, 84]))] = 85

	# Convert the codes into indices in [0, 4], in ascending order by code
	_, base_inds = np.unique(base_vals, return_inverse=True)

	# Get the one-hot encoding for those indices, and reshape back to separate
	return one_hot_map[base_inds].reshape((len(seqs), seq_len, 4))

def sp1_correlation(motif_seq):
	'''
	Given a motif sequence, determines if it is sufficiently highly correlated to the SP1 motif
	We do this because SP1 is purely GC and we don't want to classify these as bad motifs
	'''
	#Convert motif and SP1 reference to one-hot
	motif_onehot = dna_to_one_hot([motif_seq])[0]
	sp1_forward, sp1_backward = "CCCCGCCCCC", "GGGGGCGGGG"
	sp1_onehot, sp1_backward_onehot = dna_to_one_hot([sp1_forward, sp1_backward])
	#Calculate forward and backward correlations
	forward_corr = scipy.signal.correlate2d(motif_onehot, sp1_onehot)
	backward_corr = scipy.signal.correlate2d(motif_onehot, sp1_backward_onehot)
	#Take maximum
	return max(forward_corr.max(), backward_corr.max()) / len(sp1_forward)


def trim_motif_new(cwm, motif, trim_threshold=0.3):
	"""
	Given the PFM and motif (both L x 4 arrays) (the motif could be the
	PFM itself), trims `motif` by cutting off flanks of low information
	content in `pfm`. `min_ic` is the minimum required information
	content. If specified this trimmed motif will be extended on either
	side by `pad` bases.
	If no base passes the `min_ic` threshold, then no trimming is done.
	"""
	
	score = np.sum(np.abs(cwm), axis=1)
	trim_thresh = np.max(score) * trim_threshold  # Cut off anything less than 30% of max score
	pass_inds = np.where(score >= trim_thresh)[0]
	trimmed = motif[np.min(pass_inds): np.max(pass_inds) + 1]
 
	if not trimmed.size:
		return motif
	
	return trimmed


def get_bad_seqlets(modisco_obj):
	'''
	Given a modisco h5py file, this function looks at the motifs in metacluster 0 and returns the following:
	total_gc_seqlets - the total number of seqlets for all motifs that are 100% GC content
	total_seqlets - the total number of seqlets for all motifs
	'''
	dna_dict = {0:"A", 1:"C", 2:"G", 3:"T"}
	bad_motifs = 0
	total_bad_seqlets, total_seqlets = 0, 0
	metacluster = modisco_obj['metacluster_idx_to_submetacluster_results']["metacluster_0"]
	all_pattern_names = [x.decode("utf-8") for x in list(metacluster["seqlets_to_patterns_result"]["patterns"]["all_pattern_names"][:])]
	for pattern_name in all_pattern_names:
		#We get the ppm, num_seqlets, and cwm
		num_seqlets = len(metacluster['seqlets_to_patterns_result']['patterns'][pattern_name]['seqlets_and_alnmts']['seqlets'])
		total_seqlets += num_seqlets
		cwm = np.array(metacluster['seqlets_to_patterns_result']['patterns'][pattern_name]["task0_contrib_scores"]['fwd'])
		#We then trim the motif
		trimmed = trim_motif_new(cwm, cwm)
		#We store the total seqlets for the motif
		#If the motif has 100% GC or AT content, then we add it to the total_gc_seqlets as well
		#One exception is the SP1 motif...for the exclusive GC ones, we test the CWM against the SP1 motif
		#We don't want to classify those as problem cases
		motif_seq = np.argmax(trimmed, 1)
		if not (0 in motif_seq or 3 in motif_seq):
			cwm_letters = ''.join(map(lambda x: dna_dict[x], np.argmax(cwm, 1)))
			if sp1_correlation(cwm_letters) >= 0.9:
				continue
			total_bad_seqlets += num_seqlets
		if not (1 in motif_seq or 2 in motif_seq):
			total_bad_seqlets += num_seqlets
	return total_bad_seqlets, total_seqlets


def main():

	args = parse_args()
	modisco = h5py.File(args.modisco_dir)
	profile_bad, profile_total = get_bad_seqlets(modisco)
	profile_ratios = profile_bad / profile_total
	print(profile_ratios)


if __name__ == "__main__":
	main()
