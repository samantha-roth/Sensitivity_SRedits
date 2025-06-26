# what approach has the best mean time for each combo?

rm(list=ls())
graphics.off()

if(dir.exists("New_Figures")==FALSE) dir.create("New_Figures")

source("0_libraryPoly.R")
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


load(paste0("./Ranking_Data/Polynomial/Summary_Time_Sobol"))
load(paste0("./Ranking_Data/Polynomial/Summary_Time_BASS"))
load(paste0("./Ranking_Data/Polynomial/Summary_Time_Kriging"))
load(paste0("./Ranking_Data/Polynomial/Summary_Time_AKMCS"))

#-------------------------------------------------------------
# Which method to choose? (Figure 7)
# Identify the fastest method for each scenario
Mat <- Mean_Time_Sobol
textMat <- matrix(NA,nrow=nrow(Mat),ncol=ncol(Mat))
for (i in 1:(length(tested_D))){
  for (j in 1:length(tested_eval_time)){
    #if(i==length(tested_D)){
    #  Mat[i,j] <- min(Mean_Time_Sobol[i,j],Mean_Time_BASS[i,j],na.rm=TRUE)
      
    #  if (Mat[i,j]==Mean_Time_Sobol[i,j]) textMat[i,j] <- "Sobol"
      
     # if (Mat[i,j]==Mean_Time_BASS[i,j]) textMat[i,j] <- "BASS"
    #}
    #else{
      Mat[i,j] <- min(Mean_Time_Sobol[i,j],Mean_Time_Kriging[i,j],
                      Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],na.rm=TRUE)
      
      if (Mat[i,j]==Mean_Time_Sobol[i,j]) textMat[i,j] <- "Sobol"
      
      if (Mat[i,j]==Mean_Time_Kriging[i,j]) textMat[i,j] <- "Kriging"
      
      if (Mat[i,j]==Mean_Time_AKMCS[i,j]) textMat[i,j] <- "AKMCS"
      
      if (Mat[i,j]==Mean_Time_BASS[i,j]) textMat[i,j] <- "BASS"
    #}
  }
}

# for(j in 1:which(eval_time_lab=="10s")){
#   Mat[length(tested_D),j]<- Mean_Time_Sobol[length(tested_D),j]
#   textMat[length(tested_D),j] <- "Sobol"
# } 

# Row names and column names of the plot
rownames(textMat) <- tested_D_num
colnames(textMat) <- eval_time_lab
# Color palette
cols<-brewer.pal(n = 4, name = "Set3")


pdf(file = "./New_Figures/FastestMeanTime.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(textMat[nrow(Mat):1, ],breaks = c("Sobol","Kriging","BASS","AKMCS"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()