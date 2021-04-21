#!/bin/bash
#$ -S /bin/bash
#$ -N LDprune
#$ -cwd
#$ -pe smp 4
plink19 --noweb --allow-no-sex --bfile $1 --indep 50 5 2 --out $1_pruned
plink19 --noweb --allow-no-sex --bfile $1 --extract $1_pruned.prune.in --make-bed --out $1_pruned_for_genome
plink19 --noweb --allow-no-sex --bfile $1_pruned_for_genome --genome --out $1_genome

awk '$7<0.05 {print $1,$2"\t"$3,$4}' $1_genome.genome > Failed_IBD_pairs_mz
awk '$1==$3 {print $0}' Failed_IBD_pairs_mz > id_dup_ok
awk '$1!=$3 {print $0}' Failed_IBD_pairs_mz > id_dup_problem
grep -vf <(cut -f1 -d" " id_dup_ok) $1.fam | cut -f1 -d " " | sort -u > id_notfound_dup
