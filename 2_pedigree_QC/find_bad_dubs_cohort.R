
#!/usr/local/R-4.0.2/bin/Rscript
library(dplyr)

args <- commandArgs(trailingOnly=T)

imiss <- read.table(args[1],as.is=T,h=T)
cohort <- read.table(args[2],as.is=T, header=T, sep=";")

imiss <- imiss[,c(2,6)]


left_join(imiss, cohort, by=c("IID"= "barcode"))      -> tmiss

for (cohortID in unique(tmiss$projectId)){
paste("bad_dups.barcodes",cohortID,sep = "_") -> cohortbaddups
filter(tmiss, projectId==cohortID)  -> t

keepIIDs <- NULL
for(id in unique(t$particid)){
    cand <- t[t$particid==id,]
    best <- cand[which(cand$F_MISS == min(cand$F_MISS,na.rm=T)),'IID']
    best <- best[1] #In the case of a tie just take the first one
    keepIIDs <- c(keepIIDs,best)
}
removeBarcodes <- t[-which(t$IID %in% keepIIDs),c('particid','IID')]
write.table(data.frame(removeBarcodes),cohortbaddups,row.names=F,col.names=F,quote=F)
}

# make list of barcodes for genome analysis
duplicates <- tmiss[duplicated(tmiss$particid),]$particid
subset(tmiss,particid%in%duplicates)-> dupli
write.table(data.frame(dupli$particid,dupli$IID),'dups.barcodes',row.names=F,col.names=F,quote=F)
