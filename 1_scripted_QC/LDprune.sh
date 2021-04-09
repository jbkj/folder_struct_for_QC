#!/bin/bash
#$ -S /bin/bash
#$ -N LDprune
#$ -cwd
#$ -l h_vmem=20G 
plink19 --noweb  --bfile $1 --indep-pairphase 20000 2000 0.5 --out $1_pruned
