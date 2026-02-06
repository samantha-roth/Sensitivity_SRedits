#code to generate new figure 5 for Sobol's G function

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

load("./Ranking_Data/textMat_uniformBest")
