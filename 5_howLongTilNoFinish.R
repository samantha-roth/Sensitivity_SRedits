#compute the total amount of time needed so far regardless of whether or not it finishes

#get total time for each node and for each approach as a matrix

# Note: this script requires the full data. 

# Remove all existing environment and plots
rm(list = ls())
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

n_nodes<- 4

# Total time of each method & each scenario
IncTime_Kriging <- matrix(NA, nrow = length(tested_D), ncol= n_nodes)
IncTime_AKMCS <- matrix(NA, nrow = length(tested_D), ncol= n_nodes)
IncTime_BASS <- matrix(NA, nrow = length(tested_D), ncol= n_nodes)

# Load all related results for each test scenario
for(i in 1:(length(D))){
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
  # Sobol:
  load(paste0(folder,"/Sobol/avg_eval_time"))

  # BASS:
  load(paste0(folder, "/BASS_mmESS/T_BASS")) #keep
  load(paste0(folder, "/BASS_mmESS/T_pred_BASS")) #keep
  load(paste0(folder, "/BASS_mmESS/T_LHS_BASS")) #keep
  load(paste0(folder,"/BASS_mmESS/BASS_size")) #keep
  load(paste0(folder,"/BASS_mmESS/T_model_BASS"))
  if(file.exists(paste0(folder,"/BASS_mmESS/S_BASS_list"))){
    load(paste0(folder,"/BASS_mmESS/T_BASSSobol")) #keep 
    load(paste0(folder, "/BASS_mmESS/T_check_BASS")) #keep
  }
  
  # Kriging:
  load(paste0(folder,"/Kriging/T_Kriging"))
  load(paste0(folder,"/Kriging/T_pred_Kriging"))
  load(paste0(folder,"/Kriging/T_LHS_Kriging"))
  load(paste0(folder,"/Kriging/Kriging_size"))
  if(file.exists(paste0(folder,"/Kriging/Sobol_Kriging_convergesize"))){
    load(paste0(folder,"/Kriging/T_KrigingSobol"))
    load(paste0(folder,"/Kriging/T_check_Kriging"))
  }
  
  # AKMCS:
  load(paste0(folder,"/AKMCS/AKMCS_size"))
  load(paste0(folder,"/AKMCS/T_AKMCS"))
  load(paste0(folder,"/AKMCS/T_pred_AKMCS"))
  if(file.exists(paste0(folder,"/AKMCS/Sobol_AKMCS_convergesize"))){
    load(paste0(folder,"/AKMCS/T_AKMCSSobol"))
    load(paste0(folder,"/AKMCS/T_check_AKMCS"))
  }
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
    
    if(file.exists(paste0(folder,"/BASS_mmESS/S_BASS_list"))){
      IncTime_BASS[i,1] <- sum(T_LHS_BASS) + sum(T_BASS)+ sum(T_pred_BASS) + sum(T_model_BASS) + sum(T_BASSSobol) + sum(T_check_BASS) 
      } else IncTime_BASS[i,1] <- sum(T_LHS_BASS) + sum(T_BASS)+ sum(T_pred_BASS) + avg_eval_time*BASS_size
    
    if(file.exists(paste0(folder,"/Kriging/Sobol_Kriging_convergesize"))){
      IncTime_Kriging[i,1] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + avg_eval_time*Kriging_size + sum(T_KrigingSobol) + sum(T_check_Kriging)
    } else IncTime_Kriging[i,1] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + avg_eval_time*Kriging_size
    
    if(file.exists(paste0(folder,"/AKMCS/Sobol_AKMCS_convergesize"))){
      IncTime_AKMCS[i,1] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + avg_eval_time*AKMCS_size + sum(T_AKMCSSobol) + sum(T_check_AKMCS)
    } else IncTime_AKMCS[i,1] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + avg_eval_time*AKMCS_size

}

################################################################################
#other nodes

for(node in 1:(n_nodes-1)){
  print(paste0("node= ",node))
  
  for(i in 1:(length(D))){
    print(tested_D[i])
    
    folder <- paste0("./Ranking_Data/",tested_D[i])
    
    seed<- i*node
    
    # Sobol:
    load(paste0(folder,"/Sobol/avg_eval_time"))
    
    # BASS:
    load(paste0(folder, "/BASS_mmESS/seed",seed,"/T_BASS")) #keep
    load(paste0(folder, "/BASS_mmESS/seed",seed,"/T_pred_BASS")) #keep
    load(paste0(folder, "/BASS_mmESS/seed",seed,"/T_LHS_BASS")) #keep
    load(paste0(folder,"/BASS_mmESS/seed",seed,"/BASS_size")) #keep
    load(paste0(folder,"/BASS_mmESS/seed",seed,"/T_model_BASS"))
    if(file.exists(paste0(folder,"/BASS_mmESS/seed",seed,"/S_BASS_list"))){
      load(paste0(folder,"/BASS_mmESS/seed",seed,"/T_BASSSobol")) #keep 
      load(paste0(folder, "/BASS_mmESS/seed",seed,"/T_check_BASS")) #keep
    }
    
    # Kriging:
    load(paste0(folder,"/Kriging/seed",seed,"/T_Kriging"))
    load(paste0(folder,"/Kriging/seed",seed,"/T_pred_Kriging"))
    load(paste0(folder,"/Kriging/seed",seed,"/T_LHS_Kriging"))
    load(paste0(folder,"/Kriging/seed",seed,"/Kriging_size"))
    if(file.exists(paste0(folder,"/Kriging/seed",seed,"/Sobol_Kriging_convergesize"))){
      load(paste0(folder,"/Kriging/seed",seed,"/T_KrigingSobol"))
      load(paste0(folder,"/Kriging/seed",seed,"/T_check_Kriging"))
    }
    
    
    # AKMCS:
    load(paste0(folder,"/AKMCS/seed",seed,"/AKMCS_size"))
    load(paste0(folder,"/AKMCS/seed",seed,"/T_AKMCS"))
    load(paste0(folder,"/AKMCS/seed",seed,"/T_pred_AKMCS"))
    if(file.exists(paste0(folder,"/AKMCS/seed",seed,"/Sobol_AKMCS_convergesize"))){
      load(paste0(folder,"/AKMCS/seed",seed,"/T_AKMCSSobol"))
      load(paste0(folder,"/AKMCS/seed",seed,"/T_check_AKMCS"))
    }
    
    # Calculation of the computational time in each scenario
    # Sensitivity analysis time + model evaluation adjusted time + emulation time
    
    if(file.exists(paste0(folder,"/BASS_mmESS/seed",seed,"/S_BASS_list"))){
      IncTime_BASS[i,node+1] <- sum(T_LHS_BASS) + sum(T_BASS)+ sum(T_pred_BASS) + avg_eval_time*BASS_size + sum(T_BASSSobol) + sum(T_check_BASS) 
    } else IncTime_BASS[i,node+1] <- sum(T_LHS_BASS) + sum(T_BASS)+ sum(T_pred_BASS) + avg_eval_time*BASS_size
    
    if(file.exists(paste0(folder,"/Kriging/seed",seed,"/Sobol_Kriging_convergesize"))){
      IncTime_Kriging[i,node+1] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + avg_eval_time*Kriging_size + sum(T_KrigingSobol) + sum(T_check_Kriging)
    } else IncTime_Kriging[i,node+1] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + avg_eval_time*Kriging_size
    
    if(file.exists(paste0(folder,"/AKMCS/seed",seed,"/Sobol_AKMCS_convergesize"))){
      IncTime_AKMCS[i,node+1] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + avg_eval_time*AKMCS_size + sum(T_AKMCSSobol) + sum(T_check_AKMCS)
    } else IncTime_AKMCS[i,node+1] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + avg_eval_time*AKMCS_size
    
  }
    
}

#T_AKMCS doesn't save for node=4, 30D

(IncTime_BASS[5,])/(60^2)
(IncTime_Kriging[6,])/(60^2)
(IncTime_AKMCS[6,1:4])/(60^2)
