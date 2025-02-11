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

# Total time of each method & each scenario
Time_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Kriging <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_BASS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

# Load all related results for each test scenario
for (i in 1:4) {
  folder <- paste("./Ranking_Data/",tested_D[i],sep="")
  
  # General:
  load(paste(folder,"/avg_eval_time",sep=""))
  
  # Sobol:
  load(paste(folder,"/Sobol/T_Sobol",sep=""))
  load(paste(folder,"/Sobol/S_Sobol",sep=""))
  Sobol_convergesize <- S$C
  
  # Kriging:
  load(paste(folder,"/Kriging/T_Kriging",sep=""))
  load(paste(folder,"/Kriging/T_KrigingSobol",sep=""))
  load(paste(folder,"/Kriging/Kriging_size",sep=""))
  
  # AKMCS:
  load(paste(folder,"/AKMCS/T_AKMCS",sep=""))
  load(paste(folder,"/AKMCS/x",sep=""))
  AKMCS_size <- dim(x)[1]
  load(paste(folder,"/AKMCS/T_AKMCSSobol",sep=""))
  
  # BASS:
  load(paste(folder,"/BASS/T_BASS",sep=""))
  load(paste(folder,"/BASS/T_BASSSobol",sep=""))
  load(paste(folder,"/BASS/BASS_size",sep=""))
  BASS_size <- sample_size
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_Sobol[i,j] <- T_Sobol + (tested_eval_time[j]-avg_eval_time)*Sobol_convergesize
    Time_Kriging[i,j] <- T_Kriging + (tested_eval_time[j]-avg_eval_time)*Kriging_size+ T_KrigingSobol
    Time_AKMCS[i,j] <- T_AKMCS + (tested_eval_time[j]-avg_eval_time)*AKMCS_size + T_AKMCSSobol
    Time_BASS[i,j] <- T_BASS + (tested_eval_time[j]-avg_eval_time)*BASS_size + T_BASSSobol
  }
}

################################################################################
#need to add emulation times together for higher dimensional models

i= 5

folder <- paste("./Ranking_Data/",tested_D[i],sep="")

# General:
load(paste(folder,"/avg_eval_time",sep=""))

# Sobol:
load(paste(folder,"/Sobol/T_Sobol",sep=""))
load(paste(folder,"/Sobol/S_Sobol",sep=""))
Sobol_convergesize <- S$C

# Kriging:
load(paste(folder,"/Kriging/T_Kriging",sep="")); T_Kriging1<- T_Kriging
load(paste(folder,"/Kriging/T_Kriging_pt2",sep="")); T_Kriging2<- T_Kriging
load(paste(folder,"/Kriging/T_KrigingSobol",sep=""))
load(paste(folder,"/Kriging/Kriging_size",sep=""))

# AKMCS:
load(paste(folder,"/AKMCS/T_AKMCS",sep="")); T_AKMCS1<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt2",sep="")); T_AKMCS2<- T_AKMCS
load(paste(folder,"/AKMCS/x",sep=""))
AKMCS_size <- dim(x)[1]
load(paste(folder,"/AKMCS/T_AKMCSSobol",sep=""))

# BASS:
load(paste(folder,"/BASS/T_BASS",sep=""))
load(paste(folder,"/BASS/T_BASSSobol",sep=""))
load(paste(folder,"/BASS/BASS_size",sep=""))
BASS_size <- sample_size

# Calculation of the computational time in each scenario
# Sensitivity analysis time + model evaluation adjusted time + emulation time
for (j in 1:length(tested_eval_time)) {
  Time_Sobol[i,j] <- T_Sobol + (tested_eval_time[j]-avg_eval_time)*Sobol_convergesize
  Time_Kriging[i,j] <- T_Kriging1 + T_Kriging2 + (tested_eval_time[j]-avg_eval_time)*Kriging_size+ T_KrigingSobol
  Time_AKMCS[i,j] <- T_AKMCS1 + T_AKMCS2 + (tested_eval_time[j]-avg_eval_time)*AKMCS_size + T_AKMCSSobol
  Time_BASS[i,j] <- T_BASS + (tested_eval_time[j]-avg_eval_time)*BASS_size + T_BASSSobol
}

################################################################################
#need to add emulation times together for higher dimensional models

i= 6

folder <- paste("./Ranking_Data/",tested_D[i],sep="")

# General:
load(paste(folder,"/avg_eval_time",sep=""))

# Sobol:
load(paste(folder,"/Sobol/T_Sobol",sep=""))
load(paste(folder,"/Sobol/S_Sobol",sep=""))
Sobol_convergesize <- S$C

# Kriging:
load(paste(folder,"/Kriging/T_Kriging",sep="")); T_Kriging1<- T_Kriging
load(paste(folder,"/Kriging/T_Kriging_pt2",sep="")); T_Kriging2<- T_Kriging
load(paste(folder,"/Kriging/T_KrigingSobol",sep=""))
load(paste(folder,"/Kriging/Kriging_size",sep=""))

# AKMCS:
load(paste(folder,"/AKMCS/T_AKMCS",sep="")); T_AKMCS1<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt2",sep="")); T_AKMCS2<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt3",sep="")); T_AKMCS3<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt4",sep="")); T_AKMCS4<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt5",sep="")); T_AKMCS5<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt6",sep="")); T_AKMCS6<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt7",sep="")); T_AKMCS7<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt8",sep="")); T_AKMCS8<- T_AKMCS
load(paste(folder,"/AKMCS/T_AKMCS_pt9",sep="")); T_AKMCS9<- T_AKMCS
load(paste(folder,"/AKMCS/x",sep=""))
AKMCS_size <- dim(x)[1]
load(paste(folder,"/AKMCS/T_AKMCSSobol",sep=""))

# BASS:
load(paste(folder,"/BASS/T_BASS",sep="")); T_BASS1<- T_BASS
load(paste(folder,"/BASS/T_BASS_pt2",sep="")); T_BASS2<- T_BASS
load(paste(folder,"/BASS/T_BASSSobol",sep=""))
load(paste(folder,"/BASS/BASS_size",sep=""))
BASS_size <- sample_size

# Calculation of the computational time in each scenario
# Sensitivity analysis time + model evaluation adjusted time + emulation time
for (j in 1:length(tested_eval_time)) {
  Time_Sobol[i,j] <- T_Sobol + (tested_eval_time[j]-avg_eval_time)*Sobol_convergesize
  Time_Kriging[i,j] <- T_Kriging1 + T_Kriging2 + (tested_eval_time[j]-avg_eval_time)*Kriging_size+ T_KrigingSobol
  #Time_AKMCS[i,j] <- T_AKMCS1 + T_AKMCS2 + T_AKMCS3 + T_AKMCS4 + T_AKMCS5 + T_AKMCS6+T_AKMCS7 + T_AKMCS8 + T_AKMCS9 + (tested_eval_time[j]-avg_eval_time)*AKMCS_size + T_AKMCSSobol
  Time_AKMCS[i,j] <- NA
  Time_BASS[i,j] <- T_BASS1 + T_BASS2 + (tested_eval_time[j]-avg_eval_time)*BASS_size + T_BASSSobol
}

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

# Color palette
cols<-brewer.pal(n = 7, name = "Set3")

pdf(file = "./New_Figures/Figure_Timescale_Sobol.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_Sobol[nrow(Time_Sobol):1, ],breaks = c("sec","min","hr","day","wk","mon","yr"),
     xlab="Time of single run",ylab="Number of input parameters",col=c("blue","turquoise","green","yellow","orange","red","brown"),
     cex.lab=1.5,cex.axis=1,main="")
dev.off()