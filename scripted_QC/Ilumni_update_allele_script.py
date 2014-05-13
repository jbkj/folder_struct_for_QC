#!/usr/bin/env python
import argparse

parser=argparse.ArgumentParser(description='Crawls through .arp files and writes the SNP-positions down')
parser.add_argument('path', type=str, help='string with the full path for the file')
args = parser.parse_args()

path = args.path

csvfile = open(path,'r')
csvlines = csvfile.readlines()

line = []
SNPid = []

alleleA = []
alleleB = []


for n in range(8,len(csvlines)-24):
	line = csvlines[n].split(',')

	SNPid.append(line[1])

	strand = line[2]

	if(strand=='BOT'):

		if(line[3][1]=='A'):
			alleleA.append('T')
		elif(line[3][1]=='C'):
			alleleA.append('G')
		elif(line[3][1]=='G'):
			alleleA.append('C')
		elif(line[3][1]=='T'):
			alleleA.append('A')

		if(line[3][3]=='A'):
			alleleB.append('T')
		elif(line[3][3]=='C'):
			alleleB.append('G')
		elif(line[3][3]=='G'):
			alleleB.append('C')
		elif(line[3][3]=='T'):
			alleleB.append('A')

	else:
		alleleA.append(line[3][1])
		alleleB.append(line[3][3])



updateAlleleFile = open('alleles.list','w')
for m in range(0,len(SNPid)):
		updateAlleleFile.write(SNPid[m]+'\tA B\t'+alleleA[m]+' '+alleleB[m]+'\n')
