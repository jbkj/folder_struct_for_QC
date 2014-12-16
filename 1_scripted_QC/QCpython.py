#!/usr/bin/env python
from os import *
print("This is a script inteded to help you go through the QC steps interactively - it is based on the script: howto_exomeChip_GoT2D_140313.r\nIt is useful to have a precise overview over where the files you need are located as this script ask for these locations but doesn't allow for auto-completion\nPlease note that all required utility scripts are available and in the working folder as well as the Final Report you want to QC\n\n")
path = str(raw_input("Please specify the full path of where you would be working from (ie. /home/username/QC)\nFor gPLINK compatibility, do not use '.'\n"))

print("Working from: " + path + "\n")


output_folder_needed = True
testing = True

while True:
    try:
        listdir(path)
        break
    except OSError:
        path = str(raw_input("Working Folder doesn't exsist. Please check the name and try again\n"))


for i in range(0,len(listdir(path))):
    if(listdir(path)[i]=='output'):
        output_folder_needed = False

print("Creating output-folder in working directory if it is not already present\n")
if(output_folder_needed):
    make_outputfolder = "mkdir " + path + "/output"
    system(make_outputfolder)

print("Making all utility-scripts in working directory executable\n")
system("chmod +x *.R")
system("chmod +x *.r") 
system("chmod +x *.py") 
system("chmod +x *.sh") 

raw_data = str(raw_input("Please specify the name of the raw data (fx. ExomeMatrixFULL.txt)\n"))

comma_to_period_grep = "sed 's/,/./g' "+ path + "/" + raw_data +" > " + path + "/" + raw_data + "_Matrix"

print("Changing ',' -> '.' by running the command:\n" + comma_to_period_grep+" if it is not already present (from a previous run through of this script)\n")

comma_to_period_needed = True

for j in range(0,len(listdir(path))):
    if(listdir(path)[j]==raw_data+"_Matrix"):
        comma_to_period_needed = False

if(comma_to_period_needed):
    system(comma_to_period_grep)



print("Running convertReportToTPED.py on data with following command:\npython " + path + "/convertReportToTPED.py -O "+path+"/output/MatrixForAll -R "+path+"/"+raw_data+"_Matrix if needed\n")

plink_files_needed = True

for j in range(0,len(listdir(path+"/output"))):
    if(listdir(path+"/output")[j]=="MatrixForAll.tped"):
        plink_files_needed = False

if(plink_files_needed):
    print("Creating plinks file form the final report and puts them in the output folder\n")
    system("python " + path + "/convertReportToTPED.py -O "+path+"/output/MatrixForAll -R "+path+"/"+raw_data+"_Matrix")

waiting0 = str(raw_input("Created plink files: 'MatrixForAll.tfam' and 'MatrixForAll.tped' in the output folder.\nTrying to update the alleles from allele.list. If allele.list is not present it will be created by running Ilumni_update_allele_script.py on the .csv file from Illumina which need to be present in the working directory\nIf you can't supply either the allele.list or the .csv script from illumina, please stop here (as this script will run on what ever .csv file is present in the working directory\nPress enter to continue\n"))

update_alleles_file_needed = True

for j in range(0,len(listdir(path))):
    if(listdir(path)[j]=='alleles.list'):
        update_alleles_file_needed = False

if(update_alleles_file_needed):
    csvfilename = str(raw_input("Please write the name of the csv file in full\n"))
    system("python "+path+"/Ilumni_update_allele_script.py "+path+"/"+csvfilename)
    waitingupdate = str(raw_input("allele.list (updated alleles) is now created - press enter to continue\n"))

plink_update_needed = True

for j in range(0,len(listdir(path+"/output"))):
    if(listdir(path+"/output")[j]=='MatrixAllUpdate.bed'):
        plink_update_needed = False

plink_updater = "plink19 --noweb --tfile "+path+"/output/MatrixForAll --update-alleles "+path+"/alleles.list --allow-no-sex --make-bed --out "+path+"/output/MatrixAllUpdate"
if(plink_update_needed):
    system(plink_updater)

print("Using a simple R-script (Rmiss.R) and plink to calculate and plot the missingness, saved as a picture in "+path+"/output/imiss.png (for individuals) and lmiss.png (for locus). You will be prompted if you want to see this picture and halt this script until you close it.\nIf you are using a ssh remember to have the -X option on so you can have an graphical interface. If you're using MobaX then you're fine.\n")

waiting1 = str(raw_input("Press enter to continue\n"))

missing_needed = True

for j in range(0,len(listdir(path+"/output"))):
    if(listdir(path+"/output")[j]=='MatrixMissing.lmiss'):
        missing_needed = False
        

if(missing_needed):
    system("plink19 --noweb --bfile "+path+"/output/MatrixAllUpdate --missing --allow-no-sex --out "+path+"/output/MatrixMissing")
    system(path+"/Rmiss.R")

    view_missingness = str(raw_input("Do you want to see the plots? type i for indivduals, l for locus or b for both. If you don't want to see the plots type n\n"))
    if(view_missingness == "i"):
        system("display "+path+"/output/imiss.png 2> /dev/null &")
    elif(view_missingness == "l"):
        system("display "+path+"/output/lmiss.png 2> /dev/null &")
    elif(view_missingness == "b"):
        system("display "+path+"/output/imiss.png 2> /dev/null &")
        system("display "+path+"/output/lmiss.png 2> /dev/null &")
    
        if(view_missingness != "n"):
            waiting2 = str(raw_input("Press enter to continue\n"))

GenoMind_needed = True

for j in range(0,len(listdir(path+"/output"))):
    if(listdir(path+"/output")[j]=='MatrixGenoMind.bed'):
        GenoMind_needed = False

if(GenoMind_needed):
    print("Cleaning the data first with geno (calling-rate on SNPs) then mind (calling-rate on individuals)\n")
    geno_threshold = str(raw_input("Please choose a geno-threshold (maximum missing data pr. SNP - 5% = 0.05))?\n"))
    mind_threshold = str(raw_input("Please choose a mind-threshold (max. missing data pr. individual)\n"))

    system("plink19 --noweb --bfile "+path+"/output/MatrixAllUpdate --geno "+geno_threshold+" --allow-no-sex --make-bed --out "+path+"/output/MatrixGeno")
    system("plink19 --noweb --bfile "+path+"/output/MatrixGeno --mind "+mind_threshold+" --allow-no-sex --make-bed --out "+path+"/output/MatrixGenoMind")


Inbreed_needed = True

for j in range(0,len(listdir(path+"/output"))):
    if(listdir(path+"/output")[j]=='MatrixInbreed.bed'):
        Inbreed_needed = False

if(Inbreed_needed):
    print("Running multiple plink lines (as a the bashscript (mafauto.sh) and a Rscript (Rmafinbreed.R) to calculate the inbreeding coefficient for all individuals when consindering all alleles, rare alleles only and common alleles only.\nThese will be plotted and you have to pick the cut-off values for the rare alleles and the common alleles by eyeing what is noice and what is bad samples.\nRemember that a negative inbreeding coefficient doesn't make biological sense.")
    waiting3 = str(raw_input("Press enter to continue\n"))

    mafauto_needed = True

    for j in range(0,len(listdir(path+"/output"))):
        if(listdir(path+"/output")[j]=='inbreed_maf_u001.het'):
            mafauto_needed = False

    if(mafauto_needed):
        system(path+"/mafauto.sh "+path+"/output/MatrixGenoMind")

    system(path+"/Rmafinbreed.R -10 10 -10 10 N")
    waiting4 = str(raw_input("Press enter to continue (you will be shown three plots in a row)\n"))
#system(path+"/display_inbreed.sh")
    system("display "+path+"/output/inbreed.png 2> /dev/null &")
    system("display "+path+"/output/inbreed_maf001.png 2> /dev/null &")
    system("display "+path+"/output/inbreed_maf_u001.png 2> /dev/null &")


    inbreeding_satisfied = "n"
    while(inbreeding_satisfied!="y"):
        
        rare_thres_lower = str(raw_input("Please specify the lower threshold for rare alleles\n"))
        rare_thres_upper = str(raw_input("Please specify the upper threshold for rare alleles\n"))
        common_thres_lower = str(raw_input("Please specify the lower threshold for common alleles\n"))
        common_thres_upper = str(raw_input("Please specify the upper threshold for common alleles\n"))
        system(path+"/Rmafinbreed.R "+rare_thres_lower+" "+rare_thres_upper+" "+common_thres_lower+" "+common_thres_upper+" Y")
    #    system(path+"/display_inbreed.sh")
        system("display "+path+"/output/inbreed.png 2> /dev/null &")
        system("display "+path+"/output/inbreed_maf001.png 2> /dev/null &")
        system("display "+path+"/output/inbreed_maf_u001.png 2> /dev/null &")

        inbreeding_satisfied = str(raw_input("If you are satisfied with the chosen cut-offs type: y, otherwise type: n\n"))

    
    print("Now removing the samples the failed the inbreeding test\n")
    system("plink19 --noweb --bfile "+path+"/output/MatrixGenoMind --allow-no-sex --make-bed --remove "+path+"/output/dropsamples_het.txt --out "+path+"/output/MatrixInbreed")



PCA_needed = True

for j in range(0,len(listdir(path + '/output'))):
    if(listdir(path + '/output')[j]=='MatrixPCAQC.bed'):
        PCA_needed = False


aimQC = str(raw_input("Does the chip have ancestory informative markers (aim)?<y/n>\n"))

if(aimQC=="y"):
    if(PCA_needed):
        waiting7 = str(raw_input("Make sure that you have the complete aimSNP file in your working directory before continuing\nPress enter to continue\n"))
        system(path+"/aimscript.sh "+path+"/output/MatrixInbreed")
        waiting8 = str(raw_input("The PCA analysis results is plottet and will be shown when you press enter. You then have to decide what the cut-offs for the two first principal components (PC1 and PC2) have to be. By sorting these away a new PCA plot will be shown and you have the option of try new cut-off values\nPress enter to continue\n"))
        system("display "+path+"/exomeaimsnps_pca.png 2> /dev/null &")
        waiting9 = str(raw_input("Now running Rpcaforsat.R with the chosen cut-off values. You will be shown the PCA1 plotted against PCA2 with cut-offs and the resulting PCA plot when the discarded samples are removed\nPress enter to continue\n"))
        PCA_satisfied = "n"
        while(PCA_satisfied != "y"):
            PCA1_low = str(raw_input("PCA1 lower threshold (the discarded samples have to be smaller than this value)\n")) 
            PCA1_high = str(raw_input("PCA1 upper threshold (the discarded samples have to be larger than this value)\n")) 
            PCA2_low = str(raw_input("PCA2 lower threshold (the discarded samples have to be smaller than this value)\n")) 
            PCA2_high = str(raw_input("PCA2 upper threshold (the discarded samples have to be larger than this value)\n")) 
            system(path+"/Rpcaforsat.R "+PCA1_low+" "+PCA1_high+" "+PCA2_low+" "+PCA2_high)
            system("display "+path+"/PCA_with_cut-offs.png 2> /dev/null &")
            system("display "+path+"/PCA.png 2> /dev/null &")
            PCA_satisfied = str(raw_input("If you are satisfied with the chosen cut-offs type: y, otherwise type: n\n"))    
        print('plink19 --noweb --bfile '+path+"/output/MatrixInbreed --remove " + path + "/ami_pca_outliers --make-bed --out "+path+"/output/MatrixPCAQC")
        system('plink19 --noweb --bfile '+path+"/output/MatrixInbreed --remove " + path + "/ami_pca_outliers --make-bed --out "+path+"/output/MatrixPCAQC")
        print('use MatrixPCAQC for further QC')
        
        ami_command = "sed 's/\.1//g' "+path+"/ami_pca_outliers | sort | uniq | sed 's/\\t/ /g' > "+path+"/removed_ind_barcodes"
        inbreed_command = "cat "+path+"/output/dropsamples_het.txt | sort | uniq | sed 's/\\t/ /g' >> "+path+"/removed_ind_barcodes"
        mind_command = "cat "+path+"/output/MatrixGenoMind.irem >> "+path+"/removed_ind_barcodes"

        print(ami_command)
        print(inbreed_command)
        print(mind_command)
        system(ami_command)
        system(inbreed_command)
        system(mind_command)

else:
        inbreed_command = "cat "+path+"/output/dropsamples_het.txt | sort | uniq | sed 's/\\t/ /g' >> "+path+"/removed_ind_barcodes"
        mind_command = "cat "+path+"/output/MatrixGenoMind.irem >> "+path+"/removed_ind_barcodes"

        print(inbreed_command)
        print(mind_command)
        system(inbreed_command)
        system(mind_command)

        print('\n--------------------------------------------------------\nEnd of scripted QC - please continue manually with 2_pedigree_QC with the MatrixInbreed file and remember to record all removed individuals in the removed_ind_barcodes and add particids when possible for a complete list\n--------------------------------------------------------\n')        
        exit(0)

print('\n--------------------------------------------------------\nEnd of scripted QC - please continue manually with 2_pedigree_QC with the MatrixPCAQC file and remember to record all removed individuals in the removed_ind_barcodes and add particids when possible for a complete list\n--------------------------------------------------------\n')
exit(0)
