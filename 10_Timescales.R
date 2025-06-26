# This script makes figures detailing how long standard Sobol' sensivity analysis takes
# and how long the fastest sensitivity analysis approach takes for each model type
# Note: this script requires the full data. 

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
Time_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Kriging <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_BASS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

# Load all related results for each test scenario
for (i in 1:(length(D))) {
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
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    tot_Sobol_eval_time<-0 
    for(m in 1:length(all_sizes)){
      tot_Sobol_eval_time<- tot_Sobol_eval_time + tested_eval_time[j]*all_sizes[m]
    }
    Time_Sobol[i,j] <- sum(T_Sobol)- length(T_Sobol)*avg_eval_time + sum(T_check_Sobol) + tot_Sobol_eval_time
    Time_BASS[i,j] <- sum(T_LHS_BASS) + sum(T_BASS)+ sum(T_pred_BASS) + tested_eval_time[j]*BASS_size + sum(T_BASSSobol) + sum(T_check_BASS)
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
    Time_Kriging[i,j] <- sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size + sum(T_KrigingSobol) + sum(T_check_Kriging)
    Time_AKMCS[i,j] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size + sum(T_AKMCSSobol) + sum(T_check_AKMCS)
  }
}

Time_AKMCS[length(D),]<- NA
Time_Kriging[length(D),]<- NA

################################################################################

# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

#-------------------------------------

Time_Sobol_hr<- Time_Sobol/3600
Time_Sobol_day<- Time_Sobol_hr/24
Time_Sobol_yr<- Time_Sobol_day/365

Timescale_Sobol<- matrix(NA,nrow=nrow(Time_Sobol),ncol=ncol(Time_Sobol))
for(i in 1:nrow(Time_Sobol)){
  for(j in 1:ncol(Time_Sobol)){
    if(Time_Sobol[i,j]<60) Timescale_Sobol[i,j]<- "sec"
    if(Time_Sobol[i,j]>=60 & Time_Sobol[i,j]<3600) Timescale_Sobol[i,j]<- "min"
    if(Time_Sobol_hr[i,j]>=1 & Time_Sobol_hr[i,j]<24) Timescale_Sobol[i,j]<- "hr"
    if(Time_Sobol_day[i,j]>=1 & Time_Sobol_day[i,j]<7) Timescale_Sobol[i,j]<- "day"
    if(Time_Sobol_day[i,j]>=7 & Time_Sobol_day[i,j]<28) Timescale_Sobol[i,j]<- "wk"
    if(Time_Sobol_day[i,j]>=28 & Time_Sobol_day[i,j]<365) Timescale_Sobol[i,j]<- "mon"
    if(Time_Sobol_yr[i,j]>=1 & Time_Sobol_yr[i,j]<10) Timescale_Sobol[i,j]<- "yr"
  }
}

rownames(Timescale_Sobol) <- tested_D_num
colnames(Timescale_Sobol) <- eval_time_lab

#-------------------------------------

Time_Kriging_hr<- Time_Kriging/3600
Time_Kriging_day<- Time_Kriging_hr/24
Time_Kriging_yr<- Time_Kriging_day/365

Timescale_Kriging<- matrix(NA,nrow=nrow(Time_Kriging),ncol=ncol(Time_Kriging))
for(i in 1:(nrow(Time_Kriging)-1)){
  for(j in 1:ncol(Time_Kriging)){
    if(Time_Kriging[i,j]<60) Timescale_Kriging[i,j]<- "sec"
    if(Time_Kriging[i,j]>=60 & Time_Kriging[i,j]<3600) Timescale_Kriging[i,j]<- "min"
    if(Time_Kriging_hr[i,j]>=1 & Time_Kriging_hr[i,j]<24) Timescale_Kriging[i,j]<- "hr"
    if(Time_Kriging_day[i,j]>=1 & Time_Kriging_day[i,j]<7) Timescale_Kriging[i,j]<- "day"
    if(Time_Kriging_day[i,j]>=7 & Time_Kriging_day[i,j]<28) Timescale_Kriging[i,j]<- "wk"
    if(Time_Kriging_day[i,j]>=28 & Time_Kriging_day[i,j]<365) Timescale_Kriging[i,j]<- "mon"
    if(Time_Kriging_yr[i,j]>=1 & Time_Kriging_yr[i,j]<10) Timescale_Kriging[i,j]<- "yr"
  }
}

rownames(Timescale_Kriging) <- tested_D_num
colnames(Timescale_Kriging) <- eval_time_lab
Timescale_Kriging[nrow(Timescale_Kriging),]<- "NA"
#-------------------------------------

Time_AKMCS_hr<- Time_AKMCS/3600
Time_AKMCS_day<- Time_AKMCS_hr/24
Time_AKMCS_yr<- Time_AKMCS_day/365

Timescale_AKMCS<- matrix(NA,nrow=nrow(Time_AKMCS),ncol=ncol(Time_AKMCS))
for(i in 1:(nrow(Time_AKMCS)-1)){
  for(j in 1:ncol(Time_AKMCS)){
    if(Time_AKMCS[i,j]<60) Timescale_AKMCS[i,j]<- "sec"
    if(Time_AKMCS[i,j]>=60 & Time_AKMCS[i,j]<3600) Timescale_AKMCS[i,j]<- "min"
    if(Time_AKMCS_hr[i,j]>=1 & Time_AKMCS_hr[i,j]<24) Timescale_AKMCS[i,j]<- "hr"
    if(Time_AKMCS_day[i,j]>=1 & Time_AKMCS_day[i,j]<7) Timescale_AKMCS[i,j]<- "day"
    if(Time_AKMCS_day[i,j]>=7 & Time_AKMCS_day[i,j]<28) Timescale_AKMCS[i,j]<- "wk"
    if(Time_AKMCS_day[i,j]>=28 & Time_AKMCS_day[i,j]<365) Timescale_AKMCS[i,j]<- "mon"
    if(Time_AKMCS_yr[i,j]>=1 & Time_AKMCS_yr[i,j]<10) Timescale_AKMCS[i,j]<- "yr"
  }
}

rownames(Timescale_AKMCS) <- tested_D_num
colnames(Timescale_AKMCS) <- eval_time_lab
Timescale_AKMCS[nrow(Timescale_AKMCS),]<- "NA"
#-------------------------------------

Time_BASS_hr<- Time_BASS/3600
Time_BASS_day<- Time_BASS_hr/24
Time_BASS_yr<- Time_BASS_day/365

Timescale_BASS<- matrix(NA,nrow=nrow(Time_BASS),ncol=ncol(Time_BASS))
for(i in 1:nrow(Time_BASS)){
  for(j in 1:ncol(Time_BASS)){
    if(Time_BASS[i,j]<60) Timescale_BASS[i,j]<- "sec"
    if(Time_BASS[i,j]>=60 & Time_BASS[i,j]<3600) Timescale_BASS[i,j]<- "min"
    if(Time_BASS_hr[i,j]>=1 & Time_BASS_hr[i,j]<24) Timescale_BASS[i,j]<- "hr"
    if(Time_BASS_day[i,j]>=1 & Time_BASS_day[i,j]<7) Timescale_BASS[i,j]<- "day"
    if(Time_BASS_day[i,j]>=7 & Time_BASS_day[i,j]<28) Timescale_BASS[i,j]<- "wk"
    if(Time_BASS_day[i,j]>=28 & Time_BASS_day[i,j]<365) Timescale_BASS[i,j]<- "mon"
    if(Time_BASS_yr[i,j]>=1 & Time_BASS_yr[i,j]<10) Timescale_BASS[i,j]<- "yr"
  }
}

rownames(Timescale_BASS) <- tested_D_num
colnames(Timescale_BASS) <- eval_time_lab

################################################################################

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black")
brks<-c("sec","min","hr","day","wk","mon","yr","NA")

pdf(file = "./New_Figures/Figure_Timescale_Sobol.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_Sobol[nrow(Time_Sobol):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_Kriging.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_Kriging[nrow(Time_Kriging):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_AKMCS.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_AKMCS[nrow(Time_AKMCS):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_BASS.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_BASS[nrow(Time_BASS):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()