#!/bin/sh

experiment=$1

echo "python run_combine_bigwigs_counts.py --encid $experiment"
python run_combine_bigwigs_counts.py --encid $experiment

