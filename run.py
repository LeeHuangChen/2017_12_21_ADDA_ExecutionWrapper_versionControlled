from src import BlastAllToAll, ConvertToADDA, rcm_module_tree, RunADDA, util
import Configurations as conf
import os
import subprocess
import time


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
        # make clean the software
        cmd = ["make", "clean", "-C", conf.addaFolder]
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        proc.communicate()

        # make the software
        cmd = ["make", "-C", conf.addaFolder]
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        proc.communicate()

    # import all of the filenames
    inputfilenames = os.listdir(conf.seqFolder)
    inputfilenames.sort()

    # create the file for timing information
    util.generateDirectories(conf.timingFolder)
    timingFileDir = os.path.join(conf.timingFolder, conf.timingFile)
    with open(timingFileDir, "w") as f:
        f.write("Time\tSampleName\n")
    # reset the log file
    open(os.path.join(conf.logFolder, conf.logFile),"w")

    for i, inputfilename in enumerate(inputfilenames):
        util.printL("\nProcessing "+inputfilename+" ("+str(i)+"/"+str(len(inputfilenames))+")\n")

        # util.printL("0_BlastAllToAll:\n")
        # BlastAllToAll.main(inputfilename)

        # util.printL("1_ConvertToADDA:\n")
        # ConvertToADDA.main(inputfilename)

        # start timer
        startTime = time.time()
        util.printL("2_rcm_module_tree:\n")
        rcm_module_tree.main(inputfilename.replace(conf.seqExt, conf.alltoallExt))
        util.printL("3_RunADDA:\n")
        RunADDA.main(inputfilename)

        # end timer
        endTime = time.time()
        timeDiff = endTime - startTime
        util.printL("rcm and adda completed in "+str(timeDiff)+" seconds.\n")

        with open(timingFileDir, "a") as f:
            f.write(str(timeDiff)+"\t"+inputfilename+"\n")


if __name__ == "__main__":
    main()
