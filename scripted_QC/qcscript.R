#Dette dokument er lavet udfra howto_exomeChip_GOT2D_140313.r 
#QC of the Human Core Exome Chip
cd /home/mngh/gastricbypass #Arbejdsmappe

## All files are saved in my home in gastricbypass directory
## make folder: mkdir raw, Gscripts

#Get data from Genome studio as a Full Data Table in text format with the following header:
#Name    Chr     Position        9275882091_R05C02.GType 9275882091_R05C02.X     9275882091_R05C02.Y     9275884066_R06C02.GType 9275884066_R06C02.X


## upload Full Data Table to my directory "raw": gastricbypass/raw/GastricBypass_FullTable.txt 
 
#chek if there are "." in files (except in the first line)          
sed '1d' GastricBypass_FullTable.txt | grep "\." 

# replace "," with "."
nohup sed 's/,/./g' GastricBypass_FullTable.txt> GastricBypass_FullTableMatrix.txt & # GastricBypass_FullTableMatrix.txt er den f?rdige matrix klar til QC

#upload zcall-scripts to brutus (version 2_3) og gemt i Gscripts
unzip zCall_Version2.3_GenomeStudio_EGT.zip
  
# make plink files
# Use convertReportToTPED.py script to turn the Genome Studio report into PLINK files (two files will be generalted GBall.tped and GBall.tfam in the folder: output)
mkdir output
python Gscripts/convertReportToTPED.py -O output/GBall -R raw/GastricBypass_FullTableMatrix.txt 
#GB: short for Gastric Bypass, 

# Look at the files
less -S output/GBall.tped
less -S output/GBall.tfam



# update allels vincent har k?rt christians ruby script for at genere allele.list filen (fil der indeholder allelernes baser)
plink --noweb --tfile output/GBall_minus_last_snp --update-alleles alleles.list --allow-no-sex --make-bed  --out output/GBall_update

#calculate missingness to show in R and to pick the right threshold
plink --noweb --bfile output/GBall_update --missing --allow-no-sex --out output/GBmissing 

R #Start R
#inside R write:
> dir() #check you are in the right folder
> imiss<-read.table("output/GBmissing.imiss",h=T) #detail missingness by individual 
> lmiss<-read.table("output/GBmissing.lmiss",h=T) #detail missingness by by SNP (locus)
> png("output/imiss.png")
> plot(sort(imiss$F_MISS))
> dev.off()
> q()

#look at the picture 
evince output/imiss.png

# clean with mind
plink --noweb --bfile output/GBall_update --mind 0.05 --allow-no-sex --make-bed --out output/GBall_mindcleanonly
# clean with geno
plink --noweb --bfile output/GBall_mindcleanonly --geno 0.05 --allow-no-sex --make-bed --out output/GBall_mindclean

#make plink files maf > 1% and maf <1%
plink --noweb --bfile output/GBall_mindclean --allow-no-sex --make-bed --maf 0.01 --out output/maf001 #means only include SNPs with MAF >= 0.01
plink --noweb --bfile output/maf001 --write-snplist --out output/snps_o_maf_001
plink --noweb --bfile output/GBall_mindclean --allow-no-sex --make-bed --exclude output/snps_o_maf_001.snplist --out output/maf_u001 #ekskluderer hyppige SNPs

# calculate heterozygosity (Inbreeding coefficients) for the  plink files maf < 1% and maf > 1%
plink --noweb --bfile output/GBall_mindclean --het --allow-no-sex --out output/inbreed
plink --noweb --bfile output/maf001 --het --allow-no-sex --out output/inbreed_maf001
plink --noweb --bfile output/maf_u001 --het --allow-no-sex --out output/inbreed_maf_u001

# make plots of heterozygosity and files with FID and IID of outliers 
R
het<-read.table("output/inbreed.het",header=T)
maf_o <-read.table("output/inbreed_maf001.het",header=T)
maf_u <-read.table("output/inbreed_maf_u001.het",header=T)
snl <-read.table("output/snps_o_maf_001.snplist",header=T)

png("output/inbreed.png")
plot(het$F)
dev.off()

png("output/inbreed_maf001.png")
plot(maf_o$F)
dev.off()

png("output/inbreed_maf_u001.png")
plot(maf_u$F)
dev.off()

dropsamples<-subset(maf_u, F< c(-1) | F>1) # find individer med inbreeding coefficient over 1 eller mindre end -1 for sj?ldne alleler
dropsamples_o<-subset(maf_o, F < c(-0.1)| F> 0.1) # find individer med inbreeding coefficient over 0.1 eller mindre end -0.1 for hyppige alleler
drop<-rbind(dropsamples_o,dropsamples) #samler disse drop cases
drop_FID<-drop[,c("FID","IID")]
FID<- drop_FID[,1]

write.table(drop_FID, "output/dropsamples_het.txt", col.names=F, row.names=F,quote = FALSE)
write.table(FID, "output/dropsamples_het_py.txt", col.names=F, row.names=F,quote = FALSE)

q(save="no")

#Using the dropsamples lists we exclude those individuals who doesn't pass the inbreeding test by exluding them with plink
plink --noweb --bfile GBall_mindclean --allow-no-sex --make-bed --remove output/dropsamples_het.txt --out output/GBall_inbreedclean


#aim (ancestory informative markers) files were made using awk (for Exome chip):
awk -F "-" '{print $1}' aimList.txt  > aimList.short
awk -F "-" '{print "exm-"$1}' NativeAIM.txt  > NativeAIM.short
cat   aimList.short   NativeAIM.short > aimSNPs.txt

#We use aimSNPs.txt on the HumanCore Exome chip by coping
cp /space/J8/data/exomChip/zcall/aimSNPs.txt /home/mngh/gastricbypass/

#Run Rscript: aimscript.sh which have this inside it:
  ########################
# prepare plink files on aim snps only for pca analysis
plink --noweb --bfile output/GBall_inbreedclean --allow-no-sex --extract aimSNPs.txt --recodeA --out output/aimexome

#removes phenotypic data (cols 2-6)
cut -d " " -f1,7-  output/aimexome.raw  > output/exomeaimsnps.txt

Rscript /home/jbj/Exome101012/eigenstratPlink.r output/aimexome_noDu.raw 

#cut -d " " -f1-11 exomeaimsnpsegeno.txt > output/exomeallpcasnpsegeno_1_10.txt
###################################
#Run this in R - or use the R-script (which contains the same) named: Rpcaforsat.R

R
pc <-read.table("exomeaimsnpsegeno.txt", header=T, row.names=1)
#which(pc$PCA1>0.15) 
png("test.png",width = 960, height=960)     
plot(pc[c(which(pc$PCA1>c(-0.2) & pc$PCA2>c(-0.2))),1:2])
dev.off()    
out<-row.names(pc[-c(which(pc$PCA1>c(-0.2) & pc$PCA2>c(-0.2))),])
#Dublicating to obtain right format (FID, IID)
outprint <- matrix(c(out,out),length(out),2)
write.table(outprint,"ami_pca_outliers", quote = F, row.names = F,    col.names = F) 
q()


#use the list ami_pca_outliers to remove outliers:
plink --noweb --bfile output/GBall_inbreedclean --allow-no-sex --make-bed --remove ami_pca_outliers --out output/GBall_pcaclean 

#Find cluster file on q-drev and copy to brutus (here shown for a q-drev mounted in linux (Ask Vincent how to))
#On local machine (slaven) with Q-drev mounted:
cd vincent@slaven/smbf/Q-drev/Genetics/Symbion/Illumina/CoreExome/Cluster\ Files
scp HumanCoreExome-12v1-0_B.egt vincent@brutus.sund.ku.dk:. 
#Back on brutus in working directory (/home/mngh/gastricbypass)
cp /home/vincent/HumanCoreExome-12v1-0_B.egt .

#Collect ALL the removed indiviuals to remove from final report (required for zcall version 3)
cat output/GBall_mindcleanOnly.irem output/dropsamples_het.txt ami_pca_outliers > removed_ind
# GBall_mindcleanOnly.irem:  From mindclean (our case geno clean did nothing)
# dropsamples_het.txt: individuals removed from inbreed analysis
# ami_pca_outliers: individuals removed from pca analysis
#Using version 3 as the cluster (.egt) file doesn't work and zcall recommend using version 3 anyway - the scripts are in GscriptsV3.

#Removing the bad samples from the final rapport
GscriptsV3/dropSamplesFromReport.py raw/GBfinal_SNP_clean ./removed_ind > raw/GBfinal_plink_cleaned

#Fra z-call vejledning: 
python GscriptsV3/findMeanSD.py -R raw/GBfinal_plink_cleaned > output/meansd.txt
Rscript lsGscriptsV3/findBetas.r output/meansd.txt output/betas.txt 1


###Vincents python script is up and have ran to this point by 11/10/13##
#See google doc for new file-names 

#Make threshold directory
mkdir output/thresholds
#Run bash script:
startThresholdBashCluster.sh
#This starts (by qsub'ing) the following bashscript:
thresholdBashCluster.sh
#Which contains (with -Z from 3-15):
  python zCallV3/findThresholds.py -B output/betas.txt -R BothMatrix.txt_Matrix_plinkcleaned -Z 3 -I 0.2 > output/thresholds/threshold3.txt

#Calibrate (find the best threshold) with
zCallV3/calibrateZ95.py #.... SE ZCALL MANUal.





###NOTES###
# Use dropSamplesFromReport_FasterVersion.py to remove bad samples from GenomeStudio report


# Use the script findMeanSD.py to calculate ?? and ?? of both homozygote clusters for common sites (MAF > 5%)
# Take the output of Step 1 and run findBetas.r to derive the linear regression model using the "1" flag for weighted linear regression



# Use the output from findBetas.r and the clean GSR to determine which z-score threshold to use by running calibrateZ.py for different z-score threshold inputs (i.e. 3-15)



# Determine which z-score threshold works best for your dataset based on the output statistics


# Use the findThresholds.py script to derive the thresholds using the linear regression model, the optimal z-score threshold, and the clean GSR

# Use the zCall.py script with the clean (or original) GSR and the thresholds output from findThresholds.py. output is a TPED and TFAM file with only No Calls recalled by zCall.




#Missingness per individual
--mind

#Missingness per marker
--geno

#Allele frequency
--maf

#Hardy-Weinberg equilibrium
--hwe

#inbreeding coefficients (i.e. based on the observed versus expected number of homozygous genotypes)
--het

# Sex chech
--check-sex

#Performing IBD estimation
--genome --matrix