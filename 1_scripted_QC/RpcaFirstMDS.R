#!/usr/bin/Rscript

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

png("MDS_firstTime.png")

plot(SCAT1$C1, SCAT1$C2, main= "AIMs from ExomeChip", xlab="MDS1", ylab="MDS2", col=c ("red", "blue", "green", "yellow", "cyan",  "coral",  "brown", "black") [SCAT1$Groups])
legend("bottomright", legend=lh,col=c ("red", "blue", "green", "yellow", "cyan",  "coral",  "brown", "black"),pch=1)
dev.off ()
q()
