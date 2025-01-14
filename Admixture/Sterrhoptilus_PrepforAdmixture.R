#Preparing vcf for ADMIXTURE runs

library(vcfR)
library(SNPfiltR)

#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
#read in vcf file
v<-read.vcfR("./Data/Sterrhoptilus_thinned.vcf.gz")

#prepping for ADMIXTURE
#must make chromosome names non-numeric
v@fix[,1]<-paste("a", v@fix[,1], sep="")

#remove outgroups
v<-v[,colnames(v@gt) != "S_plateni_19056" & colnames(v@gt) != "S_plateni_28305" & colnames(v@gt) != "S_plateni_28350"]
#optional: remove capitalis
#v<-v[,colnames(v@gt) != "S_capitalis_28326" & colnames(v@gt) != "S_capitalis_28341" & colnames(v@gt) != "S_capitalis_28342"
#     & colnames(v@gt) != "S_capitalis_28339" & colnames(v@gt) != "S_capitalis_28338" & colnames(v@gt) != "S_capitalis_29959"
#     & colnames(v@gt) != "S_capitalis_29968" & colnames(v@gt) != "S_capitalis_29965" & colnames(v@gt) != "S_capitalis_CMNH37769"]
#optional: remove nigrocapitatus
#v<-v[,colnames(v@gt) != "S_nigrocapitata_14199" & colnames(v@gt) != "S_nigrocapitata_14192"
#     & colnames(v@gt) != "S_nigrocapitata_33060"& colnames(v@gt) != "S_nigrocapitata_33030"
#     & colnames(v@gt) != "S_nigrocapitata_31603"]

#remove invariant sites
v<-min_mac(v, min.mac = 1)
#make another file with no singletons
v.x<-min_mac(v, min.mac = 2)

#write to disk to run on cluster
#change naming to reflect subsetted data
vcfR::write.vcf(v, file="sterrhoptilusadmix_nooutgroup.vcf.gz")
vcfR::write.vcf(v.x, file="sterrhoptilusadmix_nooutgroup.mac.vcf.gz")
