#get mean best across all seeds for each model
#then find for which run times and numbers of inputs 
#there's a best across all models
#get fastest on average for Sobol's G function

rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_library.R")
source("extra_functions.R")

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

#load time summaries for each approach
load(paste0("./Ranking_Data/Summary_Time_AKMCS"))
load(paste0("./Ranking_Data/Summary_Time_BASS"))
load(paste0("./Ranking_Data/Summary_Time_Kriging"))
load(paste0("./Ranking_Data/Summary_Time_Sobol"))


# Compare the mean times across all approaches
Mat_MeanBest <- Mean_Time_Sobol
textMat_MeanBest <- matrix(NA,nrow=nrow(Mat_MeanBest),ncol=ncol(Mat_MeanBest))
for (i in 1:(length(tested_D)-1)){
  for (j in 1:length(tested_eval_time)){
    
    Mat_MeanBest[i,j] <- min(Mean_Time_AKMCS[i,j],Mean_Time_BASS[i,j],
                             Mean_Time_Kriging[i,j],Mean_Time_Sobol[i,j],na.rm=TRUE)
    
    if (Mat_MeanBest[i,j]==Mean_Time_AKMCS[i,j]) textMat_MeanBest[i,j] <- "AKMCS"
    
    if (Mat_MeanBest[i,j]==Mean_Time_BASS[i,j]) textMat_MeanBest[i,j] <- "BASS"
    
    if (Mat_MeanBest[i,j]==Mean_Time_Kriging[i,j]) textMat_MeanBest[i,j] <- "Kriging"
    
    if (Mat_MeanBest[i,j]==Mean_Time_Sobol[i,j]) textMat_MeanBest[i,j] <- "Sobol"
    
  }
}

rownames(textMat_MeanBest) <- tested_D_num
colnames(textMat_MeanBest) <- eval_time_lab

save(Mat_MeanBest,file="./Ranking_Data/Mat_MeanBest")
save(textMat_MeanBest,file="./Ranking_Data/textMat_MeanBest")
print(textMat_MeanBest)


