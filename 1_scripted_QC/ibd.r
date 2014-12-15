plink.genome <- read.table("plink.genome",head=T)

plot(c(),xlab="Z0", ylab="Z1", main="pairwise relatedness", xlim=c(0,1), ylim=c(0,1))

for(rel in levels(plink.genome$RT)) {
	par(new = T)
	print(rel);
	tmp <- plink.genome[plink.genome$RT==rel,]
	print(dim(tmp))
	plot(tmp$Z0,tmp$Z1,xlim=c(0,1),ylim=c(0,1),axes=F,xlab="",ylab="",col=which(levels(plink.genome$RT) == rel))
}

text(0,0,"MZ",font=2,col="purple")
text(0,1,"PO",font=2,col="purple")
text(0.25,0.5,"FS",font=2, col="purple")
text(0.5,0.5,"HS",font=2, col="purple")

# Calculate distances to relevant reference points

ref_points <- list("MZ"=c(0,0), "PO"=c(0,1), "FS"=c(0.25,0.5), "HS"=c(0.5,0.5))

fs <- plink.genome[plink.genome$RT == "FS",]
fs_wrong <- fs[fs$Z0 > 0.8 & fs$Z1 < 0.2,]
legend(0.8, 0.8, levels(plink.genome$RT),lty=1,col=1:length(levels(plink.genome$RT)))
