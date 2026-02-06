#code to generate a figure showing whether
#the mean worst is across seeds is the same for all models

rm(list=ls())
graphics.off()

if(dir.exists("Sam_Figures")==FALSE) dir.create("Sam_Figures")

source("0_library.R")
source("extra_functions.R")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

load("./Ranking_Data/text_meanWorstAllMod")
text_meanWorstAllMod[which(is.na(text_meanWorstAllMod))]<- "None"

# Row names and column names of the plot
rownames(text_meanWorstAllMod) <- tested_D_num
colnames(text_meanWorstAllMod) <- eval_time_lab
# Color palette
#cols<-brewer.pal(n = 3, name = "Set3")
cols<-c("white","maroon","purple")

pdf(file = "./Sam_Figures/MeanSlowestAcrossSeedsForAllModels.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(text_meanWorstAllMod[nrow(text_meanWorstAllMod):1, ],breaks = c("None","BASS","Sobol"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()