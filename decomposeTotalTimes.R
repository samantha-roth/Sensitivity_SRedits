# This script compares what parts of each method drive the computational burden

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

source("0_library.R")

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

# Total time of each method & each scenario
Time_Sobol_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Sobol_check <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Sobol_model <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

Time_Kriging_emulate <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Kriging_predict <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Kriging_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Kriging_check <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Kriging_model <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

Time_AKMCS_emulate <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCS_predict <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCS_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCS_check <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCS_model <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

Time_BASS_emulate <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_BASS_predict <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_BASS_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_BASS_check <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_BASS_model <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

# Load all related results for each test scenario
for (i in 1:(length(D)-1)) {
  folder <- paste("./Ranking_Data/",tested_D[i],sep="")
  
  # General:
  load(paste(folder,"/avg_eval_time",sep=""))
  
  # Sobol:
  load(paste0(folder,"/Sobol/T_Sobol"))
  load(paste0(folder,"/Sobol/T_check_Sobol"))
  load(paste0(folder,"/all_eval_times"))
  load(paste(folder,"/Sobol/S_Sobol",sep=""))
  Sobol_convergesize <- S$C
  
  
  # BASS:
  load(paste0(folder, "/BASS/T_BASS"))
  load(paste0(folder, "/BASS/T_pred_BASS"))
  load(paste0(folder, "/BASS/T_check_BASS"))
  load(paste0(folder,"/BASS/T_BASSSobol"))
  load(paste0(folder,"/BASS/S_BASS"))
  load(paste0(folder,"/BASS/BASS_size"))
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_Sobol_Sobol[i,j] <- sum(T_Sobol)- sum(all_eval_times)
    Time_Sobol_check[i,j] <- sum(T_check_Sobol)
    Time_Sobol_model[i,j] <- tested_eval_time[j]*Sobol_convergesize
    
    Time_BASS_emulate[i,j] <- sum(T_BASS)
    Time_BASS_predict[i,j] <- sum(T_pred_BASS)
    Time_BASS_Sobol[i,j] <- sum(T_BASSSobol)
    Time_BASS_check[i,j] <- sum(T_check_BASS)
    Time_BASS_model[i,j] <- tested_eval_time[j]*BASS_size
  }
}

for(i in 1:(length(D)-1)){
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
  # Kriging:
  load(paste0(folder,"/Kriging/T_Kriging"))
  load(paste0(folder,"/Kriging/T_pred_Kriging"))
  load(paste0(folder,"/Kriging/T_KrigingSobol"))
  load(paste0(folder,"/Kriging/T_check_Kriging"))
  load(paste0(folder,"/Kriging/Kriging_size"))
  load(paste0(folder,"/Kriging/S_Kriging"))
  Sobol_Kriging_convergesize<- S$C
  
  # AKMCS:
  load(paste0(folder,"/AKMCS/AKMCS_size"))
  load(paste0(folder,"/AKMCS/T_AKMCS"))
  load(paste0(folder,"/AKMCS/T_pred_AKMCS"))
  load(paste0(folder,"/AKMCS/T_AKMCSSobol"))
  load(paste0(folder,"/AKMCS/T_check_AKMCS"))
  load(paste0(folder,"/AKMCS/S_AKMCS"))
  load(paste0(folder,"/AKMCS/Sobol_AKMCS_convergesize"))
  Sobol_AKMCS_convergesize<- S$C
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_Kriging_emulate[i,j] <- sum(T_Kriging)
    Time_Kriging_predict[i,j] <- sum(T_pred_Kriging)
    Time_Kriging_Sobol[i,j] <- sum(T_KrigingSobol)
    Time_Kriging_check[i,j] <- sum(T_check_Kriging)
    Time_Kriging_model[i,j] <- tested_eval_time[j]*Kriging_size
    
    Time_AKMCS_emulate[i,j] <- sum(T_AKMCS)
    Time_AKMCS_predict[i,j] <- sum(T_pred_AKMCS)
    Time_AKMCS_Sobol[i,j] <- sum(T_AKMCSSobol)
    Time_AKMCS_check[i,j] <- sum(T_check_AKMCS)
    Time_AKMCS_model[i,j] <- tested_eval_time[j]*AKMCS_size
  }
}

################################################################################
#Which steps take a meaningful amount of time? 

steps<- c("emulate","predict","Sobol","check","model")

for(s in 1:length(steps)){
  print(paste0("Max time of ",steps[s]," for AKMCS: ",max(get(paste0("Time_AKMCS_",steps[s])),na.rm=TRUE)))
  print(paste0("Max time of ",steps[s]," for Kriging: ",max(get(paste0("Time_Kriging_",steps[s])),na.rm=TRUE)))
  current_BASS<- get(paste0("Time_BASS_",steps[s]))
  print(paste0("Max time of ",steps[s]," for BASS: ",max(current_BASS[1:5,],na.rm=TRUE)))
  if(s>2){
    current_Sobol<- get(paste0("Time_Sobol_",steps[s]))
    print(paste0("Max time of ",steps[s]," for Sobol: ",max(current_Sobol[1:5,],na.rm=TRUE)))
  }
}

#For input dimensions 20 or less, 
#the check step never contributes more than 10 seconds
#the model step contributes a shit ton
#the Sobol step never contributes > 5 min, max time is for BASS. max(Kriging) = about max(BASS)/3
#prediction takes <= 30 min, longest is for AKMCS. max(BASS) = about max(Kriging)/2
#max emulation time is for AKMCS, takes 97 hours. max BASS emulation = 3ish hours, max Kriging emulation is 47 hours.
#max model time is for Sobol. second most is for BASS, then Kriging, then AKMCS.
#BASS seems to require about double the model runs compared to Kriging (840 vs 320 for 20D)
################################################################################

#what approach spends the least time on emulation  