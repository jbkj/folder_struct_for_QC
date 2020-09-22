pairs <- read.table('Failed_IBD_pairs',h=F,as.is=T)
miss <- read.table('IBD.imiss',h=T,as.is=T)
tmp <- merge(pairs,miss[,c(1:2,6)],by.x=c('V1','V2'),by.y=c('FID','IID'))
colnames(tmp)[ncol(tmp)] <- 'F_MISS.1stPair'
t <- merge(tmp,miss[,c(1:2,6)],by.x=c('V3','V4'),by.y=c('FID','IID'))
colnames(t)[1:4] <- c('FID2','IID2','FID1','IID1')
t$largestFmiss <- ifelse(t$F_MISS.1stPair>t$F_MISS,2,1)
removeFID <- NULL
removeIID <- NULL

for(i in 1:nrow(t)){
    removeFID <- c(removeFID,t[i,(t[i,'largestFmiss']*2)-1])
    removeIID <- c(removeIID,t[i,t[i,'largestFmiss']*2])
}



remove <- unique(as.data.frame(cbind(removeFID,removeIID),stringsAsFactors=F))
remove

write.table(remove,'Failed_IBD_ind',col.names=F,row.names=F,quote=F)
