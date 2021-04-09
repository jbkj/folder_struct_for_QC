#!/bin/bash

if [ -n "$2" ]

then

file=$(echo "output/"$2".fam")
outfile=$(echo $2"_FDT_overview.txt")


else


file="output/MatrixAllUpdate.fam"
outfile="cohort_FDT_overview.txt"



fi
echo $file > test
echo $outfile >> test

cut -f2 -d" " $file > cohorttmp

grep -f cohorttmp $1 > particid_cohorttmp

cut -f3,5 particid_cohorttmp -d";" |  sort -u > particid_unique_cohorttmp

cut -f5 particid_cohorttmp -d";" |  cut -f1 -d"-"| sort -u > project_ids_cohorttmp

paste <(echo "number of barcodes") <(wc -l cohorttmp| cut -f1 -d" ")> $outfile
paste <(echo "number of unique ids") <(wc -l particid_unique_cohorttmp | cut -f1 -d" ") >> $outfile
paste <(echo "projectids in FDT file") >> $outfile

while read line; do  grep ";"$line$ particid_unique_cohorttmp > cohort_$line; done < project_ids_cohorttmp

while read line; do paste <(echo "number of ids in cohort $line") <(wc -l cohort_$line| cut -f1 -d" ") >> $outfile; done < project_ids_cohorttmp
