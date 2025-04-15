#Compare variability in SA times across different seeds for each approach

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

load("./Ranking_Data/Summary_Time_Kriging")
load("./Ranking_Data/Summary_Time_Sobol")
load("./Ranking_Data/Summary_Time_AKMCS")
load("./Ranking_Data/Summary_Time_BASS")

Var_Time_Mean<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))
AKMCS_Var_to_Mean_Var<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))
BASS_Var_to_Mean_Var<- matrix(NA,nrow=nrow(Var_Time_BASS),ncol=ncol(Var_Time_BASS))
Kriging_Var_to_Mean_Var<- matrix(NA,nrow=nrow(Var_Time_Kriging),ncol=ncol(Var_Time_Kriging))
Sobol_Var_to_Mean_Var<- matrix(NA,nrow=nrow(Var_Time_Sobol),ncol=ncol(Var_Time_Sobol))

for(i in 1:(length(tested_D)-1)){
  for(j in 1:length(eval_time_lab)){
    print(tested_D[i])
    print(eval_time_lab[j])
    
    Var_Time_Mean[i,j]<- mean(c(Var_Time_AKMCS[i,j],Var_Time_BASS[i,j],Var_Time_Kriging[i,j],Var_Time_Sobol[i,j]))
    
    AKMCS_Var_to_Mean_Var[i,j]<- 100*(Var_Time_AKMCS[i,j]-Var_Time_Mean[i,j])/Var_Time_Mean[i,j]
    BASS_Var_to_Mean_Var[i,j]<-  100*(Var_Time_BASS[i,j]-Var_Time_Mean[i,j])/Var_Time_Mean[i,j]
    Kriging_Var_to_Mean_Var[i,j]<-  100*(Var_Time_Kriging[i,j]-Var_Time_Mean[i,j])/Var_Time_Mean[i,j]
    Sobol_Var_to_Mean_Var[i,j]<-  100*(Var_Time_Sobol[i,j]-Var_Time_Mean[i,j])/Var_Time_Mean[i,j]
    
    print(paste0("AKMCS pct diff from mean var: ", 100*(Var_Time_AKMCS[i,j]-Var_Time_Mean[i,j])/Var_Time_Mean[i,j] ))
    print(paste0("BASS pct diff from mean var: ", 100*(Var_Time_BASS[i,j]-Var_Time_Mean[i,j])/Var_Time_Mean[i,j] ))
    print(paste0("Kriging pct diff from mean var: ", 100*(Var_Time_Kriging[i,j]-Var_Time_Mean[i,j])/Var_Time_Mean[i,j] ))
    print(paste0("Sobol pct diff from mean var: ", 100*(Var_Time_Sobol[i,j]-Var_Time_Mean[i,j])/Var_Time_Mean[i,j] ))

  }
}

#AKMCS has much lower variability in time needed compared to the average 
#except when model run time is fast and model dimension is high (>=15)

#BASS has much lower variability in time needed compared to the average 
#when model both run time is fast (<=1min) and model dimension is high (>=15)
#and when both run time is slower (>=1min) and model dimension is lower (<=15)

#Kriging only has greater variability in time than the average when the model dimension is 2

#Sobol has much lower variability in time than average 
#except for when both model dimension is intermediate (5-15 parameters) 
#and model run time is slow (>=1min)
#also for 10-15 parameters and 10s model run time

AKMCS_Range_to_Mean<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))
BASS_Range_to_Mean<- matrix(NA,nrow=nrow(Var_Time_BASS),ncol=ncol(Var_Time_BASS))
Kriging_Range_to_Mean<- matrix(NA,nrow=nrow(Var_Time_Kriging),ncol=ncol(Var_Time_Kriging))
Sobol_Range_to_Mean<- matrix(NA,nrow=nrow(Var_Time_Sobol),ncol=ncol(Var_Time_Sobol))

for(i in 1:(length(tested_D)-1)){
  for(j in 1:length(eval_time_lab)){
    print(tested_D[i])
    print(eval_time_lab[j])
    
    Var_Time_Mean[i,j]<- mean(c(Var_Time_AKMCS[i,j],Var_Time_BASS[i,j],Var_Time_Kriging[i,j],Var_Time_Sobol[i,j]))
    
    AKMCS_Range_to_Mean[i,j]<- (Max_Time_AKMCS[i,j]-Min_Time_AKMCS[i,j])/Mean_Time_AKMCS[i,j]
    BASS_Range_to_Mean[i,j]<-  (Max_Time_BASS[i,j]-Min_Time_BASS[i,j])/Mean_Time_BASS[i,j]
    Kriging_Range_to_Mean[i,j]<-  (Max_Time_Kriging[i,j]-Min_Time_Kriging[i,j])/Mean_Time_Kriging[i,j]
    Sobol_Range_to_Mean[i,j]<-  (Max_Time_Sobol[i,j]-Min_Time_Sobol[i,j])/Mean_Time_Sobol[i,j]
  
    
  }
}

AKMCS_Range<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))
BASS_Range<- matrix(NA,nrow=nrow(Var_Time_BASS),ncol=ncol(Var_Time_BASS))
Kriging_Range<- matrix(NA,nrow=nrow(Var_Time_Kriging),ncol=ncol(Var_Time_Kriging))
Sobol_Range<- matrix(NA,nrow=nrow(Var_Time_Sobol),ncol=ncol(Var_Time_Sobol))

methods<- c("AKMCS","BASS","Kriging","Sobol")

Min_Range_Method<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))
Max_Range_Method<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))

Mean_Range<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))
Min_Range<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))
Max_Range<- matrix(NA,nrow=nrow(Var_Time_AKMCS),ncol=ncol(Var_Time_AKMCS))

for(i in 1:(length(tested_D)-1)){
  for(j in 1:length(eval_time_lab)){
    print(tested_D[i])
    print(eval_time_lab[j])
    
    Var_Time_Mean[i,j]<- mean(c(Var_Time_AKMCS[i,j],Var_Time_BASS[i,j],Var_Time_Kriging[i,j],Var_Time_Sobol[i,j]))
    
    AKMCS_Range[i,j]<- (Max_Time_AKMCS[i,j]-Min_Time_AKMCS[i,j])
    BASS_Range[i,j]<-  (Max_Time_BASS[i,j]-Min_Time_BASS[i,j])
    Kriging_Range[i,j]<-  (Max_Time_Kriging[i,j]-Min_Time_Kriging[i,j])
    Sobol_Range[i,j]<-  (Max_Time_Sobol[i,j]-Min_Time_Sobol[i,j])
    
    range.ord<- order(c(AKMCS_Range[i,j],BASS_Range[i,j],Kriging_Range[i,j],Sobol_Range[i,j]))
    Min_Range_Method[i,j]<- methods[range.ord][1]
    Max_Range_Method[i,j]<- methods[range.ord][4]
    Mean_Range[i,j]<- mean(c(AKMCS_Range[i,j],BASS_Range[i,j],Kriging_Range[i,j],Sobol_Range[i,j]))
    Min_Range[i,j]<- min(c(AKMCS_Range[i,j],BASS_Range[i,j],Kriging_Range[i,j],Sobol_Range[i,j]))
    Max_Range[i,j]<- max(c(AKMCS_Range[i,j],BASS_Range[i,j],Kriging_Range[i,j],Sobol_Range[i,j]))
  }
}
save(Mean_Range,file="./Ranking_Data/Mean_Range")
save(Min_Range,file="./Ranking_Data/Min_Range")
save(Max_Range,file="./Ranking_Data/Max_Range")

save(Min_Range_Method,file="./Ranking_Data/Min_Range_Method")
save(Max_Range_Method,file="./Ranking_Data/Max_Range_Method")

#BASS has the widest range in times for models with both times of <=1s
#and input dimensions of 10 or less. Also for models with run times of 10s
#and input dimensions of 5 to 10. Also for models with run times of 10 min to 10 hr
#and input dimension of 20.

#Kriging has the widest range in times for models with both times of 10s to 10hr and
#and input dimension of 2.

#Sobol has the widest range in times for models with both times of 1min to 10hr and
#and input dimensions of 5 to 15.

#AKMCS has the widest range in times for models with both times of 1ms to 10s and
#and input dimensions of 15 to 20. Also for models with run times of 1min
#and input dimension of 20.

