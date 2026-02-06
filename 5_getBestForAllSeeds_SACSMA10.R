rm(list=ls())
graphics.off()

source("0_librarySACSMA10par.R")
source("extra_functions.R")

# Tested dimension, method names, and evaluation time
tested_D_num <- c(10)
tested_D <- c("10D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

folder<- paste0(folderpath,"SacSma10")

load(paste0(folder,"/Summary_Time_Sobol"))

load(paste0(folder,"/Summary_Time_BASS"))

load(paste0(folder,"/Summary_Time_Kriging"))

load(paste0(folder,"/Summary_Time_AKMCS"))

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

save(textMat_maxSobol,file=paste0(folder,"/textMat_maxSobol"))
print(textMat_maxSobol)
#Sobol is always fastest for times less than or equal to 10ms

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

save(textMat_maxBASS,file=paste0(folder,"/textMat_maxBASS"))
print(textMat_maxBASS)
#BASS is never always fastest 

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

save(textMat_maxKriging,file=paste0(folder,"/textMat_maxKriging"))
print(textMat_maxKriging)
#Kriging is never uniformly fastest

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

save(textMat_maxAKMCS,file=paste0(folder,"/textMat_maxAKMCS"))
print(textMat_maxAKMCS)
#AKMCS is uniformly fastest when model run time >= 10s

AKMCS_inds<- which(textMat_maxAKMCS=="AKMCS")

#-------------------------------------------------------------------------------
#where is there a uniform best?

textMat_uniformBest<- matrix(NA,nrow=nrow(Mat_maxSobol),ncol=ncol(Mat_maxSobol))
textMat_uniformBest[AKMCS_inds]<- "AKMCS"
textMat_uniformBest[BASS_inds]<- "BASS"
textMat_uniformBest[Kriging_inds]<- "Kriging"
textMat_uniformBest[Sobol_inds]<- "Sobol"

save(textMat_uniformBest,file=paste0(folder,"/textMat_uniformBest"))
print(textMat_uniformBest)