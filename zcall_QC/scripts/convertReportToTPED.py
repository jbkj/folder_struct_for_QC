#! /usr/bin/python

# zCall: A Rare Variant Caller for Array-based Genotyping
# Jackie Goldstein
# jigold@broadinstitute.org
# May 8th, 2012

import sys
from optparse import OptionParser

### Parse Inputs from Command Line
parser = OptionParser()
parser.add_option("-R","--report",type="string",dest="report",action="store",help="genome studio report to call from")
parser.add_option("-O","--output",type="string",dest="outputROOT",action="store",help="output root")
(options, args) = parser.parse_args()

if options.report == None:
    print "specify GenomeStudio report file path with -R"
    sys.exit()

if options.outputROOT == None:
    print "specify output root with -O"
    sys.exit()


outTFAM = open(options.outputROOT + ".tfam", 'w')
outTPED = open(options.outputROOT + ".tped", 'w')
        

# Iterate through Illumina GenomeStudio Report
for line in open(options.report, 'r'):
    line = line.replace("\n", "")
    line = line.replace("\r", "")

    fields = line.split("\t")

    if line.find("Name") != -1: # header row -- write tfam info
        for i in range(3,len(fields), 3):
            id = fields[i].split(".")[0]
            out = [id, id, "0", "0", "-9", "-9"]
            outTFAM.write(" ".join(out) + "\n")

    else:
        snp = fields[0]
        chr = fields[1]
        pos = fields[2]

        out = [chr, snp, "0", pos]

        for i in range(3, len(fields), 3):
            gt = fields[i]
            if gt == "NC":
                gt = "00"
            out.append(gt[0])
            out.append(gt[1])
        
        outTPED.write(" ".join(out) + "\n")

                    
