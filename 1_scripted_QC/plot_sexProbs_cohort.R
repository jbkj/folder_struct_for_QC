#!/usr/local/bin/Rscript

args<-commandArgs(TRUE)
print(args)
file<-args[1]

sexfile<- paste("output/",file,".GenoMind.sexcheck", sep="")
missfile<- paste("output/",file,".GenoMind_chr23.imiss", sep="")

out_plot<- paste("output/",file,"_missVSsex.png", sep="")


sex <- read.table(sexfile,h=T,as.is=T)
miss <- read.table(missfile,h=T,as.is=T)
t <- merge(sex,miss,by=c('FID','IID'))

#png(out_plot,type = "cairo")


png(out_plot, width = 750, height = 500, type="cairo")
par(xpd = T, mar = par()$mar + c(0,0,0,22))


library(dplyr)
subset(t, STATUS=="PROBLEM") %>% dim -> num
dim(t)-> total


subset(t, STATUS=="PROBLEM") %>% subset(PEDSEX==2) %>% subset(SNPSEX==1) %>%dim -> nfem
subset(t, STATUS!="PROBLEM") %>% subset(PEDSEX==2) %>% subset(SNPSEX==2) %>%dim -> nfemfem
subset(t, STATUS!="PROBLEM") %>% subset(PEDSEX==1) %>% subset(SNPSEX==1) %>%dim -> nmalmal
subset(t, STATUS=="PROBLEM") %>% subset(PEDSEX==1) %>% subset(SNPSEX==2) %>%dim -> nmal
subset(t, STATUS=="PROBLEM") %>%  subset(SNPSEX==0) %>%dim -> nsnp
subset(t, STATUS=="PROBLEM") %>% subset(PEDSEX==0)%>% dim -> nped


plot(t$F,t$F_MISS,bg=t$PEDSEX,pch=20+t$SNPSEX,xlab='F-stat',ylab='X chr. missing', main=paste(file, ", number of samples", total[1], sep=" "))
points(y=t[t$STATUS=='PROBLEM','F_MISS'],x=t[t$STATUS=='PROBLEM','F'],col='blue',cex=1.5)

ly <- max(t$F_MISS)/2

legend(1.1,ly,
pt.bg=c(1,1,2,2),
col=c(1,1,1,1,'blue','black','black'),
pch=c(21,22,21,22,1,1,1),
legend=c(
                                            paste("PED and SNP = Male, n =",  nmalmal[1]),
                                            paste("PED = Male, SNP = Female, n =",    nmal[1]),
                                            paste("PED = Female, SNP = Male, n =",   nfem[1]),
                                            paste("PED = Female, SNP = Female, n =",   nfemfem[1]),
                                            paste("PROBLEM status in with plink, n =",  num[1]),
                                            paste("snp0, n =", nsnp[1]),
                                            paste("ped0, n =", nped[1])
                                             )
       )


par(mar=c(5, 4, 4, 2) + 0.1)
dev.off()
