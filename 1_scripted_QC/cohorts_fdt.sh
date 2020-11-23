#!/bin/bash

cut -f1 -d" " output/MatrixAllUpdate.fam > cohorttmp

grep -f cohorttmp $1 > particid_cohorttmp  

cut -f3 particid_cohorttmp -d";" |  sort -u > particid_unique_cohorttmp

cut -f5 particid_cohorttmp -d";" |  cut -f1 -d"-"| sort -u > project_ids_cohorttmp

paste <(echo "number of barcodes") <(wc -l cohorttmp| cut -f1 -d" ")> cohort_FDT_overview.txt
paste <(echo "number of unique ids") <(wc -l particid_unique_cohorttmp | cut -f1 -d" ") >> cohort_FDT_overview.txt 
paste <(echo "projectids in FDT file") <(cut -f3 particid_tmp -d";" |  cut -f1 -d"-"| sort -u)>> cohort_FDT_overview.txt

while read line; do  grep  ^$line particid_unique_cohorttmp > cohort_$line; done < project_ids_cohorttmp

while read line; do paste <(echo "number of ids in cohort $line") <(wc -l cohort_$line| cut -f1 -d" ") >> cohort_FDT_overview.txt; done < project_ids_cohorttmp
