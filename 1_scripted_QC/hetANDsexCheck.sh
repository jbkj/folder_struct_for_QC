#!/bin/bash
#$ -S /bin/bash
#$ -N LDprune
#$ -cwd
#$ -l h_vmem=20G 
plink19  --bfile $1 --indep-pairphase 20000 2000 0.5 --out $1_pruned
plink19 --bfile $1 --extract $1_pruned.prune.in --make-bed --out $1_pruned_for_het
#heterozygosity
plink19 --bfile $1_pruned_for_het --het --out $1_inbreed
sed -e 's/[[:space:]]\+/ /g' output/inbreed.het > $1_inbreed.het.sep
#sexcheck
plink19  --bfile $1_pruned_for_het --check-sex --out $1
plink --bfile $1 --missing --chr 23 --out $1_chr23
