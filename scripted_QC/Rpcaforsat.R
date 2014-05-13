#!/usr/bin/Rscript

args<-commandArgs(TRUE)
print(args)

PCA1_low<-as.numeric(args[1])
PCA1_high<-as.numeric(args[2])
PCA2_low<-as.numeric(args[3])
PCA2_high<-as.numeric(args[4])

pc <-read.table("exomeaimsnpsegeno.txt", header=T, row.names=1)


png("PCA_with_cut-offs.png")
plot(pc$PCA1,pc$PCA2)
abline(v=PCA1_low)
abline(v=PCA1_high)
abline(h=PCA2_low)
abline(h=PCA2_high)
dev.off()

failed.ones <- c(which(pc$PCA1>PCA1_high),which(pc$PCA1<PCA1_low),which(pc$PCA2>PCA2_high),which(pc$PCA2<PCA2_low))

PCA1Corrected <- pc$PCA1[-c(which(pc$PCA1>PCA1_high),which(pc$PCA1<PCA1_low),which(pc$PCA2>PCA2_high),which(pc$PCA2<PCA2_low))]
PCA2Corrected <- pc$PCA2[-c(which(pc$PCA1>PCA1_high),which(pc$PCA1<PCA1_low),which(pc$PCA2>PCA2_high),which(pc$PCA2<PCA2_low))]

png("PCA.png",width = 960, height=960)
plot(PCA1Corrected,PCA2Corrected)
dev.off()    

out <- row.names( pc[failed.ones,] )

#Dublicating to obtain right format (FID, IID)
outprint <- matrix(c(out,out),length(out),2)
write.table(outprint,"ami_pca_outliers", quote = F, row.names = F, col.names = F) 
q(save="no")
