#Generating ADMIXTURE plots for all four Sterrhoptilus species

library(vcfR)
library(SNPfiltR)
library(ggplot2)

#using results from cluster
#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")

#read in log error values to determine optimal K
log<-read.table("./Admixture/AdmixAllSpeciesNoSingletons/log.errors.txt")[,c(3:4)]
log$V3<-gsub("\\(K=", "", log$V3)
log$V3<-gsub("):", "", log$V3)
#interpret K values as numerical
log$V3<-as.numeric(log$V3)
#rename columns
colnames(log)<-c("Kvalue","cross.validation.error")

#make plot showing the cross validation error across K values 1:10
ggplot(data=log, aes(x=Kvalue, y=cross.validation.error, group=1)) +
  geom_line(linetype = "dashed")+
  geom_point()+
  ylab("cross-validation error")+
  xlab("K")+
  scale_x_continuous(breaks = c(1:10))+
  theme_classic()
#lowest value is 4, 2 is close second

#read in input file
sampling<-read.table("./Admixture/AdmixAllSpeciesNoSingletons/binary_fileset.fam")[,1]
#get list of input samples in order they appear
sampling

#read in all ten runs and save each dataframe in a list
runs<-list()
#read in log files
for (i in 1:10){
  runs[[i]]<-read.table(paste0("./Admixture/AdmixAllSpeciesNoSingletons/binary_fileset.", i, ".Q"))
}

#plot each run
par(mfrow=c(1,1))
for (i in 1:5){
  barplot(t(as.matrix(runs[[i]])), col=rainbow(i), ylab="Ancestry", border="black")
}

#run 3 now will be sorted first by dennistoui ancestry (column V2) descending, then by nigrocapitatus/affinis ancestry (column V1) descending
#this will create order of dennistouni, affinis, nigrocapitatus, capitalis
runs[[3]]<-runs[[3]][with(runs[[3]], order(-V2, -V1)), ]
#run 4 will be sorted first by dennistouni ancestry (V3) descending, then by affinis ancestry (V4) descending, then by capitalis ancestry (V1) ascending
#this will create order of dennistouni, hybrids by background, affinis, nigrocapitatus, capitalis
runs[[4]]<-runs[[4]][with(runs[[4]], order(-V3, -V4, V1)), ]
#for singletons, additionally sort by capitalis ancestry (V2) ascending first
#runs[[4]]<-runs[[4]][with(runs[[4]], order(V2, -V3, -V4)), ]

#set margins
par(mar = c(0.5, 0.5, 1, 1), oma = c(6, 0.5, 1, 1))
par(mfrow=c(1,1))

#plot barplots using the sorted runs
barplot(t(as.matrix(runs[[3]])), col=c("#242424","#f4b71c","#d83406"), ylab="Ancestry", border="black" , names.arg = F)
barplot(t(as.matrix(runs[[4]])), col=c("#d83406","#242424","#f4b71c","#6f6f6f"), ylab="Ancestry", border="black", names.arg = F)
#for singleton runs, use the following order for correct colors
#barplot(t(as.matrix(runs[[4]])), col=c("#242424", "#d83406","#f4b71c","#6f6f6f"), ylab="Ancestry", border="black", names.arg = F)

#add lines for labels
segments(x0 = 0.2, y0 = -0.03,x1 = 35.8, y1 = -0.03, xpd = NA, lwd = 3, col = "#f4b71c")
segments(x0 = 36.3, y0 = -0.03,x1 = 40.8, y1 = -0.03, xpd = NA, lwd = 3, col = "#6f6f6f")
segments(x0 = 41.2, y0 = -0.03,x1 = 45.6, y1 = -0.03, xpd = NA, lwd = 3, col = "#242424")
segments(x0 = 46, y0 = -0.03,x1 = 56.4, y1 = -0.03, xpd = NA, lwd = 3, col = "#d83406")
#add text for labels
text(x = 20.5, y = -0.14, labels = "S. dennistouni", xpd = NA, srt = -45)
text(x = 53.4, y = -0.119, labels = "S. capitalis", xpd = NA, srt = -45)
text(x = 40.1, y = -0.102, labels = "S. affinis", xpd = NA, srt = -45)
text(x = 46.5, y = -0.158, labels = "S. nigrocapitatus", xpd = NA, srt = -45)

#Or, to display together:
par(mar = c(0, 3, 0.5, 0.5), oma = c(6, 0.25, 0, 0))
par(mfrow=c(2,1))

#plot barplots using the sorted runs
barplot(t(as.matrix(runs[[3]])), col=c("#242424","#f4b71c","#d83406"), ylab="Ancestry", border="black" , names.arg = F)
#for singleton runs, use the following order for colors
#barplot(t(as.matrix(runs[[3]])), col=c("#f4b71c", "#d83406", "#242424"), ylab="Ancestry", border="black" , names.arg = F)
barplot(t(as.matrix(runs[[4]])), col=c("#d83406","#242424","#f4b71c","#6f6f6f"), ylab="Ancestry", border="black", names.arg = F)
#for singleton runs, use the following order for correct colors
#barplot(t(as.matrix(runs[[4]])), col=c("#242424", "#d83406","#f4b71c","#6f6f6f"), ylab="Ancestry", border="black", names.arg = F)

#add lines for labels
segments(x0 = 0.2, y0 = -0.03,x1 = 35.8, y1 = -0.03, xpd = NA, lwd = 3, col = "#f4b71c")
segments(x0 = 36.3, y0 = -0.03,x1 = 40.8, y1 = -0.03, xpd = NA, lwd = 3, col = "#6f6f6f")
segments(x0 = 41.2, y0 = -0.03,x1 = 45.6, y1 = -0.03, xpd = NA, lwd = 3, col = "#242424")
segments(x0 = 46, y0 = -0.03,x1 = 56.4, y1 = -0.03, xpd = NA, lwd = 3, col = "#d83406")
#add text for labels
text(x = 20.5, y = -0.25, labels = "S. dennistouni", xpd = NA, srt = -45)
text(x = 53.4, y = -0.21, labels = "S. capitalis", xpd = NA, srt = -45)
text(x = 40.1, y = -0.18, labels = "S. affinis", xpd = NA, srt = -45)
text(x = 46.5, y = -0.29, labels = "S. nigrocapitatus", xpd = NA, srt = -45)
