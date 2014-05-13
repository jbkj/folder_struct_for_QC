#!/bin/bash
#$ -S /bin/bash
#$ -N concordance
#$ -cwd
#$ -pe smp 2
$2/scripts/calibrateZ99.py -T $2/output/thresholds/threshold$1.txt -R $3 > $2/output/concordance/concordance$1.txt
