import os

odir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/mean_deepshaps/ATAC/"
#ndir="/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/ATAC/"

#/oak/stanford/groups/akundaje/projects/chromatin-atlas-2022/mean_deepshaps/ATAC/ENCSR685ZMP/mean.profile.deepshap.log.e

num = 0
serr = 0
perr = 0
celline = 0

print(len(os.listdir(odir)))
data=open("../dnase_files/cellline_dnase_accession.tsv").readlines()
dataf = [line.strip() for line in data]
#print(dataf)
for encid in os.listdir(odir):
	path = odir + encid + "/" + encid + ".mean_shap.profile_scores_compressed.h5"
	
	if os.path.exists(path):
		num+=1
	else:
		path = odir + encid + "/mean.profile.deepshap.log.e"
		try:	
			data = open(path).read()
		except:
			continue
		if "main_bed" in data:
			serr+=1	
		elif "len(interpretation_files)==5" in data:
			perr+=1
			if str(encid.strip()) in dataf:
				#print(encid)
				celline+=1
		else:
			pass
			
		#else:
		#	print(path)

print(num)
print(serr)
print(perr)
print(celline)
