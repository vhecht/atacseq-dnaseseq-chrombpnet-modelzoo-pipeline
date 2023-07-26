import os
import shutil


encode_ids = [line.strip() for line in open("test_encid.txt").readlines()]

for encode_id in encode_ids[0:1]:

	command = "bash start_combine_counts.sh " + encode_id
	print(command)
	os.system(command)
