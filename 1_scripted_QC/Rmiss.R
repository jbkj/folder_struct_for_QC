#!/usr/local/bin/Rscript
imiss <- read.table("output/MatrixMissing.imiss",h=T)
lmiss <- read.table("output/MatrixMissing.lmiss",h=T)

png("output/imiss.png",type = "cairo")
plot(sort(imiss$F_MISS),ylab="Missingness",xlab="Sorted individuals",main="Missingness in individuals")
dev.off()

png("output/lmiss.png",type = "cairo")
plot(sort(lmiss$F_MISS),ylab="Missingness",xlab="Sorted SNPs",main="Missingness in alleles")
dev.off()
q(save="no")
