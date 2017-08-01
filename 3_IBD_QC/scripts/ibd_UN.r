#!/usr/local/bin/Rscript

args <- commandArgs(TRUE)
print(args)

inputted_table <- args[1]
outputted_png <- args[2]

pngname1 <- paste(outputted_png,'Z0Z1.png',sep='')
pngname2 <- paste(outputted_png,'Z1Z2.png',sep='')


plink.genome <- read.table(inputted_table,head=T)



png(pngname1,width = 960, height = 960)

for(rel in levels(plink.genome$RT)) {
	par(new = T)
	print(rel);
	tmp <- plink.genome[plink.genome$RT==rel,]
	print(dim(tmp))
	if(rel=="UN"){
	plot(tmp$Z0,tmp$Z1,xlim=c(0,1),ylim=c(0,1),axes=T,pch=20)
}}


text(0,0,"MZ",font=2,col=rgb(1,0,0,0.3))
text(0,1,"PO",font=2,col=rgb(1,0,0,0.3))
text(0.25,0.5,"FS",font=2, col=rgb(1,0,0,0.3))
text(0.5,0.5,"HS",font=2, col=rgb(1,0,0,0.3))
text(1,0,"U",font=2, col=rgb(1,0,0,0.3))

dev.off()

png(pngname2,width = 960, height = 960)

for(rel in levels(plink.genome$RT)) {
	par(new = T)
	print(rel);
	tmp <- plink.genome[plink.genome$RT==rel,]
	print(dim(tmp))
	if(rel=="UN"){
	plot(tmp$Z1,tmp$Z2,xlim=c(0,1),ylim=c(0,1),axes=T,pch=20)
}}


text(0,1.0,"MZ",font=2,col=rgb(1,0,0,0.3))
text(1.0,0,"PO",font=2,col=rgb(1,0,0,0.3))
text(0.5,0.25,"FS",font=2, col=rgb(1,0,0,0.3))
text(0.5,0,"HS",font=2, col=rgb(1,0,0,0.3))
text(0,0,"U",font=2, col=rgb(1,0,0,0.3))
text(0.075,0,"C2",font=2, col=rgb(1,0,0,0.3))
text(0.25,0,"C1",font=2, col=rgb(1,0,0,0.3))

dev.off()
