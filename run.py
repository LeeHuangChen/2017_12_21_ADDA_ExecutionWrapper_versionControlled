import BlastAllToAll
import ConvertToADDA 
import rcm_module_tree
import RunADDA
import Configurations as conf
import os
import subprocess
from subprocess import call


def main():
	# print "\n0_BlastAllToAll:"
	# BlastAllToAll.main()
	# print "\n1_ConvertToADDA: "
	# ConvertToADDA.main()
	# print "\n2_rcm_module_tree:"
	# rcm_module_tree.main()
	# print "\n3_RunADDA:"
	# RunADDA.main(recompile=conf.recompileADDA)

	if conf.recompileADDA:
		print "make clean and making ADDA"
		#make clean the software
		cmd=["make", "clean", "-C",conf.addaFolder]
		proc=subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		proc.communicate()

		#make the software
		cmd=["make","-C",conf.addaFolder]
		proc=subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		proc.communicate()


	#import all of the filenames
	inputfilenames=os.listdir(conf.blastAlltoAllInput)
	inputfilenames.sort()

	for inputfilename in inputfilenames:
		print "\n1_ConvertToADDA: "
		ConvertToADDA.main(inputfilename)
		print "\n2_rcm_module_tree:"
		rcm_module_tree.main(inputfilename)
		print "\n3_RunADDA:"
		RunADDA.main(inputfilename)




if __name__=="__main__":
	main()