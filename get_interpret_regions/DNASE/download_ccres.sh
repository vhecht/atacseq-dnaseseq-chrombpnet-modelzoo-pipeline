#!/usr/bin/env bash

# for ccre_lookup_in:
# download ccre_lookup from https://docs.google.com/spreadsheets/d/1AlxOeRbgvchg1UYDjoyi09iuszA1BavVaXOIuB32sKw/edit#gid=0
# copy and keep just columns A and F (and remove header), remove rows with missing ENCIDs for DNase
# save as CSV (easier to move from local machine to cluster)
ccre_lookup_in=$1
OAK_HOME=$2

download_url="http://users.wenglab.org/moorej3/Registry-cCREs-WG/V4-Files"

# for each row in ccre_lookup_in, download ccre input file (these are pretty small)
# save these in downloads directory for each ENCID
while read line
do
	ccre_suffix=$(echo $line | cut -f1 -d',')
	encid=$(echo $line | cut -f2 -d',')
	out_dir="${OAK_HOME}/chromatin-atlas-2022/DNASE/${encid}/preprocessing/downloads/ccre_v4"
	if [ ! -d "${out_dir}" ]
	then
		mkdir -p ${out_dir}
	fi
	echo "downloading $encid from ${download_url}/${ccre_suffix}"
	wget ${download_url}/${ccre_suffix} -O ${out_dir}/cre.bed.gz
done < "$ccre_lookup_in"




