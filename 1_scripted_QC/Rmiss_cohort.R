#!/usr/local/bin/Rscript

args<-commandArgs(TRUE)
print(args)
file<-args[1]

imissfile<- paste("output/",file,"_MatrixMissing.imiss", sep="")
lmissfile<- paste("output/",file,"_MatrixMissing.lmiss", sep="")

out_ifile<- paste("output/",file,"_imiss.png", sep="")
out_lfile<-  paste("output/",file,"_lmiss.png", sep="")

print(imissfile)
print(imissfile)
print(out_ifile)
print(out_lfile)

imiss <- read.table(imissfile,h=T)
lmiss <- read.table(lmissfile,h=T)

png(out_ifile,type = "cairo")
plot(sort(imiss$F_MISS),ylab="Missingness",xlab="Sorted individuals",main=paste("Missingness in individuals",file))
dev.off()

png(out_lfile,type = "cairo")
plot(sort(lmiss$F_MISS),ylab="Missingness",xlab="Sorted SNPs",main=paste("Missingness in alleles",file))
dev.off()
q(save="no")
