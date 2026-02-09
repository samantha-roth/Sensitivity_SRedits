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

#load matrix saying which is the fastest on average for all models
load("./Ranking_Data/text_meanBestAllMod")
text_meanBestAllMod[which(is.na(text_meanBestAllMod))]<- "None"

# Row names and column names of the plot
rownames(text_meanBestAllMod) <- tested_D_num
colnames(text_meanBestAllMod) <- eval_time_lab

text_recommendations<- text_meanBestAllMod

#load where Sobol is fast enough relative to other approaches
load("./Ranking_Data/textMat_SobolMaxEnough_All")

text_recommendations[which(textMat_SobolMaxEnough_All=="Yes")]<- "Sobol"

text_recommendations[5,8:9]<- "None" #AKMCS isn't accurate enough here
text_recommendations[4,4]<- "None" #I don't trust this one-off Sobol


text_recommend<- text_recommendations
text_recommend[text_recommendations=="Sobol"]<- "Standard"
# text_recommend[text_recommendations=="AKMCS"]<- "Kriging and Adaptive Sampling"
text_recommend[text_recommendations=="None"]<- "Varies"
# Color palette
#cols<-brewer.pal(n = 3, name = "Set3")
cols<-c("white","orange","purple")

pdf(file = "./Sam_Figures/GraphicalAbstract_Recommendations.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(text_recommend[nrow(text_recommend):1, ],breaks = c("Varies","AKMCS","Standard"),
     xlab="Model run time",ylab="Number of model parameters",col=cols,
     main="Which Sobol' sensitivity analysis approach do we recommend?",
     cex.main=1.5,cex.lab=1.5,cex.axis=1)
dev.off()