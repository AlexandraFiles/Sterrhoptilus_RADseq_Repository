#SNAPP Tree

library(vcfR)
library(SNPfiltR)

#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
#read in unlinked vcf
vcfR <- read.vcfR("./Data/Sterrhoptilus_vcf_thinned.gz")
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
#dennistouni are columns 11-40, affinis are columns 43-46, nigrocapitatus are columns 41, 42, 47 and 48, capitalis are columns 2-10,
#plateni are columns 49-51 and are completely excluded
#exclude the following putative hybrids
#putative hybrid affinis is column 46
#dennistouni hybrids are columns 11-22 and 38 and 39

#use a for loop to randomly down sample 3 samples from each of the 4 species, excluding birds from the hybrid zone
for (i in 1:5){
  #randomly sample 3 individuals from each of the 4 lineages
  sample.specs<-c(sample(c(23:37,40),size = 3),
                  sample(c(43:45),size = 3),
                  sample(c(41,42,47,48),size = 3),
                  sample(c(2:10),size = 3))

  #subset the random samples plus the vcfR info (column 1)
  vcf.sub <- vcfR[,c(1,sample.specs)]
  #filter out invariant sites
  vcf.comp<-min_mac(vcf.sub, min.mac = 1)
  #write filtered subset vcf to disk
  print(colnames(vcf.comp@gt)) #print sample names in retained vcf
  print(pops$populations[sample.specs-1]) #print the assigned taxa for each sample to make sure we have subsampled correctly
  #uncomment if you want to save a vcf for each replicate, rather than just a nexus
  #vcfR::write.vcf(vcf.comp, file = paste0("~/Desktop/phil.dicaeum/snapp/rep",i,".vcf.gz")) #write to disk
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
