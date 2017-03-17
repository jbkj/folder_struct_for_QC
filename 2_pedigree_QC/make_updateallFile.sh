# formatting Peters Barcode Update and removing common errors (sadly, this is probably a never ending story of seds)
cat $1 | tr ';' '\t' | awk 'NR>1 {print $2,$2,$3,$3}' > update_any_barcode_to_particid
cat $1 | tr ';' '\t' | awk 'NR>1 {print $3,$3,$NF}' | sed 's/na/0/g' | sort | uniq  > update_any_barcode_to_particid_with_sex
