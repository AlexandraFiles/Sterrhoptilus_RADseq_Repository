#Making the triangle plot

library(triangulaR)
library(vcfR)

#setworking directory and read in vcf and popmap
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
v <- read.vcfR("./Data/Sterrhoptilus.vcf.gz", verbose = F)
popmap <- read.delim("./TrianglePlot/Sterrhoptilus_popmap.txt")

#remove outgroup samples
v<-v[,colnames(v@gt) != "S_plateni_19056" & colnames(v@gt) != "S_plateni_28305" & colnames(v@gt) != "S_plateni_28350"]
#remove capitalis and nigrocapitatus
#names of capitalis
cap_list <- c("S_capitalis_28326","S_capitalis_28338","S_capitalis_28339","S_capitalis_28341","S_capitalis_28342","S_capitalis_29959","S_capitalis_29965","S_capitalis_29968","S_capitalis_CMNH37769")
for(i in cap_list) {
  v <- v[,colnames(v@gt) != i]
}
#names of nigrocapitatus
ni_list <- c("S_nigrocapitata_14192","S_nigrocapitata_14199","S_nigrocapitata_33030","S_nigrocapitata_33060")
for(i in ni_list) {
  v <- v[,colnames(v@gt) != i]
}

#choose an allele frequency threshold
#70%, 80%, 90% and 100% completeness results in 217, 163, 106, and 74 SNPs respectively
v.diff <- alleleFreqDiff(vcfR = v, pm = popmap, p1 = "dennistouni_north", p2 = "affinis", difference = 0.9)

#calculate heterozygosity and hybrid index of SNPs
hi.het <- hybridIndex(vcfR = v.diff, pm = popmap, p1 = "dennistouni_north", p2 = "affinis")

plot_cols <- c("#6e6e6e", "#6e6e6e", "#f3b519", "#b79300")
triangle.plot(hi.het, colors = plot_cols)
