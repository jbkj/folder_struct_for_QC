Use the newest version of BarcodesToParticidWithGenderXX.txt (XX is a number) as an argument for
make_updateallFile.sh
to create to files - one for updating from barcodes to particids and one for updating sex (used in sexQC)

Create two files - one with callrates for barcodes which have duplicated particids
another which have the key (barcodes -> particid) for the duplicated particids.

Something like:
(key)
3998911070_R01C01 3998911070_R01C01 89x001 89x001
3998911060_R06C01 3998911060_R06C01 89x001 89x001

and
(missingness)
              FID                 IID MISS_PHENO   N_MISS   N_GENO   F_MISS
3998911060_R01C01   3998911060_R01C01          Y     6111   549554  0.01112
3998911060_R02C02   3998911060_R02C02          Y     6035   549554  0.01098

and run find_bad_dubs.R with those two files as arguments (miss, then key). It'll output the barcodes you'll need to remove before continueing the PEDQC

Do a final check on the .fam file to make sure you only continue with your own cohort (there might be others on the chip).
