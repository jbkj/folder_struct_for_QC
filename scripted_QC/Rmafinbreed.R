#!/usr/bin/Rscript
args<-commandArgs(TRUE)
print(args)
use_thresholds<-args[5]
rare_thres_lower<-as.numeric(args[1])
rare_thres_upper<-as.numeric(args[2])
common_thres_lower<-as.numeric(args[3])
common_thres_upper<-as.numeric(args[4])

# make plots of heterozygosity and files with FID and IID of outliers
het<-read.table("output/inbreed.het",header=T)
maf_o <-read.table("output/inbreed_maf001.het",header=T)
maf_u <-read.table("output/inbreed_maf_u001.het",header=T)

png("output/inbreed.png")
plot(het$F, xlab="Individuals",ylab="Inbreeding coefficient (F)",main="Inbreeding when all alleles are consindered")
dev.off()

png("output/inbreed_maf001.png")
plot(maf_o$F, xlab="Individuals",ylab="Inbreeding coefficient (F)",main="Inbreeding when only common alleles are consindered")
dev.off()

png("output/inbreed_maf_u001.png")
plot(maf_u$F, xlab="Individuals",ylab="Inbreeding coefficient (F)",main="Inbreeding when only rare alleles are consindered")
dev.off()

if(use_thresholds=="N"){
  q(save="no")
}

rare_thres = c(rare_thres_lower,rare_thres_upper)
common_thres = c(common_thres_lower,common_thres_upper)

dropsamples<-subset(maf_u, F< rare_thres[1] | F>rare_thres[2])
dropsamples_o <- subset(maf_o, F < common_thres[1]| F>common_thres[2])
drop<-rbind(dropsamples_o,dropsamples)
drop_FID <- drop[,c("FID","IID")]
FID<- drop_FID[,1]

FID_hyppige <- dropsamples_o[,1]
FID_rare <- dropsamples[,1]

het$n = 1:length(het[,1])
maf_u$n = 1:length(maf_u[,1])
maf_o$n = 1:length(maf_o[,1])

saved_ind <- matrix(c(het[!(het[,1] %in% FID),6],het[!(het[,1] %in% FID),7]),length(het[!(het[,1] %in% FID),7]),2)
disc_ind <- matrix(c(het[(het[,1] %in% FID),6],het[(het[,1] %in% FID),7]),length(het[(het[,1] %in% FID),7]),2)

saved_ind_hyp <- matrix(c(maf_o[!(maf_o[,1] %in% FID_hyppige),6],maf_o[!(maf_o[,1] %in% FID_hyppige),7]),length(maf_o[!(maf_o[,1] %in% FID_hyppige),7]),2)
disc_ind_hyp <- matrix(c(maf_o[(maf_o[,1] %in% FID_hyppige),6],maf_o[(maf_o[,1] %in% FID_hyppige),7]),length(maf_o[(maf_o[,1] %in% FID_hyppige),7]),2)

saved_ind_u <- matrix(c(maf_u[!(maf_u[,1] %in% FID_rare),6],maf_u[!(maf_u[,1] %in% FID_rare),7]),length(maf_u[!(maf_u[,1] %in% FID_rare),7]),2)
disc_ind_u <- matrix(c(maf_u[(maf_u[,1] %in% FID_rare),6],maf_u[(maf_u[,1] %in% FID_rare),7]),length(maf_u[(maf_u[,1] %in% FID_rare),7]),2)


#For all
png("output/inbreed.png")
plot(het$n,het$F, xlab="Individuals",ylab="Inbreeding coefficient (F)",main="Inbreeding when all alleles are consindered")
legend("bottom", c("Kept","Discarded"), fill=c('blue', 'red'), horiz=T, cex=0.75)
points(saved_ind[,2], saved_ind[,1], col="blue",pch=16)
points(disc_ind[,2], disc_ind[,1], col="red",pch=16)
dev.off()

#For hyppige
png("output/inbreed_maf001.png")
plot(maf_o$n,maf_o$F, xlab="Individuals",ylab="Inbreeding coefficient (F)",main="Inbreeding when only common alleles are consindered")
legend("bottom", c("Kept","Discarded"), fill=c('blue', 'red'), horiz=T, cex=0.75)
abline(h=common_thres[1])
abline(h=common_thres[2])
points(saved_ind_hyp[,2],saved_ind_hyp[,1], col="blue",pch=16)
points(disc_ind_hyp[,2], disc_ind_hyp[,1], col="red",pch=16)
dev.off()

#For rare
png("output/inbreed_maf_u001.png")
plot(maf_u$n,maf_u$F, xlab="Individuals",ylab="Inbreeding coefficient (F)",main="Inbreeding when only rare alleles are consindered")
legend("bottom", c("Kept","Discarded"), fill=c('blue', 'red'), horiz=T, cex=0.75)
abline(h=rare_thres[1])
abline(h=rare_thres[2])
points(saved_ind_u[,2],saved_ind_u[,1], col="blue", pch=16)
points(disc_ind_u[,2], disc_ind_u[,1], col="red", pch=16)
dev.off()

write.table(drop_FID, "output/dropsamples_het.txt", col.names=F, row.names=F,quote = FALSE)
write.table(FID, "output/dropsamples_het_py.txt", col.names=F, row.names=F,quote = FALSE)

q(save="no")
