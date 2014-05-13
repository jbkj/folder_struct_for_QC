#! /usr/bin/python

import sys

report = sys.argv[1]
dropSamples = sys.argv[2]

samples = []
for line in open(dropSamples, 'r'):
    line = line.replace("\n", "")
    samples.append(line)

dropColumns = []
for line in open(report, 'r'):
    line = line.replace("\n", "")
    fields = line.split("\t")
    out = [fields[0],fields[1],fields[2]]
    
    if line.find("Name") != -1:
        for i in range(3, len(fields)):
            id = fields[i].split(".")[0]
            if id in samples:
                dropColumns.append(i)
            else:
                out.append(fields[i])
    else:
        for i in range(3, len(fields)):
            if i not in dropColumns:
                out.append(fields[i])

    print "\t".join(out)
