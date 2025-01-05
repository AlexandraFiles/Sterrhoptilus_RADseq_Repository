#Treemix visualization

library(RColorBrewer)
library(R.utils)
#set working directory
setwd("C:/Users/Alex/OneDrive/Documents/KUprojects/Stachyrisproject/Manuscript/Sterrhoptilus_RADseq_Repository/")
source("./PhylogeneticTrees/TreeMix/plotting_funcs.R")

#plot trees using the plotting_funcs R script
#looking at iteration 1 of 5 for each added edge
plot_tree("./PhylogeneticTrees/Treemix/treemix_results/Sterrhoptilus_treemix.1.1")
plot_tree("./PhylogeneticTrees/Treemix/treemix_results/Sterrhoptilus_treemix.1.2")
plot_tree("./PhylogeneticTrees/Treemix/treemix_results/Sterrhoptilus_treemix.1.3")
plot_tree("./PhylogeneticTrees/Treemix/treemix_results/Sterrhoptilus_treemix.1.4")
plot_tree("./PhylogeneticTrees/Treemix/treemix_results/Sterrhoptilus_treemix.1.5")

#plot to see how much variance is explained by each edge
m=NULL
for(i in 0:5){
  m[i+1] <- get_f(paste0("./PhylogeneticTrees/TreeMix/treemix_results/Sterrhoptilus_treemix.1.",i))
}

#print variance explained by each tree with varying numbers of migration edges
m
plot(seq(0,5),m,pch="*",cex=2,col="blue", type="b",xlab="migration edge number", ylab="% explained variance")

#using the R package OptM to alternatively select model of best fit

library(OptM)

folder <- "./PhylogeneticTrees/Treemix/treemix_results"

#data is too homogenous for the Evanno method to work
test.optM = optM(folder)
plot_optM(test.optM, method = "Evanno")

test.linear = optM(folder, method = "linear")
plot_optM(test.linear, method = "linear")

test.sizer = optM(folder, method = "SiZer")
plot_optM(test.sizer, method = "SiZer")
