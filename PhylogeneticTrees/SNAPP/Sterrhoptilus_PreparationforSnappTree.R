#SNAPP Tree

library(vcfR)
library(SNPfiltR)

#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
#read in unlinked vcf
vcfR <- read.vcfR("./Data/Sterrhoptilus_thinned.vcf.gz")
#read in population file
pops<-read.csv("./Data/Sterrhoptilus_SamplingData.csv")

#retain only samples that passed all filtering protocols (assumes that the 'ID' column is identical to sample names in the vcf)
pops<-pops[pops$ID %in% colnames(vcfR@gt),]
#reorder the sample info file to match the order of samples in the vcf
pops<-pops[order(match(pops$ID,colnames(vcfR@gt)[-1])),]
#looking at column names
colnames(vcfR@gt)
#rename column names to fix the affinis samples being labeled as nigrocapitatus and nigrocapitatus being labelled nigrocapitata
colnames(vcfR@gt)[2:48]<-paste0("S_",pops$Species,"_",pops$Tissue)
#dennistouni are columns 11-40; locality 1 is 25-29, 2 is 30-37 and 40, 3 is 23 and 24, and 4 is 11-22, 38, and 39
#affinis are columns 43-46; locality 5 is 46, 6 is 43-45
#nigrocapitatus are columns 41, 42, 47 and 48; locality 7 is 41 and 42, 8 is 47 and 48
#capitalis are columns 2-10; locality 9 is 2-6, 10 is 10, and 11 is 7-9
#plateni are columns 49-51 and are completely excluded

#use a for loop to randomly down sample 2 samples from localities with more than 3 samples
for (i in 1:5){
  sample.specs<-c(sample(c(25:29),size = 2), #locality 1
                  sample(c(30:37),size = 2), #locality 2
                  23,24, #locality 3
                  sample(c(11:22,38,39),size = 2), #locality 4
                  46, #locality 5
                  sample(c(43:45),size = 2), #locality 6
                  41,42, #locality 7
                  47,48, #locality 8
                  sample(c(2:6),size = 2), #locality 9
                  10, #locality 10
                  sample(c(7:9),size = 2))

  #subset the random samples plus the vcfR info (column 1)
  vcf.sub <- vcfR[,c(1,sample.specs)]
  #filter out invariant sites
  vcf.comp<-min_mac(vcf.sub, min.mac = 1)
  #write filtered subset vcf to disk
  print(colnames(vcf.comp@gt)) #print sample names in retained vcf
  print(pops$populations[sample.specs-1]) #print the assigned taxa for each sample to make sure we have subsampled correctly
  print(pops$Locality_number[sample.specs-1]) #print assigned locality to double check subsampling
  #extract genotype matrix
  vcf.gt<-extract.gt(vcf.comp, element = "GT", as.numeric = F, convertNA = T)
  #convert 'NA' to '?'
  vcf.gt[is.na(vcf.gt)]<-"?"
  #convert '0/0' to '0'
  vcf.gt[vcf.gt == "0/0"]<-"0"
  #convert '0/1' to '1'
  vcf.gt[vcf.gt == "0/1"]<-"1"
  #convert '1/1' to '2'
  vcf.gt[vcf.gt == "1/1"]<-"2"
  #transpose matrix
  vcf.gt <- t(vcf.gt)
  #write to disk as nexus file
  ape::write.nexus.data(x = vcf.gt, file = paste0("./PhylogeneticTrees/SNAPP/",i,".nex"),format = "DNA", interleaved = FALSE)
}

#read in last nexus file and double check it worked
nex.file <- scan(file=paste0("./PhylogeneticTrees/SNAPP/",i,".nex"), what = "character", sep = "\n",quiet = TRUE)
nex.file
