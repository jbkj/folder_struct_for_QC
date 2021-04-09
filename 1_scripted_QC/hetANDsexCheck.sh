#!/bin/bash
#$ -S /bin/bash
#$ -N LDprune
#$ -cwd
#$ -l h_vmem=20G 
plink19 --noweb  --bfile $1 --indep-pairphase 20000 2000 0.5 --out $1_pruned

plink19 --noweb --bfile $1 --extract $1_pruned.prune.in --make-bed --out $1_pruned_for_het
plink19 --bfile $1_pruned_for_het --het --out output/inbreed
sed -e 's/[[:space:]]\+/ /g' output/inbreed.het > output/inbreed.het.sep
plink19 --noweb --bfile $1_pruned_for_het --check-sex
