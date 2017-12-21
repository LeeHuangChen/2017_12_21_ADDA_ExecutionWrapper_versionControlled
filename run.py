import BlastAllToAll
import ConvertToADDA 
import rcm_module_tree
import RunADDA
import Configurations as conf

def main():
	print "\n0_BlastAllToAll:"
	BlastAllToAll.main()
	print "\n1_ConvertToADDA: "
	ConvertToADDA.main()
	print "\n2_rcm_module_tree:"
	rcm_module_tree.main()
	print "\n3_RunADDA:"
	RunADDA.main(recompile=conf.recompileADDA)


if __name__=="__main__":
	main()