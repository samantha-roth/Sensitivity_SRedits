#get slowest on average for Hymod

rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_libraryHymod.R")
source("extra_functions.R")

# Tested dimension, method names, and evaluation time
tested_D_num <- c(5)
tested_D <- c("5D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

folder<- paste0(folderpath,"Hymod")

load(paste0(folder,"/Summary_Time_Sobol"))
load(paste0(folder,"/Summary_Time_BASS"))
load(paste0(folder,"/Summary_Time_Kriging"))
load(paste0(folder,"/Summary_Time_AKMCS"))

# Compare the mean times across all approaches
Mat_MeanWorst <- Mean_Time_Sobol
textMat_MeanWorst <- matrix(NA,nrow=nrow(Mat_MeanWorst),ncol=ncol(Mat_MeanWorst))
for (i in 1:(length(tested_D))){
  for (j in 1:length(tested_eval_time)){
    
    Mat_MeanWorst[i,j] <- max(Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],
                             Mean_Time_Kriging[i,j],Mean_Time_Sobol[i,j],na.rm=TRUE)
    
    if (Mat_MeanWorst[i,j]==Mean_Time_AKMCS[i,j]) textMat_MeanWorst[i,j] <- "AKMCS"
    
    if (Mat_MeanWorst[i,j]==Mean_Time_BASS[i,j]) textMat_MeanWorst[i,j] <- "BASS"
    
    if (Mat_MeanWorst[i,j]==Mean_Time_Kriging[i,j]) textMat_MeanWorst[i,j] <- "Kriging"
    
    if (Mat_MeanWorst[i,j]==Mean_Time_Sobol[i,j]) textMat_MeanWorst[i,j] <- "Sobol"
    
  }
}

rownames(textMat_MeanWorst) <- tested_D_num
colnames(textMat_MeanWorst) <- eval_time_lab

save(Mat_MeanWorst,file=paste0(folder,"/Mat_MeanWorst"))
save(textMat_MeanWorst,file=paste0(folder,"/textMat_MeanWorst"))
print(textMat_MeanWorst)