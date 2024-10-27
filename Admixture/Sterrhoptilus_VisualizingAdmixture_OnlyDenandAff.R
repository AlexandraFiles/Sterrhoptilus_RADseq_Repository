#Generating ADMIXTURE plots for subsetted data with only dennistouni and affinis

library(vcfR)
library(SNPfiltR)
library(ggplot2)

#using results from cluster
#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")

#read in log error values to determine optimal K
log<-read.table("./Admixture/AdmixOnlyDenandAffNoSingletons/log.errors.txt")[,c(3:4)]
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
#lowest value is 2

#read in input file
sampling<-read.table("./Admixture/AdmixOnlyDenandAffNoSingletons/binary_fileset.fam")[,1]
#get list of input samples in order they appear
sampling

#read in all ten runs and save each dataframe in a list
runs<-list()
#read in log files
for (i in 1:10){
  runs[[i]]<-read.table(paste0("./Admixture/AdmixOnlyDenandAffNoSingletons/binary_fileset.", i, ".Q"))
}

#plot each run
par(mfrow=c(1,1))
for (i in 1:5){
  barplot(t(as.matrix(runs[[i]])), col=rainbow(i), ylab="Ancestry", border="black")
}

#sorting the runs to be in order of dennistouni then affinis background
#this will sort the birds in order of dennistouni background, so the individuals will be ordered dennstouni, hybrids, then affinis
runs[[2]]<-runs[[2]][with(runs[[2]], order(-V2, -V1)), ]

#set margins
par(mar = c(0.5, 0.5, 1, 1), oma = c(6, 0.5, 1, 1))
par(mfrow=c(1,1))

#plot barplots using the sorted runs
barplot(t(as.matrix(runs[[2]])), col=c("#6f6f6f","#f4b71c"), ylab="Ancestry", border="black" , names.arg = F)

#add lines for labels
segments(x0 = 0.2, y0 = -0.03,x1 = 35.8, y1 = -0.03, xpd = NA, lwd = 3, col = "#f4b71c")
segments(x0 = 36.3, y0 = -0.03,x1 = 40.8, y1 = -0.03, xpd = NA, lwd = 3, col = "#6f6f6f")
#add text for labels
text(x = 20.5, y = -0.16, labels = "S. dennistouni", xpd = NA, srt = -45)
text(x = 40.1, y = -0.122, labels = "S. affinis", xpd = NA, srt = -45)
