import os
import util
import Configurations as conf
import subprocess


def runADDA(processedDir, treeDir, nidDir):
    processedFilename = processedDir.split("/")[-1]
    # import configurations from the config file
    processedAppend = conf.addaAppend

    addaRawOutputFolder = conf.addaRawOutputFolder
    addaRawOutputAppend = conf.addaRawOutputAppend

    addaOutputFolder = conf.addaOutputFolder
    addaOutputAppend = conf.addaOutputAppend

    addaIndexFolder = conf.addaIndexFolder
    addaIndexAppend = conf.addaIndexAppend

    # generate the output folders
    util.generateDirectoriesMult([addaRawOutputFolder, addaOutputFolder, addaIndexFolder])

    # generate the index file for the ADDA Run
    links = processedDir
    exeDir = conf.addaIndexExeDir

    linksIndex = os.path.join(addaIndexFolder, processedFilename.replace(processedAppend, addaIndexAppend))

    cmd = [exeDir, "-n", links]
    # print exeDir
    # print links
    # print "exeDir", os.path.isfile(exeDir)
    # print "links", os.path.isfile(links)
    # #print "", os.path.isfile()
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    data, log = proc.communicate()

    with open(linksIndex, "w") as f:
        f.write(data)

    # run ADDA
    domain_trees = treeDir
    nidList = nidDir
    exeDir = conf.addaRunExeDir

    if conf.runDefultParameters:
        cmd = [exeDir, "-n", links, "-f", linksIndex, "-t", domain_trees, "-q", nidList]
    else:
        # parameters
        K = conf.K
        C = conf.C
        E = conf.E
        M = conf.M
        N = conf.N
        ii = conf.i
        v = conf.v
        d = conf.d
        # print "exeDir", os.path.isfile(exeDir)
        # print "links", os.path.isfile(links)
        # print "linksIndex", os.path.isfile(linksIndex)
        # print "domain_trees", os.path.isfile(domain_trees)
        # print "nidList", os.path.isfile(nidList)
        # #print "", os.path.isfile()
        cmd = [exeDir, "-K", str(K), "-C", str(C), "-E", str(E), "-M", str(M), "-N", str(N), "-i", str(ii), "-n", links,
               "-f", linksIndex, "-t", domain_trees, "-q", nidList]
    # with open("commands.txt","a") as f:
    # 	f.write(util.cmdToString(cmd))
    # 	f.write("\n")

    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    data, log = proc.communicate()

    writeDir = os.path.join(addaRawOutputFolder, processedFilename.replace(processedAppend, addaRawOutputAppend))
    with open(writeDir, "w") as f:
        f.write(data)
    print log

    writeDir = os.path.join(addaOutputFolder, processedFilename.replace(processedAppend, addaOutputAppend))
    with open(writeDir, "w") as f:
        f.write(data.split("# final partitions\n")[-1])


def main(inputfile):
    # util.openfiles(["commands.txt"])
    # import configurations
    processedFolder = conf.addaProcessedInput
    processedAppend = conf.addaAppend

    treeFolder = conf.treeFolder
    treeAppend = conf.treeAppend

    nidListFolder = conf.nidListDir
    nidAppend = conf.nidAppend

    # processedFiles=os.listdir(processedFolder)

    # if recompile:
    # 	print "make clean and making ADDA"
    # 	#make clean the software
    # 	cmd=["make", "clean", "-C",conf.addaFolder]
    # 	proc=subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # 	proc.communicate()

    # 	#make the software
    # 	cmd=["make","-C",conf.addaFolder]
    # 	proc=subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # 	proc.communicate()

    # for i, processedFile in enumerate(processedFiles):
    # util.percent(i,len(processedFiles),len(processedFiles))

    processedDir = os.path.join(processedFolder, inputfile.replace(conf.alltoallExt, processedAppend))
    treeDir = os.path.join(treeFolder, inputfile.replace(conf.alltoallExt, treeAppend))
    nidDir = os.path.join(nidListFolder, inputfile.replace(conf.alltoallExt, nidAppend))
    runADDA(processedDir, treeDir, nidDir)


# print "ADDA Runs Completed."

if __name__ == "__main__":
    main(recompile=True)
