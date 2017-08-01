#!/usr/local/bin/Rscript

args <- commandArgs(trailingOnly=T)

imiss <- read.table(args[1],as.is=T,h=T)
imiss <- imiss[,c(2,6)]
key <- read.table(args[2],as.is=T,h=F)
key <- key[,2:3]
colnames(key) <- c('IID','particid')

t <- merge(key,imiss,by='IID')
keepIIDs <- NULL
for(id in unique(t$particid)){
    cand <- t[t$particid==id,]
    best <- cand[which(cand$F_MISS == min(cand$F_MISS,na.rm=T)),'IID']
    best <- best[1] #In the case of a tie just take the first one
    keepIIDs <- c(keepIIDs,best)
}

removeBarcodes <- t[-which(t$IID %in% keepIIDs),'IID']
write.table(data.frame(removeBarcodes,removeBarcodes),'bad_dups.barcodes',row.names=F,col.names=F,quote=F)
