import os
import Configurations as conf
from cPickle import dump
import util


def main(inputFilename, printProgress=True):
    # import configurations from the config file
    EvalueCutoff = conf.EvalueCutoff
    inputFolder = conf.blastAlltoAllInput
    processedFolder = conf.addaProcessedInput
    tableFolder = conf.proteinToNidTables
    nidListFolder = conf.nidListDir
    processedAppend = conf.addaAppend
    tableAppend = conf.tableAppend
    nidListAppend = conf.nidAppend

    # generate the output folders
    util.generateDirectoriesMult([tableFolder, nidListFolder, processedFolder, conf.NidToProteinTables])

    inputFilenames = os.listdir(inputFolder)

    # for j, inputFilename in enumerate(inputFilenames):

    # the counter to determine which id we give to each of the protein names.
    # ADDA only uses id for proteins, not strings
    nidCounter = 1
    # The dictionary that stores the information on which nids associate with which proteins
    # key:protein names (string)
    # val:nids (int)
    protToNid = {}
    # The dictionary that stores the information on which nids associate with which proteins
    # key:nids (int)
    # val:protein names (string)

    NidToProt = {}

    # initiate the filenames for generated files
    # fileRootReplace="."+inputFilename.split(".")[-1]
    fileRootReplace = conf.alltoallExt

    # find the file Directories
    processedDir = os.path.join(processedFolder, inputFilename.replace(fileRootReplace, processedAppend))
    nidDir = os.path.join(nidListFolder, inputFilename.replace(fileRootReplace, nidListAppend))
    tableDir = os.path.join(tableFolder, inputFilename.replace(fileRootReplace, tableAppend))

    # open the files to clear the files
    util.openfiles([processedDir, tableDir, nidDir])

    # read the inputfile
    read = ""
    with open(os.path.join(inputFolder, inputFilename.replace(conf.seqExt, conf.alltoallExt)), 'r') as f:
        read = f.read()
    lines = read.split("\n")
    numLines = len(lines)
    write = ""
    writeNid = ""

    # input file format:
    # 0    , 1      , 2  , 3       , 4       , 5      , 6  , 7   , 8  , 9   , 10    , 11
    # query, subject, %id, alignlen, mismatch, gapopen, qst, qend, sst, send, Evalue, bitscore

    # output file format:
    # 0      1       2   3       4       5           6       7   8
    # nid1	nid2    %id	from1   to1     alignlen	from2   to2	Evalue	na	na
    # header=str(j)+"/"+str(len(inputFilenames))+"\n"
    # footer="\n"
    for i, line in enumerate(lines):
        # print percent to keep progress
        if printProgress:
            util.percent(i, numLines, 25, percentRange=(0, 80))

        inArr = line.split("\t")
        query = inArr[0]
        if query not in protToNid.keys():
            nid1 = nidCounter
            protToNid[query] = nid1
            NidToProt[nid1] = query
            writeLine = str(nidCounter) + "\t" + query + "\n"
            write = write + writeLine
            writeNid = writeNid + str(nidCounter) + "\n"
            # compile the writing in to memery so we can write it down in bulk (this saves runtime)
            if len(write) > 1000000:
                with open(tableDir, "a") as f:
                    f.write(write)
                with open(nidDir, "a") as f:
                    f.write(writeNid)
            nidCounter += 1
    # write the left over string into the file
    with open(tableDir, "a") as f:
        f.write(write)
    with open(nidDir, "a") as f:
        f.write(writeNid)

    dictpath = os.path.join(conf.NidToProteinTables, inputFilename.replace(fileRootReplace, conf.NidToProteinAppend))
    with open(dictpath, "wb") as f:
        dump(NidToProt, f)

    write = ""
    for i, line in enumerate(lines):
        if len(line) > 0:
            # print percent to keep progress
            if printProgress:
                util.percent(i, numLines, 5, percentRange=(80, 100))
            inArr = line.split("\t")
            query = inArr[0]
            subject = inArr[1]
            identity = inArr[2]
            alignlen = inArr[3]
            from1 = inArr[6]
            to1 = inArr[7]
            from2 = inArr[8]
            to2 = inArr[9]
            Evalue = inArr[10]
            repeat = (query == subject and ((from1 == from2 and to1 == to2) or (from1 == to2 and to1 == from2)))
            if float(Evalue) < EvalueCutoff and repeat == False:
                nid1 = protToNid[query]
                nid2 = protToNid[subject]

                writeLine = str(nid1) + "\t" + str(nid2) + "\t" + str(
                    identity) + "\t" + from1 + "\t" + to1 + "\t" + str(
                    alignlen) + "\t" + from2 + "\t" + to2 + "\t" + str(Evalue) + "\t" + "na" + "\t" + "na" + "\n"
                if len(write) < 1000000000:
                    write = write + writeLine
                else:
                    with open(processedDir, "a") as f:
                        write = write + writeLine
                        f.write(write)
                    write = ""
    with open(processedDir, "a") as f:
        f.write(write)


if __name__ == "__main__":
    main()
