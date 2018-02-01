################
#  PARAMETERS  #
################

EvalueCutoff = 1e-3
# sequence length of all protein sequences studied.
# currently this version only supports sequences with the same length for analsys
# SeqLen=500


# configurations for running ADDA:

runDefultParameters = False

K = 73.70676
C = 8.33957
E = 0.05273
M = 1.417000
N = 0.008000
i = 100
d = 1
v = 1

# recompile ADDA before executing it
recompileADDA = False

####################
#  CONFIGURATIONS  #
####################

####################
# 0. BlastAllToAll #
####################
seqFolder = "InputFiles"
seqExt = ".fasta"

blastdbFolder = "Generated/0_BlastDB"

alltoallFolder = "Generated/0_BlastAllToAll"
alltoallExt = "_alltoall.txt"

# logFolders
alltoallLogFolder = "Generated/Logs/0_BlastAllToAll"
blastdbLogFolder = "Generated/Logs/0_MakeBlastDB"

######################
# 1. Convert to ADDA #
######################

protLenFolder = "Generated/ProteinLengths"
protLenExt = "_protLen.cPickle"

# Convert to ADDA configurations
blastAlltoAllInput = "Generated/0_BlastAllToAll"
alltoallExt = "_alltoall.txt"

addaProcessedInput = "Generated/1_ADDAProcessedInput/"
addaAppend = "_adda.tsv"

proteinToNidTables = "Generated/1_ProteinToNidTables/"
tableAppend = "_proteinTable.txt"

NidToProteinTables = "Generated/1_NidToProteinTables/"
NidToProteinAppend = "_NidToProt.cPickle"

nidListDir = "Generated/1_NidLists/"
nidAppend = "_nid.txt"

###################
# 2. Generate RCM #
###################

# Generate Residue Correlation Matrices (RCM) for ADDA input
treeFolder = "Generated/2_DomainTrees"
treeAppend = ".tree"

treeDiagFolder = "Generated/2_TreeDiagrams"
treeDiagAppend = "_treeDiag.txt"

###############
# 3. Run ADDA #
###############

# Run ADDA in Bulk

addaFolder = "OtherSoftware/adda-0.1.0/"
addaIndexExeDir = "OtherSoftware/adda-0.1.0/src/adda_index"
addaRunExeDir = "OtherSoftware/adda-0.1.0/src/adda"

addaIndexFolder = "Generated/3_ADDA_IndexFiles/"
addaIndexAppend = "_index.in"

addaRawOutputFolder = "Generated/3_ADDA_RawOutput/"
addaRawOutputAppend = "_addaRaw.txt"

addaOutputFolder = "Result/"
addaOutputAppend = "addaOut.txt"

# Log and timing results configurations
logFolder = "Result"
logFile = "log.txt"

timingFolder = "Result"
timingFile = "timingInfo.txt"

