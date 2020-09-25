sex <- read.table('plink.sexcheck',h=T,as.is=T)
miss <- read.table('plink.imiss',h=T,as.is=T)
t <- merge(sex,miss,by=c('FID','IID'))

png('missVSsex.png',type = "cairo")
plot(t$F,t$F_MISS,bg=t$PEDSEX,pch=20+t$SNPSEX,xlab='F-stat',ylab='X chr. missing')
points(y=t[t$STATUS=='PROBLEM','F_MISS'],x=t[t$STATUS=='PROBLEM','F'],col='blue',cex=1.5)

legend('center',pt.bg=c(1,1,2,2),col=c(1,1,1,1,'blue'),pch=c(21,22,21,22,1),legend=c(
                                             'PED and SNP = Male',
                                             'PED = Male, SNP = Female',
                                             'PED = Female, SNP = Male',                                               
                                             'PED = Female, SNP = Female',
                                             'PROBLEM status in with plink'
                                             )
       )

dev.off()
