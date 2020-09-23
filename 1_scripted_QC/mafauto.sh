#!/bin/bash
plink19 --bfile $1 --het  --allow-no-sex --out output/inbreed
sed -e 's/[[:space:]]\+/ /g' output/inbreed.het > output/inbreed.het.sep
