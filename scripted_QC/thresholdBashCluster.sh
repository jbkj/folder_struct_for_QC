#!/bin/bash
python $3/findThresholds.py -B $3/output/betas.txt -R $3/$2 -Z $1 -I 0.2 > $3/output/thresholds/threshold$1.txt
