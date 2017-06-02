pairs <- read.table('Failed_IBD_pairs',h=F,as.is=T)
miss <- read.table('IBD.imiss',h=T,as.is=T)
tmp <- merge(pairs,miss[,c(1:2,6)],by.x=c('V1','V2'),by.y=c('FID','IID'))
colnames(tmp)[ncol(tmp)] <- 'F_MISS.1stPair'
t <- merge(tmp,miss[,c(1:2,6)],by.x=c('V3','V4'),by.y=c('FID','IID'))
colnames(t)[1:4] <- c('FID2','IID2','FID1','IID1')
t$largestFmiss <- ifelse(t$F_MISS.1stPair>t$F_MISS,1,2)
keepersFID <- NULL
keepersIID <- NULL

for(i in 1:nrow(t)){
    keepersFID <- c(keepersFID,t[i,(t[i,'largestFmiss']*2)-1])
    keepersIID <- c(keepersIID,t[i,t[i,'largestFmiss']*2])
}


keepers <- cbind(keepersFID,keepersIID)
keepers
keepers <- as.data.frame(cbind(keepersFID,keepersIID),stringsAsFactors=F)
keepers
write.table(keepers,'Failed_IBD_ind',col.names=F,row.names=F,quote=F)
