#PCA on Quality Controlled SNPs

library(vcfR)
library(adegenet)
library(StAMPP)
library(ggplot2)

#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
#read in vcf
v<-read.vcfR("./Data/Sterrhoptilus.vcf.gz")
#read in population file
pops <- read.csv("./Data/Sterrhoptilus_SamplingData.csv")

#remove outgroup from vcf
v.sub<-v[,colnames(v@gt) != "S_plateni_19056" & colnames(v@gt) != "S_plateni_28305" & colnames(v@gt) != "S_plateni_28350"]

#remove any samples from population file that did not make it past quality control
pops<-pops[pops$ID %in% colnames(v.sub@gt),]
#reorder the sample info file to match the order of samples in the vcf
pops<-pops[order(match(pops$ID,colnames(v.sub@gt)[-1])),]

#convert vcfR to genlight
gen<-vcfR2genlight(v.sub)

#perform PCA
sterrhoptilus.pca<-glPca(gen, nf=6)
#isolate PCA scores as a dataframe
sterrhoptilus.pca.scores<-as.data.frame(sterrhoptilus.pca$scores)
#make sure sample info file is identical in order to the resulting PCA output
#all should be true
rownames(sterrhoptilus.pca.scores) == pops$ID

#add in the relevant population identifier you would like to color-code by
sterrhoptilus.pca.scores$pop<-pops$species

#find porportion of variance explained by PC1
sterrhoptilus.pca[["eig"]][1]/sum(sterrhoptilus.pca[["eig"]])
#answer is 26.258%
#PC2
sterrhoptilus.pca[["eig"]][2]/sum(sterrhoptilus.pca[["eig"]])
#answer is 7.030%

ggplot(sterrhoptilus.pca.scores, aes(x=PC1, y=PC2)) +
  geom_point(aes(fill=pop), pch=21, size=5)+
  scale_fill_manual(values=c("#f4b71c","#6f6f6f","#242424","#d83406"), name = "Populations",
                    breaks = c("dennistouni","affinis","nigrocapitatus","capitalis"),
                    labels = c(expression(italic("S. dennistouni")), expression(italic("S. affinis")),
                               expression(italic("S. nigrocapitatus")), expression(italic("S. capitalis"))))+
  xlab("PC1, 26.3% variance explained")+
  ylab("PC2, 7.0% variance explained")+
  theme_classic() +
  theme(legend.position = c(0.12,0.78), legend.justification = c(0.01, 0.01),
      legend.background = element_blank(), legend.spacing.y = unit(0.01, "cm"), legend.text.align = 0)
