#code to generate alternative figure 4 where there's just text
#saying which approach is least variable for each number of inputs and run time

rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

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

################################################################################
#G function results
load(paste0("./Ranking_Data/Summary_Time_Sobol"))
load(paste0("./Ranking_Data/Summary_Time_AKMCS"))
load(paste0("./Ranking_Data/Summary_Time_BASS"))
load(paste0("./Ranking_Data/Summary_Time_Kriging"))

Min_Time_AKMCS_G<- Min_Time_AKMCS; rm(Min_Time_AKMCS)
Max_Time_AKMCS_G<- Max_Time_AKMCS; rm(Max_Time_AKMCS)

Min_Time_BASS_G<- Min_Time_BASS; rm(Min_Time_BASS)
Max_Time_BASS_G<- Max_Time_BASS; rm(Max_Time_BASS)

Min_Time_Kriging_G<- Min_Time_Kriging; rm(Min_Time_Kriging)
Max_Time_Kriging_G<- Max_Time_Kriging; rm(Max_Time_Kriging)

Min_Time_Sobol_G<- Min_Time_Sobol; rm(Min_Time_Sobol)
Max_Time_Sobol_G<- Max_Time_Sobol; rm(Max_Time_Sobol)

################################################################################
#polynomial function results
load(paste0("./polynomial/Ranking_Data/Summary_Time_Sobol"))
load(paste0("./polynomial/Ranking_Data/Summary_Time_AKMCS"))
load(paste0("./polynomial/Ranking_Data/Summary_Time_BASS"))
load(paste0("./polynomial/Ranking_Data/Summary_Time_Kriging"))

Min_Time_AKMCS_poly<- Min_Time_AKMCS; rm(Min_Time_AKMCS)
Max_Time_AKMCS_poly<- Max_Time_AKMCS; rm(Max_Time_AKMCS)

Min_Time_BASS_poly<- Min_Time_BASS; rm(Min_Time_BASS)
Max_Time_BASS_poly<- Max_Time_BASS; rm(Max_Time_BASS)

Min_Time_Kriging_poly<- Min_Time_Kriging; rm(Min_Time_Kriging)
Max_Time_Kriging_poly<- Max_Time_Kriging; rm(Max_Time_Kriging)

Min_Time_Sobol_poly<- Min_Time_Sobol; rm(Min_Time_Sobol)
Max_Time_Sobol_poly<- Max_Time_Sobol; rm(Max_Time_Sobol)

################################################################################
#Hymod
folder<- paste0(folderpath,"Hymod")

load(paste0(folder,"/Summary_Time_Sobol"))
load(paste0(folder,"/Summary_Time_AKMCS"))
load(paste0(folder,"/Summary_Time_BASS"))
load(paste0(folder,"/Summary_Time_Kriging"))

Min_Time_AKMCS_Hymod<- Min_Time_AKMCS; rm(Min_Time_AKMCS)
Max_Time_AKMCS_Hymod<- Max_Time_AKMCS; rm(Max_Time_AKMCS)

Min_Time_BASS_Hymod<- Min_Time_BASS; rm(Min_Time_BASS)
Max_Time_BASS_Hymod<- Max_Time_BASS; rm(Max_Time_BASS)

Min_Time_Kriging_Hymod<- Min_Time_Kriging; rm(Min_Time_Kriging)
Max_Time_Kriging_Hymod<- Max_Time_Kriging; rm(Max_Time_Kriging)

Min_Time_Sobol_Hymod<- Min_Time_Sobol; rm(Min_Time_Sobol)
Max_Time_Sobol_Hymod<- Max_Time_Sobol; rm(Max_Time_Sobol)
################################################################################
#SACSMA10
folder<- paste0(folderpath,"SacSma10")
load(paste0(folder,"/Summary_Time_Sobol"))
load(paste0(folder,"/Summary_Time_AKMCS"))
load(paste0(folder,"/Summary_Time_BASS"))
load(paste0(folder,"/Summary_Time_Kriging"))

Min_Time_AKMCS_SACSMA10<- Min_Time_AKMCS; rm(Min_Time_AKMCS)
Max_Time_AKMCS_SACSMA10<- Max_Time_AKMCS; rm(Max_Time_AKMCS)

Min_Time_BASS_SACSMA10<- Min_Time_BASS; rm(Min_Time_BASS)
Max_Time_BASS_SACSMA10<- Max_Time_BASS; rm(Max_Time_BASS)

Min_Time_Kriging_SACSMA10<- Min_Time_Kriging; rm(Min_Time_Kriging)
Max_Time_Kriging_SACSMA10<- Max_Time_Kriging; rm(Max_Time_Kriging)

Min_Time_Sobol_SACSMA10<- Min_Time_Sobol; rm(Min_Time_Sobol)
Max_Time_Sobol_SACSMA10<- Max_Time_Sobol; rm(Max_Time_Sobol)

################################################################################
#Find how much each approach varies across all seeds and models
#for each number of inputs and each model run time

Diff_Time_AKMCS<- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
Diff_Time_BASS<- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
Diff_Time_Kriging<- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
Diff_Time_Sobol<- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))

for(i in 1:length(tested_D)){
  
  if(tested_D_num[i]==5){ 
    #consider Hymod
    for(j in 1:length(tested_eval_time)){
      Diff_Time_AKMCS[i,j]<- max(c(Max_Time_AKMCS_G[i,j],Max_Time_AKMCS_poly[i,j],Max_Time_AKMCS_Hymod[1,j]))-
        min(c(Min_Time_AKMCS_G[i,j],Min_Time_AKMCS_poly[i,j],Min_Time_AKMCS_Hymod[1,j]))
      Diff_Time_BASS[i,j]<- max(c(Max_Time_BASS_G[i,j],Max_Time_BASS_poly[i,j],Max_Time_BASS_Hymod[1,j]))-
        min(c(Min_Time_BASS_G[i,j],Min_Time_BASS_poly[i,j],Min_Time_BASS_Hymod[1,j]))
      Diff_Time_Kriging[i,j]<- max(c(Max_Time_Kriging_G[i,j],Max_Time_Kriging_poly[i,j],Max_Time_Kriging_Hymod[1,j]))-
        min(c(Min_Time_Kriging_G[i,j],Min_Time_Kriging_poly[i,j],Min_Time_Kriging_Hymod[1,j]))
      Diff_Time_Sobol[i,j]<- max(c(Max_Time_Sobol_G[i,j],Max_Time_Sobol_poly[i,j],Max_Time_Sobol_Hymod[1,j]))-
        min(c(Min_Time_Sobol_G[i,j],Min_Time_Sobol_poly[i,j],Min_Time_Sobol_Hymod[1,j]))
    }
  } else if(tested_D_num[i]==10){
    #consider SACSMA10
    for(j in 1:length(tested_eval_time)){
      Diff_Time_AKMCS[i,j]<- max(c(Max_Time_AKMCS_G[i,j],Max_Time_AKMCS_poly[i,j],Max_Time_AKMCS_SACSMA10[1,j]))-
        min(c(Min_Time_AKMCS_G[i,j],Min_Time_AKMCS_poly[i,j],Min_Time_AKMCS_SACSMA10[1,j]))
      Diff_Time_BASS[i,j]<- max(c(Max_Time_BASS_G[i,j],Max_Time_BASS_poly[i,j],Max_Time_BASS_SACSMA10[1,j]))-
        min(c(Min_Time_BASS_G[i,j],Min_Time_BASS_poly[i,j],Min_Time_BASS_SACSMA10[1,j]))
      Diff_Time_Kriging[i,j]<- max(c(Max_Time_Kriging_G[i,j],Max_Time_Kriging_poly[i,j],Max_Time_Kriging_SACSMA10[1,j]))-
        min(c(Min_Time_Kriging_G[i,j],Min_Time_Kriging_poly[i,j],Min_Time_Kriging_SACSMA10[1,j]))
      Diff_Time_Sobol[i,j]<- max(c(Max_Time_Sobol_G[i,j],Max_Time_Sobol_poly[i,j],Max_Time_Sobol_SACSMA10[1,j]))-
        min(c(Min_Time_Sobol_G[i,j],Min_Time_Sobol_poly[i,j],Min_Time_Sobol_SACSMA10[1,j]))
    }
    
  } else{
    for(j in 1:length(tested_eval_time)){
      Diff_Time_AKMCS[i,j]<- max(c(Max_Time_AKMCS_G[i,j],Max_Time_AKMCS_poly[i,j]))-
        min(c(Min_Time_AKMCS_G[i,j],Min_Time_AKMCS_poly[i,j]))
      Diff_Time_BASS[i,j]<- max(c(Max_Time_BASS_G[i,j],Max_Time_BASS_poly[i,j]))-
        min(c(Min_Time_BASS_G[i,j],Min_Time_BASS_poly[i,j]))
      Diff_Time_Kriging[i,j]<- max(c(Max_Time_Kriging_G[i,j],Max_Time_Kriging_poly[i,j]))-
        min(c(Min_Time_Kriging_G[i,j],Min_Time_Kriging_poly[i,j]))
      Diff_Time_Sobol[i,j]<- max(c(Max_Time_Sobol_G[i,j],Max_Time_Sobol_poly[i,j]))-
        min(c(Min_Time_Sobol_G[i,j],Min_Time_Sobol_poly[i,j]))
    }
  }
}

# Which has the greatest range in times for each number of inputs and model run time?
Mat_SmallestRange <- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
textMat_SmallestRange <- matrix(NA,nrow=length(tested_D),ncol=length(tested_eval_time))
for (i in 1:(length(tested_D)-1)){
  for (j in 1:length(tested_eval_time)){
    
    Mat_SmallestRange[i,j] <- min(Diff_Time_AKMCS[i,j],Diff_Time_BASS[i,j],
                                 Diff_Time_Kriging[i,j],Diff_Time_Sobol[i,j],na.rm=TRUE)
    
    if (Mat_SmallestRange[i,j]==Diff_Time_AKMCS[i,j]) textMat_SmallestRange[i,j] <- "AKMCS"
    
    if (Mat_SmallestRange[i,j]==Diff_Time_BASS[i,j]) textMat_SmallestRange[i,j] <- "BASS"
    
    if (Mat_SmallestRange[i,j]==Diff_Time_Kriging[i,j]) textMat_SmallestRange[i,j] <- "Kriging"
    
    if (Mat_SmallestRange[i,j]==Diff_Time_Sobol[i,j]) textMat_SmallestRange[i,j] <- "Sobol"
    
  }
}

rownames(textMat_SmallestRange) <- tested_D_num
colnames(textMat_SmallestRange) <- eval_time_lab

print(textMat_SmallestRange)

save(Mat_SmallestRange,file="./Ranking_Data/Mat_SmallestRange")
save(textMat_SmallestRange,file="./Ranking_Data/textMat_SmallestRange")