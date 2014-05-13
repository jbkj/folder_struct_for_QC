#!/bin/bash
for i in `seq 3 15`;
do
    $2/thresholdBashCluster.sh $i $1 $2 &
done; wait
