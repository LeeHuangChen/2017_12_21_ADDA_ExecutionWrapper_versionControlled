from class_2013_02_07_hsp import parse_blast
import sys
from cPickle import dump, load
import os
import numpy as np
from ete2 import Tree
import util
import Configurations as conf

min_module_length = 30


# blast_path='blast/M_mwag_SeqL_500_NFam_300_NFusions_4200_TEvo_6_NGen_5_adda.csv'
# tree_path = 'tree.tree'
# tree_diagram_path = 'treeDiag.txt'
# util.openfiles([tree_path,tree_diagram_path])


def make_pbs_runs():
	
	template="""#!/bin/bash
#PBS -S /bin/bash
#PBS -N batch_{0}
#PBS -l nodes=1:ppn=1,walltime=72:00:00,pmem=6000m
#PBS -M wz4@rice.edu
#PBS -V
#PBS -q serial_long
#PBS -m abe
#PBS -o /scratch/wz4/output/{0}_out
#PBS -e /scratch/wz4/output/{0}_err
echo "I ran on:"
cat $PBS_NODEFILE
{2} -u {1} '{3}' '{4}' '{5}'
cat $PBS_NODEFILE
"""
	for batch_index, taxa_dir in enumerate(os.listdir(blast_dir_path)):
		open("/home/wz4/pbs/%d.pbs" % batch_index,'w').write(template.format(batch_index, '/home/wz4/2013_04_17_rcm_module_tree.py', '/home/wz4/epd-7.3-1-rh5-x86_64/bin/python', 
																			 os.path.join(blast_dir_path, taxa_dir), 
																			 os.path.join(output_tree_dir_path, '%d_%s.tree' % (batch_index, taxa_dir.replace(' ', '_'))),
																			 os.path.join(output_tree_diagram_dir_path, '%d_%s.diagram' % (batch_index, taxa_dir.replace(' ', '_') ))))

	return

class TreeNodeIDgenerator():
	def __init__(self):
		self.id = -1

		return

	def generate(self):
		self.id += 1
		
		return self.id

	def reset(self):
		self.id = -1
		return

idgen = TreeNodeIDgenerator()

def _split_rcm(rcm, t):
	"""
	| a | a | a | a | a | a | a | a |
	  |                               |
   startpos                         endpos
	  |                               |
	 x's startpoint               x's endpoint
	endpos - startpos == number of amino acids in the region
	but the number of break points are one more than the number of amino acids
	"""

	chi_sq_vec = np.zeros(t.endpos - t.startpos + 1)
	for x in xrange(t.startpos, t.endpos + 1):
		# from the real start position (which is t.startpos)
		# to the real end position + 1 (which is t.endpos, but in xrange you should specify one past last)
		i11 = float(np.sum(rcm[t.startpos:x, t.startpos:x]))
		i22 = float(np.sum(rcm[x:t.endpos,   x:t.endpos]))
		i12 = float(np.sum(rcm[t.startpos:x, x:t.endpos]))
		i21 = i12
		
		row1 = i11 + i12
		row2 = i21 + i22
		col1 = i11 + i21
		col2 = i12 + i22
		
		# l1 = x-t.startpos
		# l2 = t.endpos - x
		
		a = i11 * i22 - i21 * i12
		# print "i11: %1.0f\ti22: %1.0f\ti12 and i21: %1.0f" % (i11, i22, i12)
		
		n = row1 * row2 * col1 * col2
		if n > 0.0:
			chi_sq_vec[x - t.startpos] = a * a / n
		else:
			chi_sq_vec[x - t.startpos] = 0.0

	# print chi_sq_vec

	# if chi square statistics is 0, return no split
	if np.max(chi_sq_vec) == 0.0:
		return
	else:
		# the split point
		xmax = np.argmax(chi_sq_vec) + t.startpos
		# if x - t.startpos < min_module_length or t.endpos - x < min_module_length:
		#   return

		if xmax - t.startpos > min_module_length:
			# from t.startpos to x - 1
			c = Tree()
			c.node_id = idgen.generate()
			c.name = "%d-%d" % (t.startpos, xmax)
			c.add_feature("startpos", t.startpos)
			c.add_feature("endpos", xmax)
			t.add_child(c)
			_split_rcm(rcm, c)

		if t.endpos - xmax > min_module_length:
			# from x to t.endpos - 1
			c = Tree()
			c.node_id = idgen.generate()
			c.name = "%d-%d" % (xmax, t.endpos)
			c.add_feature("startpos", xmax)
			c.add_feature("endpos", t.endpos)
			t.add_child(c)
			_split_rcm(rcm, c)

	return

def split_rcm(rcm):

	n=rcm.shape[0]
	idgen.reset()

	root=Tree()
	root.node_id = idgen.generate()
	root.name = "%d-%d" % (0,n)
	root.add_feature("startpos", 0)
	root.add_feature("endpos", n)
	
	_split_rcm(rcm, root)

	return root

def depth(node):

	if node.is_root():
		return 0
	else:
		return depth(node.up) + 1

def print_adda_tree_file(treeroot, tree_file_handle):
	
	# module tree format
	# nid     node    parent  depth   from    to
	for node in treeroot.traverse():
		if node.is_root():
			tree_file_handle.write('%d\t%d\t%d\t%d\t%d\n' % (node.node_id, node.node_id, depth(node), node.startpos, node.endpos - 1))
		else:
			tree_file_handle.write('%d\t%d\t%d\t%d\t%d\n' % (node.node_id, node.up.node_id, depth(node), node.startpos, node.endpos - 1))

	return

def adda_tree_string(qi,treeroot):
	output=""
	# module tree format
	# nid     node    parent  depth   from    to
	for node in treeroot.traverse():
		if node.is_root():
			line=('%s\t%d\t%d\t%d\t%d\t%d\n' % (qi,node.node_id, node.node_id, depth(node), node.startpos, node.endpos - 1))
			output=output+line
		else:
			line=('%s\t%d\t%d\t%d\t%d\t%d\n' % (qi,node.node_id, node.up.node_id, depth(node), node.startpos, node.endpos - 1))
			output=output+line

	return output

def compute_rcm_and_module_tree(blast_path,tree_path,tree_diagram_path, protLenDict, protNidDict, printProgress=True,progressHeader="",progressFooter=""):
	util.openfiles([tree_path,tree_diagram_path])
	print blast_path

	if os.path.exists(tree_path):
		processed = set()
		with open(tree_path) as f:
			for line in f:
				processed.add(line.split()[0])
		tree_file_handle = open(tree_path, 'a')
		tree_diagram_file_handle = open(tree_diagram_path, 'a')
	else:
		processed = set()
		tree_file_handle = open(tree_path, 'w')
		tree_diagram_file_handle = open(tree_diagram_path, 'w')
	
	cnt = 0
	

	with open(blast_path,'r') as f:
		inputStr=f.read()

	#for blastxmlpath in os.listdir(eco_blast_brief_path):
	lines=inputStr.split("\n")
	numlines=len(lines)
	currentGi=0
	rcm=""
	#these varaiables will contain the output temporarily for speeding up the runtime
	#writeDia=""
	writeTre=""
	hspsCount=0
	for i, line in enumerate(lines):
		if printProgress:
			util.percent(i,numlines,500,header=progressHeader,footer=progressFooter)
		if len(line)>0:
			#query_length=500
			(query_gi, hsps) = parse_blast(line)
			#print query_gi
			#print protNidDict
			query_length=protLenDict[protNidDict[int(query_gi)]]
			
			testing=True
			if query_gi!=None and hsps!=None:# this is true if it passes through the filters in parse_blast
				n = query_length
				hspsCount+=len(hsps)
				if currentGi!=query_gi:#this is a new protein so make a new rcm

					if testing:
						outstring=""
						for row in rcm:
							for entry in row:
								outstring+=str(entry)+","
							outstring+="\n"
						# with open("rcms.txt","a") as f:
						# 	f.write(outstring+"\n\n\n")


					if(rcm!=""):
						#print rcm
						#np.savetxt(os.path.join("rcmTest", str(currentGi)+'.csv'), rcm, delimiter=',', fmt='%d')
						

						tree_root = split_rcm(rcm)
						#if len(writeDia)>300:
						if len(writeTre)>30000:
							#print len(writeDia)
							#tree_diagram_file_handle.write(writeDia)
							tree_diagram_file_handle.flush()
							tree_file_handle.write(writeTre)
							tree_file_handle.flush()
							writeTre=""
							#writeDia=""
						#writeDia=writeDia+('%d (%d hsps)\n' % (cnt, hspsCount))
						#writeDia=writeDia+('%s\n\n' % tree_root)
						hspsCount=0
						#print len(writeDia)


						writeTre=writeTre+adda_tree_string(currentGi, tree_root)
						
						
						
					rcm = np.zeros((n,n), dtype=np.int)
					cnt += 1
					currentGi=query_gi
				sum_l = 0
				for hsp in hsps:
					sum_l += len(hsp.query_span)
					
					for i in xrange(hsp.query_span.start, hsp.query_span.end + 1):
						rcm[i-1,range(hsp.query_span.start-1, hsp.query_span.end)]+=1

				# tree_diagram_file_handle.write('%d (%d hsps)\n' % (cnt, len(hsps)))
				# tree_diagram_file_handle.flush()

				
				# tree_diagram_file_handle.write('%s\n%s\n\n' % (gi, tree_root))
				
				# os.fsync()
	tree_root = split_rcm(rcm)
	#writeDia=writeDia+('%s\n\n' % tree_root)
	writeTre=writeTre+adda_tree_string(currentGi, tree_root)
	#tree_diagram_file_handle.write(writeDia)
	tree_diagram_file_handle.flush()
	tree_file_handle.write(writeTre)
	tree_file_handle.flush()


def main(inputfile):
	addaProcessedInput=conf.addaProcessedInput
	treeDiagFolder=conf.treeDiagFolder
	treeFolder=conf.treeFolder



	util.generateDirectoriesMult([treeDiagFolder,treeFolder])



	# inputfiles=os.listdir(addaProcessedInput)
	# for i, inputfile in enumerate(inputfiles):


	#import protein length dictionary
	dictPath=os.path.join(conf.protLenFolder,inputfile.replace(conf.alltoallExt, conf.protLenExt))
	#print dictPath
	protLenDict=load(open(dictPath,"rb"))

	dictPath2=os.path.join(conf.NidToProteinTables,inputfile.replace(conf.alltoallExt, conf.NidToProteinAppend))
	protNidDict=load(open(dictPath2,"rb"))

	#determine the file paths
	blast_path= os.path.join(conf.addaProcessedInput,inputfile.replace(conf.alltoallExt,conf.addaAppend))
	tree_path = os.path.join(conf.treeFolder,inputfile.replace(conf.alltoallExt,conf.treeAppend))
	tree_diagram_path = os.path.join(conf.treeDiagFolder,inputfile.replace(conf.alltoallExt,conf.treeDiagAppend))

	#header=str(i)+"/"+str(len(inputfiles))+"\n"
	compute_rcm_and_module_tree(blast_path,tree_path,tree_diagram_path, protLenDict, protNidDict)
		
if __name__ == '__main__':
	# make_pbs_runs()
	main()