l<-commandArgs(TRUE)
print(l[1])
file=l[1]





rinclp<-read.table(file,head=T, row.names=1)
rinclp<-as.matrix(rinclp)
r<-rinclp[,-c(1:5)]






eigenstrat<-function(geno){                # ind x snp matrix of genotypes \in 0,1,2
  geno<-geno[,!apply(is.na(geno),2,any)]   # remove snps with missing data
  avg<-apply(geno,2,mean)                  # get allele frequency times 2
  keep<-avg!=0&avg!=2                      # remove sites with non-polymorphic data
  avg<-avg[keep]
  geno<-geno[,keep]
  snp<-ncol(geno)                          # number of snps used in analysis
  ind<-nrow(geno)                          # number of individuals used in analuysis
  freq<-(apply(geno,2,sum)/2)/(nrow(geno)) # frequency
  M<-sweep(sweep(geno,2,avg),2,sqrt(freq*(1-freq)),"/") #normalize the genotype matrix
  X<-(M%*%t(M))                            # get the (almost) covariance matrix
  X<-X/(sum(diag(X))/(snp-1))
  E<-eigen(X)

  mu<-(sqrt(snp-1)+sqrt(ind))^2/snp        # for testing significance (assuming no LD!)
  sigma<-(sqrt(snp-1)+sqrt(ind))/snp*(1/sqrt(snp-1)+1/sqrt(ind))^(1/3)
  E$TW<-(E$values[1]*ind/sum(E$values)-mu)/sigma
  E$mu<-mu
  E$sigma<-sigma
  class(E)<-"eigenstrat"
  E
}
#plot.eigenstrat<-function(x,col=1,...)
#  plot(x$vectors[,1:2],col=col,...)
#
#print.eigenstrat<-function(x)
#  cat("statistic",x$TW,"\n")

egeno<-eigenstrat(r)

pngname<-paste(unlist(strsplit(basename(file), "\\."))[1],"_pca.png" , sep="")
png(pngname,width = 960, height=960)
 par(mfrow=c(2,2)) 
 plot(egeno$values[1:100],ylab="first 100 eigen values")
 plot(egeno$values[1:10],ylab="first 10 eigen values")
 plot(egeno$vectors[,1:2],xlab="PC1",ylab="PC2")
 plot(egeno$vectors[,3:4],xlab="PC3",ylab="PC4")
 dev.off()
 
pca110<-egeno$vectors[,1:10] 
colnames(pca110)<-c("PCA1", "PCA2", "PCA3", "PCA4", "PCA5", "PCA6","PCA7", "PCA8", "PCA9" ,"PCA10")
rownames(pca110)<-row.names(rinclp)
write.table(pca110, paste(unlist(strsplit(basename(file), "\\."))[1],"egeno.txt",sep=""))
pdfname<-paste(unlist(strsplit(basename(file), "\\."))[1],"_pca.pdf" , sep="")
pdf(pdfname,width=12, height=12, pointsize=12)     
plot( as.data.frame(pca110))
dev.off()

 #paste(basename(file)
# Example
#
#ind<-c(20,20)
#snp<-10000
#freq=c(0.2,0.25)
#geno<-c()
#for(pop in 1:length(ind))
#  geno<-rbind(geno,matrix(rbinom(snp*ind[pop],2,freq[pop]),ind[pop]))
#
#e<-eigenstrat(geno)
#
#plot(e,col=rep(1:length(ind),ind),xlab="PC1",ylab="PC2")
#
