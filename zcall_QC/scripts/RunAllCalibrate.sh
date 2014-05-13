#!/bin/bash
mkdir $1/output/concordance
for i in `seq 3 15`;
do
    qsub $1/scripts/RunCalibrate.sh $i $1 $2
done
