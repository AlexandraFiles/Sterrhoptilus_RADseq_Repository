#Filtering SNPs

library(SNPfiltR)
library(devtools)
library(vcfR)

setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
vcfR <- read.vcfR("./Data/Running_Stacks/n4.vcf")
vcfR <- vcfR[,colnames(vcfR@gt) !="S_whiteheadi_18001"] #removing the one whiteheadi
popmap<-data.frame(id=colnames(vcfR@gt)[2:length(colnames(vcfR@gt))],pop=substr(colnames(vcfR@gt)[2:length(colnames(vcfR@gt))], 3,9))

#visualize distributions
hard_filter(vcfR=vcfR)

vcfR1<-hard_filter(vcfR=vcfR, depth = 5, gq = 35) #renamed to look, change after
#execute allele balance filter
vcfR1<-filter_allele_balance(vcfR1)

#visualize and pick appropriate max depth cutoff
max_depth(vcfR1)

#filter vcf by the max depth cutoff
vcfR2<-max_depth(vcfR1, maxdepth = 125)

#run function to visualize samples
missing_by_sample(vcfR=vcfR2, popmap = popmap)

#run function to drop samples above the threshold we want from the vcf
vcfR3<-missing_by_sample(vcfR=vcfR2, cutoff = .97)

#subset popmap to only include retained individuals
popmap1<-popmap[popmap$id %in% colnames(vcfR3@gt),]

vcfR3<-min_mac(vcfR3, min.mac = 1)

miss<-assess_missing_data_pca(vcfR=vcfR3, popmap = popmap1, thresholds = .8, clustering = FALSE)

missing_by_snp(vcfR3)

#verify that missing data is not driving clustering patterns among the retained samples at some reasonable thresholds
miss<-assess_missing_data_pca(vcfR=vcfR3, popmap = popmap1, thresholds = c(.7,.8,.85), clustering = FALSE)

#choose a value that retains an acceptable amount of missing data in each sample, and maximizes SNPs retained while minimizing overall missing data, and filter vcf
vcfR4<-missing_by_snp(vcfR3, cutoff = .7)

#investigate clustering patterns with and without a minor allele cutoff
#use min.mac() to investigate the effect of multiple cutoffs
vcfR4.mac<-min_mac(vcfR = vcfR4, min.mac = 2)

#assess clustering without MAC cutoff
miss<-assess_missing_data_tsne(vcfR4, popmap1, clustering = FALSE)
#assess clustering with MAC cutoff
miss.mac<-assess_missing_data_tsne(vcfR4.mac, popmap1, clustering = FALSE)

misspca <- assess_missing_data_pca(vcfR4, popmap1, clustering = FALSE)
misspca.mac <- assess_missing_data_pca(vcfR4.mac, popmap1, clustering = FALSE)

#plot depth per snp and per sample
dp <- extract.gt(vcfR4, element = "DP", as.numeric=TRUE)
heatmap.bp(dp, rlabels = FALSE)

#plot genotype quality per snp and per sample
gq <- extract.gt(vcfR4, element = "GQ", as.numeric=TRUE)
heatmap.bp(gq, rlabels = FALSE)

#write out vcf with all SNPs
vcfR::write.vcf(vcfR4, "Sterrhoptilus_vcf.gz")

#linkage filter vcf to thin SNPs to one per 500bp
vcfR.thin<-distance_thin(vcfR4, min.distance = 500)
# 5341 out of 16639 input SNPs were not located within 500 base-pairs of another SNP and were retained despite filtering

#write out thinned vcf
vcfR::write.vcf(vcfR.thin, "Sterrhoptilus_vcf_thinned.gz")
