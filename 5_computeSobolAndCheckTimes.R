
Time_KrigingSobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCSSobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

for(i in 1:(length(D)-1)){
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
  # Kriging:
  load(paste0(folder,"/Kriging/T_KrigingSobol"))

  # AKMCS:
  load(paste0(folder,"/AKMCS/T_AKMCSSobol"))


  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_KrigingSobol[i,j] <-  sum(T_KrigingSobol)
    Time_AKMCSSobol[i,j] <- sum(T_AKMCSSobol)
  }
}

Time_KrigingCheck <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCSCheck <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

for(i in 1:(length(D)-1)){
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
  # Kriging:
  load(paste0(folder,"/Kriging/T_check_Kriging"))

  # AKMCS:
  load(paste0(folder,"/AKMCS/T_check_AKMCS"))

  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_KrigingCheck[i,j] <- sum(T_check_Kriging)
    Time_AKMCSCheck[i,j] <-  sum(T_check_AKMCS)
  }
}
