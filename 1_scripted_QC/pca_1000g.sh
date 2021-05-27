#!/bin/bash

parth="/emc/cbmr/data/chip/files"


plink19 --allow-no-sex --bfile $1 --extract $parth/ExomeChip_AIMs.txt --make-bed --out $1_exome_aims


plink19 --allow-no-sex --bfile $1_exome_aims --bmerge $parth/1000G/AIMs.1000G.v2.bed $parth/1000G/AIMs.1000G.v2.bim $parth/1000G/AIMs.1000G.v2.fam --make-bed --out $1_1000G_merged

needsToBeFlip=`cat $1_1000G_merged-merge.missnp | wc -l`
if [ $needsToBeFlip -gt 0 ]; then
   plink19 --allow-no-sex --bfile $1_exome_aims --flip $1_1000G_merged-merge.missnp --make-bed --out $1_flipped
   plink19 --allow-no-sex --bfile $1_flipped --bmerge $parth/1000G/AIMs.1000G.v2.bed $parth/1000G/AIMs.1000G.v2.bim $parth/1000G/AIMs.1000G.v2.fam --make-bed --out $1_1000G_merged
fi
plink19 --allow-no-sex --bfile $1_1000G_merged --geno 0.05 --make-bed --out $1_1000G_merged_geno0.05_filtered

#Takes a while

plink19 --allow-no-sex --bfile $1_1000G_merged_geno0.05_filtered --genome --out $1_1000G_merged_geno0.05_filtered_genome

plink19 --allow-no-sex --bfile $1_1000G_merged_geno0.05_filtered --read-genome $1_1000G_merged_geno0.05_filtered_genome.genome --cluster --mds-plot 10 --out Matrix_1000G_merged_filter_mds10

awk '{print $1"," "COH""," "8"}' $1.fam > $1_COH_8.csv
cat $parth/AA1000RG3new_1.0.csv $1_COH_8.csv > Matrix_origin.csv
