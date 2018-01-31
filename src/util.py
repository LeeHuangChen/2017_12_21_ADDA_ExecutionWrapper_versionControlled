import os
import stat
import sys
import Configurations as conf


def printL(string):
    generateDirectories(conf.logFolder)
    logDir = os.path.join(conf.logFolder, conf.logFile)
    with open(logDir, "a") as f:
        f.write(string)
        sys.stdout.write(string)
        sys.stdout.flush()


# generate all the directories needed for the given path (helper function)
def generateDirectories(path):
    folders = path.split("/")
    curdir = ""
    prevFolder = ""
    for folder in folders:
        prevFolder = curdir
        curdir = os.path.join(curdir, folder)
        if not os.path.exists(curdir):
            # print curdir
            # os.chmod(prevFolder,stat.S_IWRITE)
            os.mkdir(curdir)


def percent(i, length, numberNotification, header="", footer="", percentRange=(0, 100)):
    # scale=length/numberNotification
    # if scale>0:
    # 	if(i%scale==0):
    # 		progress=str(percentRange[0]+int(float(i)/float(length)*(percentRange[1]-percentRange[0])*100)/float(100))+"%"
    # 		write=header+progress+footer
    # 		print write
    progressbar(i, length, numberNotification)


def progressbar(i, length, numberNotification):
    scale = length / numberNotification
    if scale > 0:
        if (i % scale == 0):
            sys.stdout.write('*')
            sys.stdout.flush()


def openfiles(filenames):
    for filename in filenames:
        f = open(filename, "w")
        f.close()


def generateDirectoriesMult(paths):
    for path in paths:
        generateDirectories(path)


def cmdToString(cmd):
    write = ""
    for term in cmd:
        write += term + " "
    return write
