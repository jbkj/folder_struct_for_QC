# find columns to remove
pattern=Score
cols=$(head -n1 $1 | tr '\t' '\n' | grep -n "$pattern" | cut -d: -f1 | paste -s -d,)
#cut   -f head -1 LOFUS_FDT.txt_Matrix | tr '\t' '\n' | cat -n | grep "Score"|cut -f1| tr '\n' ','  -d,   <(head LOFUS_FDT.txt_Matrix) > test


# remove all columns that matched
cut --complement  -f$cols $1 > $1_uscore
