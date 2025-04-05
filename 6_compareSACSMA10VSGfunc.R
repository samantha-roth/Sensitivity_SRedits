# compare the SA time statistics for Hymod to those 5D Sobol' G function in terms of percent difference
# also see if the rankings of fastest to slowest method (based on mean time) change between Hymod and Sobol's G function
rm(list=ls())
graphics.off()

if(dir.exists("New_Figures")==FALSE) dir.create("New_Figures")

source("0_librarySACSMA10par.R")
source("extra_functions.R")

# Load the required package for plotting
library(plot.matrix)
library(RColorBrewer)

# Tested dimension, method names, and evaluation time
tested_D_num <- D<- 10
tested_D <- c("10D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

#load results for Hymod
load(paste0("./Ranking_Data/SacSma10Summary_Time_Sobol"))
load(paste0("./Ranking_Data/SacSma10Summary_Time_BASS"))
load(paste0("./Ranking_Data/SacSma10Summary_Time_Kriging"))
load(paste0("./Ranking_Data/SacSma10Summary_Time_AKMCS"))

Mean_Time_Sobol_SACSMA10<- c(Mean_Time_Sobol)
Mean_Time_BASS_SACSMA10<- c(Mean_Time_BASS)
Mean_Time_AKMCS_SACSMA10<- c(Mean_Time_AKMCS)
Mean_Time_Kriging_SACSMA10<- c(Mean_Time_Kriging)

Min_Time_Sobol_SACSMA10<- c(Min_Time_Sobol)
Min_Time_BASS_SACSMA10<- c(Min_Time_BASS)
Min_Time_AKMCS_SACSMA10<- c(Min_Time_AKMCS)
Min_Time_Kriging_SACSMA10<- c(Min_Time_Kriging)

Max_Time_Sobol_SACSMA10<- c(Max_Time_Sobol)
Max_Time_BASS_SACSMA10<- c(Max_Time_BASS)
Max_Time_AKMCS_SACSMA10<- c(Max_Time_AKMCS)
Max_Time_Kriging_SACSMA10<- c(Max_Time_Kriging)

Var_Time_Sobol_SACSMA10<- c(Var_Time_Sobol)
Var_Time_BASS_SACSMA10<- c(Var_Time_BASS)
Var_Time_AKMCS_SACSMA10<- c(Var_Time_AKMCS)
Var_Time_Kriging_SACSMA10<- c(Var_Time_Kriging)

#load results for Sobol' G function
load(paste0("./Ranking_Data/Summary_Time_Sobol"))
load(paste0("./Ranking_Data/Summary_Time_BASS"))
load(paste0("./Ranking_Data/Summary_Time_Kriging"))
load(paste0("./Ranking_Data/Summary_Time_AKMCS"))

Mean_Time_Sobol_G<- Mean_Time_Sobol[2,]
Mean_Time_BASS_G<- Mean_Time_BASS[2,]
Mean_Time_AKMCS_G<- Mean_Time_AKMCS[2,]
Mean_Time_Kriging_G<- Mean_Time_Kriging[2,]

Min_Time_Sobol_G<- Min_Time_Sobol[2,]
Min_Time_BASS_G<- Min_Time_BASS[2,]
Min_Time_AKMCS_G<- Min_Time_AKMCS[2,]
Min_Time_Kriging_G<- Min_Time_Kriging[2,]

Max_Time_Sobol_G<- Max_Time_Sobol[2,]
Max_Time_BASS_G<- Max_Time_BASS[2,]
Max_Time_AKMCS_G<- Max_Time_AKMCS[2,]
Max_Time_Kriging_G<- Max_Time_Kriging[2,]

Var_Time_Sobol_G<- Var_Time_Sobol[2,]
Var_Time_BASS_G<- Var_Time_BASS[2,]
Var_Time_AKMCS_G<- Var_Time_AKMCS[2,]
Var_Time_Kriging_G<- Var_Time_Kriging[2,]

#compare ratios of mean, min, max, and var times for Hymod to Sobol' G function

#Sobol
Mean_Ratio_Sobol<- (Mean_Time_Sobol_SACSMA10-Mean_Time_Sobol_G)/Mean_Time_Sobol_G
Min_Ratio_Sobol<- (Min_Time_Sobol_SACSMA10-Min_Time_Sobol_G)/Min_Time_Sobol_G
Max_Ratio_Sobol<- (Max_Time_Sobol_SACSMA10-Max_Time_Sobol_G)/Max_Time_Sobol_G
Var_Ratio_Sobol<- (Var_Time_Sobol_SACSMA10-Var_Time_Sobol_G)/Var_Time_Sobol_G

#Kriging
Mean_Ratio_Kriging<- (Mean_Time_Kriging_SACSMA10-Mean_Time_Kriging_G)/Mean_Time_Kriging_G
Min_Ratio_Kriging<- (Min_Time_Kriging_SACSMA10-Min_Time_Kriging_G)/Min_Time_Kriging_G
Max_Ratio_Kriging<- (Max_Time_Kriging_SACSMA10-Max_Time_Kriging_G)/Max_Time_Kriging_G
Var_Ratio_Kriging<- (Var_Time_Kriging_SACSMA10-Var_Time_Kriging_G)/Var_Time_Kriging_G

#BASS
Mean_Ratio_BASS<- (Mean_Time_BASS_SACSMA10-Mean_Time_BASS_G)/Mean_Time_BASS_G
Min_Ratio_BASS<- (Min_Time_BASS_SACSMA10-Min_Time_BASS_G)/Min_Time_BASS_G
Max_Ratio_BASS<- (Max_Time_BASS_SACSMA10-Max_Time_BASS_G)/Max_Time_BASS_G
Var_Ratio_BASS<- (Var_Time_BASS_SACSMA10-Var_Time_BASS_G)/Var_Time_BASS_G

#AKMCS
Mean_Ratio_AKMCS<- (Mean_Time_AKMCS_SACSMA10-Mean_Time_AKMCS_G)/Mean_Time_AKMCS_G
Min_Ratio_AKMCS<- (Min_Time_AKMCS_SACSMA10-Min_Time_AKMCS_G)/Min_Time_AKMCS_G
Max_Ratio_AKMCS<- (Max_Time_AKMCS_SACSMA10-Max_Time_AKMCS_G)/Max_Time_AKMCS_G
Var_Ratio_AKMCS<- (Var_Time_AKMCS_SACSMA10-Var_Time_AKMCS_G)/Var_Time_AKMCS_G

################################################################################
#see if rankings change

methods<- c("Sobol","BASS","Kriging","AKMCS")

order_methods_SACSMA10<- matrix(NA,nrow= length(Mean_Time_AKMCS_SACSMA10),ncol= length(methods))
order_methods_G<- matrix(NA,nrow= length(Mean_Time_AKMCS_G),ncol= length(methods))

for(i in 1:length(Mean_Time_Sobol_SACSMA10)){
  fast_to_slow_SACSMA10<- order(c(Mean_Time_Sobol_SACSMA10[i],Mean_Time_BASS_SACSMA10[i],
                               Mean_Time_Kriging_SACSMA10[i],Mean_Time_AKMCS_SACSMA10[i]))
  order_methods_SACSMA10[i,]<- methods[fast_to_slow_SACSMA10]
  
  fast_to_slow_G<- order(c(Mean_Time_Sobol_G[i],Mean_Time_BASS_G[i],
                           Mean_Time_Kriging_G[i],Mean_Time_AKMCS_G[i]))
  order_methods_G[i,]<- methods[fast_to_slow_G]
}

order_methods_G

order_methods_SACSMA10


################################################################################
#G function

for(i in 1:length(Mean_Time_Sobol_G)){
  print(paste0("Time: ",eval_time_lab[i]))
  print(paste0("Kriging in minutes: ",Min_Time_Kriging_G[i]/60,", ",
               Mean_Time_Kriging_G[i]/60,", ",
               Max_Time_Kriging_G[i]/60))
  print(paste0("BASS in minutes: ",Min_Time_BASS_G[i]/60,", ",
               Mean_Time_BASS_G[i]/60,", ",
               Max_Time_BASS_G[i]/60))
  print(paste0("AKMCS in minutes: ",Min_Time_AKMCS_G[i]/60,", ",
               Mean_Time_AKMCS_G[i]/60,", ",
               Max_Time_AKMCS_G[i]/60))
  print(paste0("Sobol in minutes: ",Min_Time_Sobol_G[i]/60,", ",
               Mean_Time_Sobol_G[i]/60,", ",
               Max_Time_Sobol_G[i]/60))
}

#SACSMA10

for(i in 1:length(Mean_Time_Sobol_SACSMA10)){
  print(paste0("Time: ",eval_time_lab[i]))
  print(paste0("Kriging in minutes: ",Min_Time_Kriging_SACSMA10[i]/60,", ",
               Mean_Time_Kriging_SACSMA10[i]/60,", ",
               Max_Time_Kriging_SACSMA10[i]/60))
  print(paste0("BASS in minutes: ",Min_Time_BASS_SACSMA10[i]/60,", ",
               Mean_Time_BASS_SACSMA10[i]/60,", ",
               Max_Time_BASS_SACSMA10[i]/60))
  print(paste0("AKMCS in minutes: ",Min_Time_AKMCS_SACSMA10[i]/60,", ",
               Mean_Time_AKMCS_SACSMA10[i]/60,", ",
               Max_Time_AKMCS_SACSMA10[i]/60))
  print(paste0("Sobol in minutes: ",Min_Time_Sobol_SACSMA10[i]/60,", ",
               Mean_Time_Sobol_SACSMA10[i]/60,", ",
               Max_Time_Sobol_SACSMA10[i]/60))
}

#in hours
#G function

for(i in 1:length(Mean_Time_Sobol_G)){
  print(paste0("Time: ",eval_time_lab[i]))
  print(paste0("Kriging in hours: ",Min_Time_Kriging_G[i]/3600,", ",
               Mean_Time_Kriging_G[i]/3600,", ",
               Max_Time_Kriging_G[i]/3600))
  print(paste0("BASS in hours: ",Min_Time_BASS_G[i]/3600,", ",
               Mean_Time_BASS_G[i]/3600,", ",
               Max_Time_BASS_G[i]/3600))
  print(paste0("AKMCS in hours: ",Min_Time_AKMCS_G[i]/3600,", ",
               Mean_Time_AKMCS_G[i]/3600,", ",
               Max_Time_AKMCS_G[i]/3600))
  print(paste0("Sobol in hours: ",Min_Time_Sobol_G[i]/3600,", ",
               Mean_Time_Sobol_G[i]/3600,", ",
               Max_Time_Sobol_G[i]/3600))
}

#SACSMA10

for(i in 1:length(Mean_Time_Sobol_SACSMA10)){
  print(paste0("Time: ",eval_time_lab[i]))
  print(paste0("Kriging in hours: ",Min_Time_Kriging_SACSMA10[i]/3600,", ",
               Mean_Time_Kriging_SACSMA10[i]/3600,", ",
               Max_Time_Kriging_SACSMA10[i]/3600))
  print(paste0("BASS in hours: ",Min_Time_BASS_SACSMA10[i]/3600,", ",
               Mean_Time_BASS_SACSMA10[i]/3600,", ",
               Max_Time_BASS_SACSMA10[i]/3600))
  print(paste0("AKMCS in hours: ",Min_Time_AKMCS_SACSMA10[i]/3600,", ",
               Mean_Time_AKMCS_SACSMA10[i]/3600,", ",
               Max_Time_AKMCS_SACSMA10[i]/3600))
  print(paste0("Sobol in hours: ",Min_Time_Sobol_SACSMA10[i]/3600,", ",
               Mean_Time_Sobol_SACSMA10[i]/3600,", ",
               Max_Time_Sobol_SACSMA10[i]/3600))
}

#in days
#G function

for(i in 1:length(Mean_Time_Sobol_G)){
  print(paste0("Time: ",eval_time_lab[i]))
  print(paste0("Kriging in days: ",Min_Time_Kriging_G[i]/3600/24,", ",
               Mean_Time_Kriging_G[i]/3600/24,", ",
               Max_Time_Kriging_G[i]/3600/24))
  print(paste0("BASS in days: ",Min_Time_BASS_G[i]/3600/24,", ",
               Mean_Time_BASS_G[i]/3600/24,", ",
               Max_Time_BASS_G[i]/3600/24))
  print(paste0("AKMCS in days: ",Min_Time_AKMCS_G[i]/3600/24,", ",
               Mean_Time_AKMCS_G[i]/3600/24,", ",
               Max_Time_AKMCS_G[i]/3600/24))
  print(paste0("Sobol in days: ",Min_Time_Sobol_G[i]/3600/24,", ",
               Mean_Time_Sobol_G[i]/3600/24,", ",
               Max_Time_Sobol_G[i]/3600/24))
}

#SACSMA10

for(i in 1:length(Mean_Time_Sobol_SACSMA10)){
  print(paste0("Time: ",eval_time_lab[i]))
  print(paste0("Kriging in days: ",Min_Time_Kriging_SACSMA10[i]/3600/24,", ",
               Mean_Time_Kriging_SACSMA10[i]/3600/24,", ",
               Max_Time_Kriging_SACSMA10[i]/3600/24))
  print(paste0("BASS in days: ",Min_Time_BASS_SACSMA10[i]/3600/24,", ",
               Mean_Time_BASS_SACSMA10[i]/3600/24,", ",
               Max_Time_BASS_SACSMA10[i]/3600/24))
  print(paste0("AKMCS in days: ",Min_Time_AKMCS_SACSMA10[i]/3600/24,", ",
               Mean_Time_AKMCS_SACSMA10[i]/3600/24,", ",
               Max_Time_AKMCS_SACSMA10[i]/3600/24))
  print(paste0("Sobol in days: ",Min_Time_Sobol_SACSMA10[i]/3600/24,", ",
               Mean_Time_Sobol_SACSMA10[i]/3600/24,", ",
               Max_Time_Sobol_SACSMA10[i]/3600/24))
}