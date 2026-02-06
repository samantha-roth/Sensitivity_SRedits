rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/polynomial")

source("0_libraryPoly.R")
source("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/extra_functions.R")

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
for (i in 1:(length(tested_D))){
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
#Sobol is uniformly fastest when run time is 1ms and input dimension is between 2D and 20D
#and when run time is 10ms and input dimension is between 2D and 20D

Sobol_inds<- which(textMat_maxSobol=="Sobol")

#-------------------------------------------------------------
# Compare the max BASS time to the min of all other approaches
Mat_maxBASS <- Max_Time_BASS
textMat_maxBASS <- matrix(NA,nrow=nrow(Mat_maxBASS),ncol=ncol(Mat_maxBASS))
for (i in 1:(length(tested_D))){
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
#BASS is uniformly fastest for 10D inputs when the model run time is between 0.1s and 1min
#and for 15D inputs when the model run time is between 1s and 10min
#and for 20D inputs when the model run time is between 0.1s and 10min
#and for 30D inputs when the model run time is between 1ms and 10s

BASS_inds<- which(textMat_maxBASS=="BASS")
#-------------------------------------------------------------
# Compare the max Kriging time to the min of all other approaches
Mat_maxKriging <- Max_Time_Kriging
textMat_maxKriging <- matrix(NA,nrow=nrow(Mat_maxKriging),ncol=ncol(Mat_maxKriging))
for (i in 1:(length(tested_D))){
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
#Kriging is uniformly fastest nowhere

Kriging_inds<- which(textMat_maxKriging=="Kriging")
#-------------------------------------------------------------
# Compare the max AKMCS time to the min of all other approaches
Mat_maxAKMCS <- Max_Time_AKMCS
textMat_maxAKMCS <- matrix(NA,nrow=nrow(Mat_maxAKMCS),ncol=ncol(Mat_maxAKMCS))
for (i in 1:(length(tested_D))){
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
#AKMCS is uniformly fastest for 2D input with 0.1s to 10s model run time
#and for 10hr runtime with input dimensions of 15D to 30D

AKMCS_inds<- which(textMat_maxAKMCS=="AKMCS")

#-------------------------------------------------------------------------------
#where is there a uniform best?

textMat_uniformBest<- matrix(NA,nrow=nrow(Mat_maxSobol),ncol=ncol(Mat_maxSobol))
textMat_uniformBest[AKMCS_inds]<- "AKMCS"
textMat_uniformBest[BASS_inds]<- "BASS"
textMat_uniformBest[Sobol_inds]<- "Sobol"

save(textMat_uniformBest,file="./Ranking_Data/textMat_uniformBest")
print(textMat_uniformBest)