#get total time for each node and for each approach as a matrix

# This script makes grid plots not included in the original analysis
# Note: this script requires the full data. 

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

source("0_librarySACSMA10par.R")
source("extra_functions.R")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

# Tested dimension, method names, and evaluation time
tested_D_num <- c(10)
tested_D <- c("10D")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

# Total time of each method & each scenario
Time_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Kriging <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_BASS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

# Load all related results for each test scenario
i=1
folder <- paste0("./Ranking_Data/SacSma10")

# Sobol:
load(paste0(folder,"/Sobol/T_Sobol"))
load(paste0(folder,"/Sobol/T_check_Sobol"))
load(paste0(folder,"/Sobol/avg_eval_time"))
load(paste0(folder,"/Sobol/S_Sobol"))
Sobol_convergesize <- S$C

# BASS:
load(paste0(folder, "/BASS/T_BASS"))
load(paste0(folder, "/BASS/T_pred_BASS"))
load(paste0(folder, "/BASS/T_LHS_BASS"))
load(paste0(folder, "/BASS/T_check_BASS"))
load(paste0(folder,"/BASS/T_BASSSobol"))
load(paste0(folder,"/BASS/S_BASS"))
load(paste0(folder,"/BASS/BASS_size"))

# Kriging:
load(paste0(folder,"/Kriging/T_Kriging"))
load(paste0(folder,"/Kriging/T_pred_Kriging"))
load(paste0(folder,"/Kriging/T_LHS_Kriging"))
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

#get all the sizes tested in standard Sobol'
d<-tested_D_num[i]
idx <- closest_greater(tot_size,S$C)
N<- floor(tot_size[idx]/(d+2+d*(d-1)/2))
if(S$C==N*(d+2+d*(d-1)/2)){
  all_sizes<- size_checked(idx,d)
}else{
  print("something is wrong")
  break
}

# Calculation of the computational time in each scenario
# Sensitivity analysis time + model evaluation adjusted time + emulation time
for (j in 1:length(tested_eval_time)) {
  tot_Sobol_eval_time<-0 
  for(m in 1:length(all_sizes)){
    tot_Sobol_eval_time<- tot_Sobol_eval_time + tested_eval_time[j]*all_sizes[m]
  }
  Time_Sobol[i,j] <- sum(T_Sobol)- length(T_Sobol)*avg_eval_time + sum(T_check_Sobol) + tot_Sobol_eval_time
  Time_BASS[i,j] <- sum(T_LHS_BASS) + sum(T_BASS)+ sum(T_pred_BASS) + tested_eval_time[j]*BASS_size + sum(T_BASSSobol) + sum(T_check_BASS)
  Time_Kriging[i,j] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size + sum(T_KrigingSobol) + sum(T_check_Kriging)
  Time_AKMCS[i,j] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size + sum(T_AKMCSSobol) + sum(T_check_AKMCS)
  
}

save(Time_Sobol,file=paste0("./Ranking_Data/SacSma10/Time_Sobol_node0"))
save(Time_BASS,file=paste0("./Ranking_Data/SacSma10/Time_BASS_node0"))
save(Time_Kriging,file=paste0("./Ranking_Data/SacSma10/Time_Kriging_node0"))
save(Time_AKMCS,file=paste0("./Ranking_Data/SacSma10/Time_AKMCS_node0"))


################################################################################
#other nodes

n_nodes<- 4

for(node in 1:n_nodes){
  # Total time of each method & each scenario
  Time_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
  Time_BASS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
  Time_Kriging <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
  Time_AKMCS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
  
  # Load all related results for each test scenario
  i=1
  
  print(paste0("node= ",node))
  
  seed<- node*10
  seed_Sobol<- node*3
  
  folder <- paste0("./Ranking_Data/SacSma10")
  
  # Sobol:
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/T_Sobol"))
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/T_check_Sobol"))
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/avg_eval_time"))
  load(paste0(folder,"/Sobol/seed",seed_Sobol,"/S_Sobol"))
  Sobol_convergesize <- S$C
  
  # BASS:
  load(paste0(folder, "/BASS/seed",seed,"/T_BASS"))
  load(paste0(folder, "/BASS/seed",seed,"/T_pred_BASS"))
  load(paste0(folder, "/BASS/seed",seed,"/T_LHS_BASS"))
  load(paste0(folder, "/BASS/seed",seed,"/T_check_BASS"))
  load(paste0(folder,"/BASS/seed",seed,"/T_BASSSobol"))
  load(paste0(folder,"/BASS/seed",seed,"/S_BASS"))
  load(paste0(folder,"/BASS/seed",seed,"/BASS_size"))
  
  # Kriging:
  load(paste0(folder,"/Kriging/seed",seed,"/T_Kriging"))
  load(paste0(folder,"/Kriging/seed",seed,"/T_pred_Kriging"))
  load(paste0(folder,"/Kriging/seed",seed,"/T_LHS_Kriging"))
  load(paste0(folder,"/Kriging/seed",seed,"/T_KrigingSobol"))
  load(paste0(folder,"/Kriging/seed",seed,"/T_check_Kriging"))
  load(paste0(folder,"/Kriging/seed",seed,"/Kriging_size"))
  load(paste0(folder,"/Kriging/seed",seed,"/S_Kriging"))
  Sobol_Kriging_convergesize<- S$C
  
  # AKMCS:
  load(paste0(folder,"/AKMCS/seed",seed,"/AKMCS_size"))
  load(paste0(folder,"/AKMCS/seed",seed,"/T_AKMCS"))
  load(paste0(folder,"/AKMCS/seed",seed,"/T_pred_AKMCS"))
  load(paste0(folder,"/AKMCS/seed",seed,"/T_AKMCSSobol"))
  load(paste0(folder,"/AKMCS/seed",seed,"/T_check_AKMCS"))
  load(paste0(folder,"/AKMCS/seed",seed,"/S_AKMCS"))
  load(paste0(folder,"/AKMCS/seed",seed,"/Sobol_AKMCS_convergesize"))
  Sobol_AKMCS_convergesize<- S$C
  
  #get all the sizes tested in standard Sobol'
  d<-tested_D_num[i]
  idx <- closest_greater(tot_size,S$C)
  N<- floor(tot_size[idx]/(d+2+d*(d-1)/2))
  if(S$C==N*(d+2+d*(d-1)/2)){
    all_sizes<- size_checked(idx,d)
  }else{
    print("something is wrong")
    break
  }
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    tot_Sobol_eval_time<-0 
    for(m in 1:length(all_sizes)){
      tot_Sobol_eval_time<- tot_Sobol_eval_time + tested_eval_time[j]*all_sizes[m]
    }
    Time_Sobol[i,j] <- sum(T_Sobol)- length(T_Sobol)*avg_eval_time + sum(T_check_Sobol) + tot_Sobol_eval_time
    Time_BASS[i,j] <- sum(T_LHS_BASS) + sum(T_BASS)+ sum(T_pred_BASS) + tested_eval_time[j]*BASS_size + sum(T_BASSSobol) + sum(T_check_BASS)
    Time_Kriging[i,j] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size + sum(T_KrigingSobol) + sum(T_check_Kriging)
    Time_AKMCS[i,j] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size + sum(T_AKMCSSobol) + sum(T_check_AKMCS)
  }
  
  save(Time_Sobol,file=paste0("./Ranking_Data/SacSma10/Time_Sobol_node",node))
  save(Time_BASS,file=paste0("./Ranking_Data/SacSma10/Time_BASS_node",node))
  save(Time_Kriging,file=paste0("./Ranking_Data/SacSma10/Time_Kriging_node",node))
  save(Time_AKMCS,file=paste0("./Ranking_Data/SacSma10/Time_AKMCS_node",node))
  
}
