#!/bin/bash
#$ -S /bin/bash
#$ -N LDprune
#$ -cwd
#$ -pe smp 4
plink --noweb --allow-no-sex --bfile $1 --indep 50 5 2 --out $1_pruned
plink --noweb --allow-no-sex --bfile $1 --extract $1_pruned.prune.in --make-bed --out $1_pruned_for_genome
plink --noweb --allow-no-sex --bfile $1_pruned_for_genome --genome --out $1_genome
