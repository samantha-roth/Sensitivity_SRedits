#code to generate new figure 2

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

load("./Ranking_Data/text_bestSeedMod")
text_bestSeedMod[which(is.na(text_bestSeedMod))]<- "None"

# Row names and column names of the plot
rownames(text_bestSeedMod) <- tested_D_num
colnames(text_bestSeedMod) <- eval_time_lab
# Color palette
#cols<-brewer.pal(n = 3, name = "Set3")
cols<-c("purple","orange","white")

pdf(file = "./Sam_Figures/FastestAcrossAllSeeds&Models.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(text_bestSeedMod[nrow(text_bestSeedMod):1, ],breaks = c("Sobol","AKMCS","None"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

# jpeg(file = "./Sam_Figures/FastestAcrossAllSeeds&Models.jpeg",width = 800,height = 600,type="cairo")
# #par(mar=c(5,5,2.6,6))
# plot(text_bestSeedMod[nrow(text_bestSeedMod):1, ],breaks = c("Sobol","AKMCS","None"),
#      xlab="Time of single run",ylab="Number of input parameters",col=cols,
#      cex.lab=1.5,cex.axis=1,main="")
# dev.off()
