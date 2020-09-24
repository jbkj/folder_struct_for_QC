#!/bin/bash
sed 's/\.1//g' 1_scripted_QC/ethnic_outliers.txt | sort | uniq | sed 's/\t/ /g'> 1_scripted_QC/removed_ind_barcodes
cat 1_scripted_QC/output/dropsamples_het.txt | sort | uniq | sed 's/\t/ /g' >> 1_scripted_QC/removed_ind_barcodes
cat 1_scripted_QC/output/MatrixGenoMind.irem | sed 's/\t/ /g' >> 1_scripted_QC/removed_ind_barcodes
