#!/usr/local/bin/Rscript
args<-commandArgs(TRUE)
print(args)
use_thresholds<-args[1]
pub_thres_upper<-0.2
pub_thres_lower<-c(-0.2)


# make plots of heterozygosity and files with FID and IID of outliers
het<-read.table("output/inbreed.het",header=T)

png("output/inbreed.png",type = "cairo")
plot(het$F, xlab="Individuals",ylab="Inbreeding coefficient (F)",main="Inbreeding when all alleles are consindered")
dev.off()


if(use_thresholds=="N"){
  q(save="no")
}

pub_thres = c(pub_thres_lower,pub_thres_upper)

drop <- subset(het, F < pub_thres[1]| F>pub_thres[2])


drop_FID <- drop[,c("FID","IID")]
FID<- unique(drop_FID[,1])


het$n = 1:length(het[,1])

saved_ind <- matrix(c(het[!(het[,1] %in% FID),6],het[!(het[,1] %in% FID),7]),length(het[!(het[,1] %in% FID),7]),2)
disc_ind <- matrix(c(het[(het[,1] %in% FID),6],het[(het[,1] %in% FID),7]),length(het[(het[,1] %in% FID),7]),2)


#For all
png("output/inbreed.png",type = "cairo")
plot(het$n,het$F, xlab="Individuals",ylab="Inbreeding coefficient (F)",main="Inbreeding when all alleles are consindered")
legend("bottom", c("Kept","Discarded"), fill=c('blue', 'red'), horiz=T)
points(saved_ind[,2], saved_ind[,1], col="blue",pch=16)
points(disc_ind[,2], disc_ind[,1], col="red",pch=16)
dev.off()

write.table(drop_FID, "output/dropsamples_het.txt", col.names=F, row.names=F,quote = FALSE)
write.table(FID, "output/dropsamples_het_py.txt", col.names=F, row.names=F,quote = FALSE)

q(save="no")
