#Triangle Plot with five most northern dennistouni

library(introgress)
library(vcfR)
library(adegenet)
library(SNPfiltR)
library(ggplot2)

#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
#read in vcf file
vcf<-read.vcfR("./Data/Sterrhoptilus_vcf.gz")
#read in subsetted sample data without outgroups, S. nigrocapitatus, S. capitalis, or northern S. dennistouni
locs<-read.csv("./Data/Sterrhoptilus_SamplingData.csv")

#remove outgroup, S. capitalis, S. nigrocapitatus, and northern S. dennistouni from vcf file
#check names to see which columns to keep
colnames(vcf@gt)
#subset vcf file to only keep southern S. dennistouni and S. affinis
vcf@gt<-vcf@gt[,c(1,11:40,43:46)]
#subset locs to include only samples that passed filtering and have been retained in the vcf, and remove populations that aren't used in this analysis
locs<-locs[locs$ID %in% colnames(vcf@gt),]

#order population data to match vcf
locs<-locs[order(match(locs$ID,colnames(vcf@gt)[-1])),]
#verify that everything was subsetted correctly, all should return true
colnames(vcf@gt)[-1] == locs$ID

#remove SNPs with a minor allele count of 1
vcf<-min_mac(vcf, min.mac = 1)

#convert to genlight
gen<-vcfR2genlight(vcf)

#create SNP matrices
mat<-extract.gt(vcf)

#change allele data formatting
conv.mat<-mat
conv.mat[conv.mat == "0/0"]<-0
conv.mat[conv.mat == "0/1"]<-1
conv.mat[conv.mat == "1/1"]<-2
conv.mat<-as.data.frame(conv.mat)
#convert to numeric
for (i in 1:ncol(conv.mat)){
  conv.mat[,i]<-as.numeric(as.character(conv.mat[,i]))
}

#find column numbers for parental populations
colnames(conv.mat)
#five S. dennistouni from farthest away are 25696, 25703, 25702, 25176 and 25743, or indices 15-19.
#calc AF for the samples that will be used to call fixed differences
denn.af<-(rowSums(conv.mat[,c(15,16,17,18,19)], na.rm=T)/(rowSums(is.na(conv.mat[,c(15,16,17,18,19)]) == FALSE)))/2
nigr.af<-(rowSums(conv.mat[,c(31,32,33)], na.rm=T)/(rowSums(is.na(conv.mat[,c(31,32,33)]) == FALSE)))/2

#find fixed SNPs
diff<-abs(denn.af - nigr.af)
#how many SNPs are fixed with a SNP completeness greater than 0.8
table(is.na(diff) == FALSE & diff > .8)

#subsample original matrix to only fixed diff SNPs
gen.mat<-mat[is.na(diff) == FALSE & diff > .8,]
#confirm this worked
dim(gen.mat)

#subsample matrix converted for AF calcs to only fixed SNPS
conv.mat<-conv.mat[is.na(diff) == FALSE & diff > .8,]
#confirm this worked
dim(conv.mat)

#write a logical test to convert alleles so that a single number represents one parental ancestry
for (i in 1:nrow(gen.mat)){
  #if 1 is the affinis allele (ie < .2 frequency in the dennistouni samples used for identifying informative SNPs)
  if((sum(conv.mat[i,c(15,16,17,18,19)], na.rm=T)/(sum(is.na(conv.mat[i,c(15,16,17,18,19)]) == FALSE)))/2 < .2){
    #swap all '0/0' cells with '2/2'
    gen.mat[i,][gen.mat[i,] == "0/0"]<-"2/2"
    #swap all '1/1' cells with '0/0'
    gen.mat[i,][gen.mat[i,] == "1/1"]<-"0/0"
    #finally convert all '2/2' cells (originally 0/0) into '1/1'
    gen.mat[i,][gen.mat[i,] == "2/2"]<-"1/1"
    #no need to touch hets
  }
}

#convert R class NAs to the string "NA/NA"
gen.mat[is.na(gen.mat) == TRUE]<-"NA/NA"

#make locus info dataframe
locus.info<-data.frame(locus=rownames(gen.mat),
                       type=rep("C", times=nrow(gen.mat)),
                       lg=vcf@fix[,1][is.na(diff) == FALSE & diff > .8],
                       marker.pos=vcf@fix[,2][is.na(diff) == FALSE & diff > .8])

#use properly formatted gt matrix with introgress
#convert genotype data into a matrix of allele counts
count.matrix<-prepare.data(admix.gen=gen.mat, loci.data=locus.info,
                           parental1="1",parental2="0", pop.id=F,
                           ind.id=F, fixed=T)
#estimate hybrid index values
hi.index.sim<-est.h(introgress.data=count.matrix,loci.data=locus.info,
                    fixed=T, p1.allele="1", p2.allele="0")

#calculate mean heterozygosity across fixed SNPs
het<-calc.intersp.het(introgress.data=count.matrix)

#plot triangle
plot(x=hi.index.sim$h, y=het, bg=c(rep(rgb(0.9568627450980393, 0.7176470588235294, 0.10980392156862745,alpha=.5), times=30), rep(rgb(0.43529411764705883,0.43529411764705883,0.43529411764705883,alpha=.5), times=4)),
     pch=21, cex=1.5,
     xlab="Hybrid Index", ylab="Interspecific heterozygosity",
     ylim=c(0,1),
     xlim=c(0,1))
#add triangle lines
segments(x0 =0, y0 =0, x1 =.5, y1 =1)
segments(x0 =1, y0 =0, x1 =.5, y1 =1)
