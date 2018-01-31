import os, random


def random_AA_seq(length):
    seq = ''.join(random.choice('ACDEFGHIKLMNPQRSTVWY') for i in range(length))
    # return "TaxonA "+seq
    return seq


def appendFile(filepath, message):
    with open(filepath, "a") as f:
        f.write(message)


def toFastaSeq(name, seq, taxa):
    header = ">" + name + " [" + taxa + "]\n"
    return header + seq + "\n\n"


CreateFilename = "Test30AA.fasta"
CreateFolder = "Sequences/"
filepath = os.path.join(CreateFolder, CreateFilename)

proteinLength = 30

ABFuseCount = 1
BAFuseCount = 1
ACount = 20
BCount = 20

A = random_AA_seq(proteinLength)
B = random_AA_seq(proteinLength)

open(filepath, "w")

length = len(A)
mid = length / 2

for i in range(ABFuseCount):
    appendFile(filepath, toFastaSeq("AB" + str(i + 1), A[0:mid] + B[mid:length], "test taxa"))

for i in range(BAFuseCount):
    appendFile(filepath, toFastaSeq("BA" + str(i + 1), B[0:mid] + A[mid:length], "test taxa"))

for i in range(ACount):
    appendFile(filepath, toFastaSeq("A" + str(i + 1), A, "test taxa"))

for i in range(BCount):
    appendFile(filepath, toFastaSeq("B" + str(i + 1), B, "test taxa"))
