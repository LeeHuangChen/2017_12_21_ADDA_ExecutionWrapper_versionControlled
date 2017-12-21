import os
import Configurations as conf
import subprocess
from cPickle import dump, load
from subprocess import call
import sys
import util
from Bio import SeqIO






def generateProtLenDict(sequenceFolder, filename):
	seqs=SeqIO.parse(os.path.join(sequenceFolder,filename),"fasta")
	protLenDict={}
	for seq in seqs:
		#protName=seq.description.split("[")[0].strip()
		protName=seq.id
		protLenDict[protName]=len(seq)
		#print protName
		#protLenDict[seq.id]=len(seq)
	return protLenDict 

def makeblastdb(sequenceFolder, filename):
	util.generateDirectoriesMult([conf.blastdbLogFolder,conf.blastdbFolder])
	inpath=os.path.join(sequenceFolder,filename)
	outpath=os.path.join(conf.blastdbFolder,filename)
	cmd=["makeblastdb","-in",inpath, "-out", outpath,"-dbtype", "prot"]
	proc=subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

	data, log = proc.communicate()

	f=open(os.path.join(conf.blastdbLogFolder,filename.replace(".fasta","")+"makeblastdb_log.txt"),"w")
	f.write(data+"\n"+log)
	f.close()

def alltoallBlastP(sequenceFolder,filename, outpath, outfmt=6, num_threads=4):
	util.generateDirectoriesMult([conf.alltoallLogFolder])
	dbpath=os.path.join(conf.blastdbFolder, filename)
	query=os.path.join(sequenceFolder, filename)
	cmd=["blastp", "-db", dbpath, "-query", query, "-outfmt", str(outfmt), "-out", outpath, "-num_threads", str(num_threads)]

	proc=subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

	data, log = proc.communicate()

	f=open(os.path.join(conf.alltoallLogFolder,filename.replace(".fasta","")+"blastp_log.txt"),"w")
	f.write(data+"\n"+log)
	f.close()

def main():

	util.generateDirectoriesMult([conf.protLenFolder,conf.alltoallFolder])
	
	sequenceFolder=conf.seqFolder
	seqfiles=os.listdir(sequenceFolder)

	for seqfile in seqfiles:
		
		protLenFilename=seqfile.replace(conf.seqExt,conf.protLenExt)
		#generate protein lengths
		with open(os.path.join(conf.protLenFolder,protLenFilename),"wb") as f:
			protLenDict=generateProtLenDict(sequenceFolder, seqfile)
			dump(protLenDict,f)

		makeblastdb(sequenceFolder,seqfile)
		outpath=os.path.join(conf.alltoallFolder,seqfile.replace(conf.seqExt,conf.alltoallExt))
		alltoallBlastP(sequenceFolder,seqfile, outpath)

if __name__=="__main__":
	main()