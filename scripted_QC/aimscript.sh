#!/bin/bash
# prepare plink files on aim snps only for pca analysis
plink --noweb --bfile $1  --allow-no-sex --extract aimSNPs.txt --recodeA --out output/aimexome

#removes phenotypic data (cols 2-6)
cut -d " " -f1,7-  output/aimexome.raw  > output/exomeaimsnps.txt

Rscript ./eigenstratPlink.r output/exomeaimsnps.txt
