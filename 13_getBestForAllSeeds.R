
rm(list=ls())
graphics.off()

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


load(paste0("./Ranking_Data/Summary_Time_Sobol"))

load(paste0("./Ranking_Data/Summary_Time_BASS"))

load(paste0("./Ranking_Data/Summary_Time_Kriging"))

load(paste0("./Ranking_Data/Summary_Time_AKMCS"))

#is there any combo of model run time and model dimension 
#for which Sobol is always fastest across all seeds?


#-------------------------------------------------------------
# Compare the max Sobol time to the min of all other approaches
Mat_maxSobol <- Max_Time_Sobol
textMat_maxSobol <- matrix(NA,nrow=nrow(Mat_maxSobol),ncol=ncol(Mat_maxSobol))
for (i in 1:(length(tested_D)-1)){
  for (j in 1:length(tested_eval_time)){

      Mat_maxSobol[i,j] <- min(Max_Time_Sobol[i,j],Min_Time_Kriging[i,j],
                      Min_Time_AKMCS[i,j],Min_Time_BASS[i,j],na.rm=TRUE)
      
      if (Mat_maxSobol[i,j]==Max_Time_Sobol[i,j]) textMat_maxSobol[i,j] <- "Sobol"
      
      if (Mat_maxSobol[i,j]==Min_Time_Kriging[i,j]) textMat_maxSobol[i,j] <- "Kriging"
      
      if (Mat_maxSobol[i,j]==Min_Time_AKMCS[i,j]) textMat_maxSobol[i,j] <- "AKMCS"
      
      if (Mat_maxSobol[i,j]==Min_Time_BASS[i,j]) textMat_maxSobol[i,j] <- "BASS"

  }
}

rownames(textMat_maxSobol) <- tested_D_num
colnames(textMat_maxSobol) <- eval_time_lab

save(textMat_maxSobol,file="./Ranking_Data/textMat_maxSobol")
print(textMat_maxSobol)
#Sobol is always fastest for fast and faster high dimensional models

#-------------------------------------------------------------
# Compare the max BASS time to the min of all other approaches
Mat_maxBASS <- Max_Time_BASS
textMat_maxBASS <- matrix(NA,nrow=nrow(Mat_maxBASS),ncol=ncol(Mat_maxBASS))
for (i in 1:(length(tested_D)-1)){
  for (j in 1:length(tested_eval_time)){
    
    Mat_maxBASS[i,j] <- min(Max_Time_BASS[i,j],Min_Time_Kriging[i,j],
                             Min_Time_AKMCS[i,j],Min_Time_Sobol[i,j],na.rm=TRUE)
    
    if (Mat_maxBASS[i,j]==Max_Time_BASS[i,j]) textMat_maxBASS[i,j] <- "BASS"
    
    if (Mat_maxBASS[i,j]==Min_Time_Kriging[i,j]) textMat_maxBASS[i,j] <- "Kriging"
    
    if (Mat_maxBASS[i,j]==Min_Time_AKMCS[i,j]) textMat_maxBASS[i,j] <- "AKMCS"
    
    if (Mat_maxBASS[i,j]==Min_Time_Sobol[i,j]) textMat_maxBASS[i,j] <- "Sobol"
    
  }
}

rownames(textMat_maxBASS) <- tested_D_num
colnames(textMat_maxBASS) <- eval_time_lab

save(textMat_maxBASS,file="./Ranking_Data/textMat_maxBASS")
print(textMat_maxBASS)
#BASS is never always fastest across all seeds considering up to 20D


#-------------------------------------------------------------
# Compare the max Kriging time to the min of all other approaches
Mat_maxKriging <- Max_Time_Kriging
textMat_maxKriging <- matrix(NA,nrow=nrow(Mat_maxKriging),ncol=ncol(Mat_maxKriging))
for (i in 1:(length(tested_D)-1)){
  for (j in 1:length(tested_eval_time)){
    
    Mat_maxKriging[i,j] <- min(Max_Time_Kriging[i,j],Min_Time_BASS[i,j],
                            Min_Time_AKMCS[i,j],Min_Time_Sobol[i,j],na.rm=TRUE)
    
    if (Mat_maxKriging[i,j]==Max_Time_Kriging[i,j]) textMat_maxKriging[i,j] <- "Kriging"
    
    if (Mat_maxKriging[i,j]==Min_Time_BASS[i,j]) textMat_maxKriging[i,j] <- "BASS"
    
    if (Mat_maxKriging[i,j]==Min_Time_AKMCS[i,j]) textMat_maxKriging[i,j] <- "AKMCS"
    
    if (Mat_maxKriging[i,j]==Min_Time_Sobol[i,j]) textMat_maxKriging[i,j] <- "Sobol"
    
  }
}

rownames(textMat_maxKriging) <- tested_D_num
colnames(textMat_maxKriging) <- eval_time_lab

save(textMat_maxKriging,file="./Ranking_Data/textMat_maxKriging")
print(textMat_maxKriging)
#Kriging is only fastest for a 1 min run time and 10D input dimension 
#across all seeds considering up to 20D

#-------------------------------------------------------------
# Compare the max AKMCS time to the min of all other approaches
Mat_maxAKMCS <- Max_Time_AKMCS
textMat_maxAKMCS <- matrix(NA,nrow=nrow(Mat_maxAKMCS),ncol=ncol(Mat_maxAKMCS))
for (i in 1:(length(tested_D)-1)){
  for (j in 1:length(tested_eval_time)){
    
    Mat_maxAKMCS[i,j] <- min(Max_Time_AKMCS[i,j],Min_Time_BASS[i,j],
                               Min_Time_Kriging[i,j],Min_Time_Sobol[i,j],na.rm=TRUE)
    
    if (Mat_maxAKMCS[i,j]==Max_Time_AKMCS[i,j]) textMat_maxAKMCS[i,j] <- "AKMCS"
    
    if (Mat_maxAKMCS[i,j]==Min_Time_BASS[i,j]) textMat_maxAKMCS[i,j] <- "BASS"
    
    if (Mat_maxAKMCS[i,j]==Min_Time_Kriging[i,j]) textMat_maxAKMCS[i,j] <- "Kriging"
    
    if (Mat_maxAKMCS[i,j]==Min_Time_Sobol[i,j]) textMat_maxAKMCS[i,j] <- "Sobol"
    
  }
}

rownames(textMat_maxAKMCS) <- tested_D_num
colnames(textMat_maxAKMCS) <- eval_time_lab

save(textMat_maxAKMCS,file="./Ranking_Data/textMat_maxAKMCS")
print(textMat_maxAKMCS)
#AKMCS is fastest for 2D input with 0.1s to 1min model run time
#and for 5D input with 10 min to 10 hr model run time
#and for 10D input with 10 hr to 10 hr model run time
#and for 15D and 20D inputs with 10 hr model run time
#not considering 30D because still waiting
