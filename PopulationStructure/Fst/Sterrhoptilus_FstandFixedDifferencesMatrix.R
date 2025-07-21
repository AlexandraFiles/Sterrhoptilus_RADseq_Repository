#Calculating Fsts

library(vcfR)
library(adegenet)
library(StAMPP)
library(ggplot2)
library(reshape2)

#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
#read in vcf
v<-read.vcfR("./Data/Sterrhoptilus.vcf.gz")
#read in population file
pops <- read.csv("./Data/Sterrhoptilus_SamplingData.csv")

#remove any samples from population file that did not make it past quality control
pops<-pops[pops$ID %in% colnames(v@gt),]
#reorder the sample info file to match the order of samples in the vcf
pops<-pops[order(match(pops$ID,colnames(v@gt)[-1])),]

#remove outgroup
v.sub<-v[,colnames(v@gt) != "S_plateni_19056" & colnames(v@gt) != "S_plateni_28305" & colnames(v@gt) != "S_plateni_28350"]

#convert vcfR to genlight
gen<-vcfR2genlight(v.sub)

#assign populations to samples (S. dennistouni split into Northern and Southern populations)
gen@pop<-as.factor(pops$populations)
#calculate pairwise Fst using the StAMPP package
di.heat<-stamppFst(gen)
#extract the pairwise matrix
m<-di.heat$Fsts
#m[order(row.names(x=m)), order(colnames(x=m))]
#fill in upper triangle of the matrix
m[upper.tri(m)] <- t(m)[upper.tri(m)]

#melt to tidy format for ggplotting
heat <- reshape2::melt(m)

#identify the number of fixed differences between populations
#convert vcf to genotype matrix
mat<-extract.gt(v.sub)
conv.mat<-mat
conv.mat[conv.mat == "0/0"]<-0
conv.mat[conv.mat == "0/1"]<-1
conv.mat[conv.mat == "1/1"]<-2
conv.mat<-as.data.frame(conv.mat)
#convert to numerical matrix
for (i in 1:ncol(conv.mat)){
  conv.mat[,i]<-as.numeric(as.character(conv.mat[,i]))
}

#compare colnames to matrix to verify it subset correct
#all should be true
colnames(conv.mat) == pops$ID

#make vector to fill with number of pairwise fixed diffs
f<-c()

#calculate number of fixed differences for each population comparison
for (i in 1:nrow(heat)){
  #calc af of pop1 and pop2
  pop1.af<-(rowSums(conv.mat[,pops$populations == heat$Var1[i]], na.rm=T)/(rowSums(is.na(conv.mat[,pops$populations == heat$Var1[i]]) == FALSE)))/2
  pop2.af<-(rowSums(conv.mat[,pops$populations == heat$Var2[i]], na.rm=T)/(rowSums(is.na(conv.mat[,pops$populations == heat$Var2[i]]) == FALSE)))/2
  #store number of fixed differences
  f[i]<-sum(is.na(abs(pop1.af - pop2.af)) == FALSE & abs(pop1.af - pop2.af) == 1) #find fixed SNPs and add to vector
}

#add number of fixed diffs to existing dataframe
heat$fixed<-f

#create vector of Fst and fixed difference values
#define n as the number of taxa used in pairwise Fst comparison
#four species but five populations because S. dennistouni is split
n<-5
#set incrementer to 1
i<-1
#create an empty vector
x<-c()
#while loop that will make the appropriate vector and store it in the variable 'x'
while (i < n){
  #the first set of numbers is simply 2:n
  if(i == 1){
    x<-c(2:n)
    i=i+1
  }
  #the second set of numbers is (2+n+1):(2*n) which are added to the existing vector
  if(i == 2){
    x<-c(x,(2+n+1):(2*n))
    i=i+1
  }

  #add (2+((i-1)*(n+1))):(i*n) to the vector, where i=3, increment i by 1, and continue adding this vector to the growing vector until i = n-1
  if(i > 2){
    x<-c(x,(2+((i-1)*(n+1))):(i*n))
    i=i+1
  }
}

#order populations by geographical order
heat$Var1 <- factor(heat$Var1, levels =c("Northern S. dennistouni", "Southern S. dennistouni", "S. affinis", "S. nigrocapitatus", "S. capitalis"))
heat$Var2 <- factor(heat$Var2, levels =c("Northern S. dennistouni", "Southern S. dennistouni", "S. affinis", "S. nigrocapitatus", "S. capitalis"))
heat <- heat[order(heat$Var2, heat$Var1),]

#order Fst and fixed difference values correctly in a single mixed vector
#plots Fst values above and # of fixed differences below the diagonal in the heatmap
heat$mixed<-heat$value
heat$mixed[x]<-heat$fixed[x]

#plot with labels
matrix <- ggplot(data = heat, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile()+
  geom_text(data=heat,aes(label=round(mixed, 2)), size=4)+
  theme_void()+
  scale_fill_gradient2(low = "white", high = "red", name="Fst") +
  theme(axis.text.x = element_text(angle = 45, vjust=.9, hjust = .9, size=12),
        axis.text.y = element_text(angle = 45, hjust = 1, size=12),
        axis.title.x = element_blank(), axis.title.y = element_blank())

ggsave("Fst_matrix.svg", matrix, width = 5.5,height = 3.5,units = "in")
