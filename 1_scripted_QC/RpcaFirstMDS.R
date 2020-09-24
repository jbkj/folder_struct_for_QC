#!/usr/local/bin/Rscript

args<-commandArgs(TRUE)
print(args)

PCA1_low<-as.numeric(args[1])
PCA1_high<-as.numeric(args[2])
PCA2_low<-as.numeric(args[3])
PCA2_high<-as.numeric(args[4])

your_1000G_merged_file_filter <- read.table("Matrix_1000G_merged_filter_mds10.mds", header=T)
New1000RG3plus <-read.csv("Matrix_origin.csv", header=T)
library(plyr)
SCAT1 <- join (your_1000G_merged_file_filter, New1000RG3plus, by = "FID")
#8.          Make cluster plots in R
l <- sort(unique(SCAT1$Groups))
 
lh <-c()
for (i in 1:length(l)) {
a<-c("Group",l[i],as.character(unique(SCAT1[which(SCAT1$Groups==l[i]),"Code"])))
b<-paste(a, collapse=" ")
lh<-rbind(lh,b)
}

png("MDS_with_cut-offs.png",type = "cairo")

plot(SCAT1$C1, SCAT1$C2, main= "AIMs from ExomeChip", xlab="MDS1", ylab="MDS2", col=c ("red", "blue", "green", "yellow", "cyan",  "coral",  "brown", "black") [SCAT1$Groups])
legend("bottomright", legend=lh,col=c ("red", "blue", "green", "yellow", "cyan",  "coral",  "brown", "black"),pch=1)

abline(v=PCA1_low)
abline(v=PCA1_high)
abline(h=PCA2_low)
abline(h=PCA2_high)

dev.off ()
 
den<-subset(SCAT1, SCAT1$Code=="COH")
length(which(den$C1>c(0.0015)|den$C2<c(-0.020)|den$C2>c(0.025)) )
 
 
den_list <- den[which(den$C1<PCA1_low
                      |den$C1>PCA1_high
                      |den$C2<PCA2_low
                      |den$C2>PCA2_high                      
                      ),c(1,2)]
 
write.table(den_list,"ethnic_outliers.txt",  quote=F, col.names=T, row.names=F)
q()
