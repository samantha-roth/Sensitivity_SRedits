#code to generate recommendations based on all considered criteria
#to be used as graphical abstract for Environmental Modelling & Software

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

#for mean Sobol' times
load("./Ranking_Data/textMat_SobolEnough_All")

#I don't trust 4,4
textMat_SobolEnough_All[4,4]<- "No"

# Color palette
cols<-c("purple","white")

pdf(file = "./Sam_Figures/SobolEnough_AllModels.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(textMat_SobolEnough_All[nrow(textMat_SobolEnough_All):1, ],breaks = c("Yes","No"),
     xlab="Model run time",ylab="Number of model parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

#repeat for max Sobol' times
load("./Ranking_Data/textMat_SobolMaxEnough_All")

#I don't trust 4,4
textMat_SobolMaxEnough_All[4,4]<- "No"

# Color palette
cols<-c("purple","white")

pdf(file = "./Sam_Figures/SobolMaxEnough_AllModels.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(textMat_SobolMaxEnough_All[nrow(textMat_SobolMaxEnough_All):1, ],breaks = c("Yes","No"),
     xlab="Model run time",ylab="Number of model parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()