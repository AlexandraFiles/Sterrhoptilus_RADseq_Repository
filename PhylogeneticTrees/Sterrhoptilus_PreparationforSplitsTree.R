#Creating Pairwise Divergence Matrix for Splits tree

library(vcfR)
library(adegenet)
library(StAMPP)

#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
#read in vcf file
v<-read.vcfR("./Data/Sterrhoptilus_vcf.gz")

#remove outgroup samples
v.sub<-v[,colnames(v@gt) != "S_plateni_19056" & colnames(v@gt) != "S_plateni_28305" & colnames(v@gt) != "S_plateni_28350"]

#convert vcfR to genlight
gen<-vcfR2genlight(v.sub)

#check sample names, can't have more than 10 characters per name for SplitsTree
gen@ind.names

#editing names to fit this criteria
gen@ind.names<-gsub("S_capitalis","cap", gen@ind.names)
gen@ind.names<-gsub("S_dennistouni","den", gen@ind.names)
gen@ind.names<-gsub("S_nigrocapitata","ni", gen@ind.names)
gen@ind.names<-gsub("cap_CMNH37769","cap_37769", gen@ind.names)

#renaming the affinis samples
gen@ind.names<-gsub("ni_18040","aff_18040", gen@ind.names)
gen@ind.names<-gsub("ni_18034","aff_18034", gen@ind.names)
gen@ind.names<-gsub("ni_18083","aff_18083", gen@ind.names)
gen@ind.names<-gsub("ni_25550","aff_25550", gen@ind.names)

#double check sample names
gen@ind.names

#assign sample names as populations
#StAMPP requires populations but since we want a pairwise distance matrix between all samples, each sample needs to be its own pop
pop(gen)<-gen@ind.names

#make pairwise divergence matrix among all samples
sample.div <- stamppNeisD(gen, pop = FALSE)

#export for splitstree
stamppPhylip(distance.mat=sample.div, file="C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/PhylogeneticTrees/splitstree.nooutgroup.txt")
