#!/bin/bash
cut -d " " -f7- output/aimexome.raw  > output/exomeaimsnps.txt
Rscript /home/jbj/Exome101012/eigenstratPlink.r output/exomeaimsnps.txt