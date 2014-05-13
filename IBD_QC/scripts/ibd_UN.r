#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
print(args)

inputted_table <- args[1]
outputted_png <- args[2]
#Special <- args[3]
Special <- 'N'

pngname1 <- paste(outputted_png,'Z0Z1.png',sep='')
pngname2 <- paste(outputted_png,'Z1Z2.png',sep='')
#pngname3 <- paste(outputted_png,'POJITTER.png',sep='')

plink.genome <- read.table(inputted_table,head=T)

#cohort <- as.numeric(grepl('81x',plink.genome$IID1))+as.numeric(grepl('81x',plink.genome$IID2))+1

#plink.genome$cohort <- cohort

if(Special!='Y'){
png(pngname1,width = 960, height = 960)

for(rel in levels(plink.genome$RT)) {
	par(new = T)
	print(rel);
	tmp <- plink.genome[plink.genome$RT==rel,]
	print(dim(tmp))
	if(rel=="UN"){
	plot(tmp$Z0,tmp$Z1,xlim=c(0,1),ylim=c(0,1),axes=T,pch=20)
}}

#plot(plink.genome$Z0,plink.genome$Z1,xlab="Z0", ylab="Z1", main="pairwise relatedness", xlim=c(0,1), ylim=c(0,1),col='grey',pch=20)
text(0,0,"MZ",font=2,col=rgb(1,0,0,0.3))
text(0,1,"PO",font=2,col=rgb(1,0,0,0.3))
text(0.25,0.5,"FS",font=2, col=rgb(1,0,0,0.3))
text(0.5,0.5,"HS",font=2, col=rgb(1,0,0,0.3))
text(1,0,"U",font=2, col=rgb(1,0,0,0.3))
#legend(0.8, 0.8, c('HolHol','HolGas','GasGas'),fill=1:3)
#legend(0.8, 0.8, levels(plink.genome$RT),lty=1,col=1:length(levels(plink.genome$RT)))

dev.off()

png(pngname2,width = 960, height = 960)

for(rel in levels(plink.genome$RT)) {
	par(new = T)
	print(rel);
	tmp <- plink.genome[plink.genome$RT==rel,]
	print(dim(tmp))
	if(rel=="UN"){
	plot(tmp$Z1,tmp$Z2,xlim=c(0,1),ylim=c(0,1),axes=T,col=tmp$cohort,pch=20)
}}

#plot(plink.genome$Z1,plink.genome$Z2,xlab="Z1", ylab="Z2", main="pairwise relatedness", xlim=c(0,1), ylim=c(0,1),col='grey',pch=20)
text(0,1.0,"MZ",font=2,col=rgb(1,0,0,0.3))
text(1.0,0,"PO",font=2,col=rgb(1,0,0,0.3))
text(0.5,0.25,"FS",font=2, col=rgb(1,0,0,0.3))
text(0.5,0,"HS",font=2, col=rgb(1,0,0,0.3))
text(0,0,"U",font=2, col=rgb(1,0,0,0.3))
text(0.075,0,"C2",font=2, col=rgb(1,0,0,0.3))
text(0.25,0,"C1",font=2, col=rgb(1,0,0,0.3))
#legend(0.8, 0.8, c('HolHol','HolGas','GasGas'),fill=1:3)
dev.off()
}

#png(pngname3,width = 960,height=960)

#POcandidates <- plink.genome[plink.genome$Z0<0.01 & plink.genome$Z1 > 0.9,]

#plot(jitter(POcandidates$Z0,factor=15),jitter(POcandidates$Z1,factor=5),axes=T,col=POcandidates$cohort,pch=1)
#legend('topright', c('HolHol','HolGas','GasGas'),fill=1:3)
#dev.off()

# Calculate distances to relevant reference points

#ref_points <- list("MZ"=c(0,0), "PO"=c(0,1), "FS"=c(0.25,0.5), "HS"=c(0.5,0.5))

#fs <- plink.genome[plink.genome$RT == "FS",]
#fs_wrong <- fs[fs$Z0 > 0.8 & fs$Z1 < 0.2,]
#legend(0.8, 0.8, c('HolHol','HolGas','GasGas'),fill=1:3)
#dev.off()
