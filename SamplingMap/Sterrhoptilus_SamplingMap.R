#Generating sampling map

library(ggplot2)
library(rgeoboundaries)
library(sf)

#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")

#read in sampling file
#columns named Latitude, Longitude, and species are of interest
pops<- read.csv("./Data/Sterrhoptilus_SamplingData.csv")

#generate list of unique latitudes
unq<-pops[!duplicated(pops$Latitude),]
#for each unique latitude, find how many samples are from there by adding a sample size column
unq$sample.size<-as.vector(table(pops$Latitude)[order(match(names(table(pops$Latitude)),unq$Latitude))])

#get map of Philippines from rgeoboundaries
phil_bound <- geoboundaries("Philippines")
#set how big you want boundaries around points to be
g=1
#subset map outline based on sampling
phil_bound <- st_crop(phil_bound, xmin = min(unq$Longitude)-g, xmax = max(unq$Longitude)+g,
                      ymin = min(unq$Latitude)-g, ymax = max(unq$Latitude)+g)

#plot figure
ggplot() +
  geom_sf(data = phil_bound, fill = "#c7c7c7", color = NA) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        rect = element_blank()) +
  geom_point(data = unq, aes(x = Longitude, y = Latitude, color=Species, size=sample.size), show.legend=TRUE) +
  scale_color_manual(values=c("#f4b71c","#6f6f6f","#242424","#d83406"),
                     breaks = c("dennistouni","affinis","nigrocapitatus","capitalis"),
                     labels = c(expression(italic("S. dennistouni")), expression(italic("S. affinis")),
                              expression(italic("S. nigrocapitatus")), expression(italic("S. capitalis"))))+
  geom_point(data = unq, aes(x = Longitude, y = Latitude, size=sample.size), shape=21, colour="black")+
  labs(x = "", y = "", size="Count", color="Species")+
  theme(legend.position = c(0.67, 0.57), legend.justification = c(0.01, 0.01),
        legend.background = element_blank(), legend.spacing.y = unit(0.01, "cm"), legend.text.align = 0)+
  guides(color = guide_legend(order = 1, override.aes = list(size=4, shape=21, color = "black",
         fill=c("#f4b71c","#6f6f6f","#242424","#d83406"))),
         size = guide_legend(order = 2, override.aes = list(shape=21)))+
  scale_size(range = c(2,7), breaks=c(2,5,10))
