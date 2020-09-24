#!/usr/local/bin/Rscript


europeanTh=1.5
library(ggplot2)
##function to draw a circle as a magnitude from the European centre in euclidean distance
circleFun <- function(center = c(0,0),diameter = 1, npoints = 100){
    r = diameter / 2
    tt <- seq(0,2*pi,length.out = npoints)
    xx <- center[1] + r * cos(tt)
    yy <- center[2] + r * sin(tt)
    return(data.frame(x = xx, y = yy))
}

your_1000G_merged_file_filter <- read.table("Matrix_1000G_merged_filter_mds10.mds", header=T)
New1000RG3plus <-read.csv("Matrix_origin.csv", header=T)
library(plyr)
SCAT1 <- join (your_1000G_merged_file_filter, New1000RG3plus, by = "FID")
#8.          Make cluster plots in R
l <- sort(unique(SCAT1$Groups))

lh <-c()
for (i in 1:length(l)) {
a<-c("Group",l[i],as.character(unique(SCAT1[which(SCAT1$Groups==l[i]),"Code"])))
b<-paste(a, collapse=" ")
lh<-rbind(lh,b)
}

##this method is adapted from plinkQC package 
all_european  <- SCAT1[SCAT1$Group==1,]
euro_pc1_mean <- mean(all_european$C1)
euro_pc2_mean <- mean(all_european$C2)
all_european$euclid_dist <- sqrt((all_european$C1 - euro_pc1_mean)^2 +
                                         (all_european$C2 - euro_pc2_mean)^2)
max_euclid_dist <- max(all_european$euclid_dist)
data_name <- SCAT1[SCAT1$Group==8,]
data_name$euclid_dist <- sqrt((data_name$C1 - euro_pc1_mean)^2 +
                                     (data_name$C2 - euro_pc2_mean)^2)
    non_europeans <- data_name[data_name$euclid_dist >
                                        (max_euclid_dist * europeanTh),]
    fail_ancestry <- non_europeans[,c("FID","IID")]
 write.table(fail_ancestry,"ethnic_outliers.txt",  quote=F, col.names=T, row.names=F)


r=max_euclid_dist * europeanTh
xc=euro_pc1_mean
yc=euro_pc2_mean

dat <- circleFun(c(xc,yc),2*r,npoints = dim(SCAT1[1])[1])
p=ggplot(SCAT1,aes(x=C1,y=C2,color)) + geom_point(aes(colour=factor(Groups)),size=1, shape=23) + scale_colour_manual(labels = c("Group 1 GBR FIN IBS CEU TSI","Group 2 
CHS CHB JPT","Group 3 YRI LWK","Group 4 CLM","Group 5 MXL","Group 6 PUR","Group 7 ASW","Group 8 COH"),values = c("red", "blue", "green", "yellow", "cyan",  "coral",  
"brown", "black"))+theme(legend.position = c(0.7, 0.2),
          legend.direction = "horizontal") + theme(legend.title = element_blank()) 
p+geom_path(aes(x = dat$x, y = dat$y))+theme(panel.background = element_rect(fill = 'white', colour = 'grey'))

png("MDS_with_cut-offs.png",type = "cairo",width=800)

p+geom_path(aes(x = dat$x, y = dat$y))+theme(panel.background = element_rect(fill = 'white', colour = 'grey'))

dev.off ()


q()
