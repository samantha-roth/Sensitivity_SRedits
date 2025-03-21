# This script makes grid plots not included in the original analysis
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

# Total time of each method & each scenario
Time_Sobol <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_Kriging <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_AKMCS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))
Time_BASS <- matrix(NA,nrow = length(tested_D),ncol = length(tested_eval_time))

# Load all related results for each test scenario
for (i in 1:(length(D)-1)) {
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
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
  }
}

save(Time_Sobol,file=paste0("./Ranking_Data/Time_Sobol_node0"))
save(Time_BASS,file=paste0("./Ranking_Data/Time_BASS_node0"))

for(i in 1:(length(D)-1)){
  folder <- paste0("./Ranking_Data/",tested_D[i])
  
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
  
  # Calculation of the computational time in each scenario
  # Sensitivity analysis time + model evaluation adjusted time + emulation time
  for (j in 1:length(tested_eval_time)) {
    Time_Kriging[i,j] <- sum(T_LHS_Kriging) + sum(T_Kriging) + sum(T_pred_Kriging) + tested_eval_time[j]*Kriging_size + sum(T_KrigingSobol) + sum(T_check_Kriging)
    Time_AKMCS[i,j] <- sum(T_AKMCS) + sum(T_pred_AKMCS) + tested_eval_time[j]*AKMCS_size + sum(T_AKMCSSobol) + sum(T_check_AKMCS)
  }
}

save(Time_Kriging,file=paste0("./Ranking_Data/Time_Kriging_node0"))
save(Time_AKMCS,file=paste0("./Ranking_Data/Time_AKMCS_node0"))

Time_AKMCS[length(D),]<- NA
Time_Kriging[length(D),]<- NA

################################################################################

#-------------------------------------------------------------
# Which method to choose? (Figure 7)
# Identify the fastest method for each scenario
Mat <- Time_Sobol
textMat <- matrix(NA,nrow=nrow(Mat),ncol=ncol(Mat))
for (i in 1:(length(tested_D))){
  for (j in 1:length(tested_eval_time)){
    if(i==length(tested_D)){
      Mat[i,j] <- min(Time_Sobol[i,j],Time_BASS[i,j],na.rm=TRUE)
      
      if (Mat[i,j]==Time_Sobol[i,j]) textMat[i,j] <- "Sobol"

      if (Mat[i,j]==Time_BASS[i,j]) textMat[i,j] <- "BASS"
    }
    else{
      Mat[i,j] <- min(Time_Sobol[i,j],Time_Kriging[i,j],
                      Time_AKMCS[i,j],Time_BASS[i,j],na.rm=TRUE)
      
      if (Mat[i,j]==Time_Sobol[i,j]) textMat[i,j] <- "Sobol"
     
      if (Mat[i,j]==Time_Kriging[i,j]) textMat[i,j] <- "Kriging"
      
      if (Mat[i,j]==Time_AKMCS[i,j]) textMat[i,j] <- "AKMCS"
      
      if (Mat[i,j]==Time_BASS[i,j]) textMat[i,j] <- "BASS"
    }
  }
}
# Row names and column names of the plot
rownames(textMat) <- tested_D_num
colnames(textMat) <- eval_time_lab
# Color palette
cols<-brewer.pal(n = 4, name = "Set3")


pdf(file = "./New_Figures/Figure_7.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(textMat[nrow(Mat):1, ],breaks = c("Sobol","Kriging","BASS","AKMCS"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

################################################################################
#but what's the time scale for the fastest method?

Time_Fastest <- matrix(NA,nrow=nrow(Mat),ncol=ncol(Mat))
for (i in 1:(length(tested_D))){
  for (j in 1:length(tested_eval_time)){
    if (textMat[i,j] == "Sobol") Time_Fastest[i,j]<- Time_Sobol[i,j]
    
    if (textMat[i,j] == "Kriging") Time_Fastest[i,j]<- Time_Kriging[i,j]
    
    if (textMat[i,j] == "AKMCS") Time_Fastest[i,j]<- Time_AKMCS[i,j]
    
    if (textMat[i,j] == "BASS") Time_Fastest[i,j]<- Time_BASS[i,j]
  }
}

#-------------------------------------

Time_Fastest_hr<- Time_Fastest/3600
Time_Fastest_day<- Time_Fastest_hr/24
Time_Fastest_yr<- Time_Fastest_day/365

Timescale_Fastest<- matrix(NA,nrow=nrow(Time_Fastest),ncol=ncol(Time_Fastest))
for(i in 1:nrow(Time_Fastest)){
  for(j in 1:ncol(Time_Fastest)){
    if(Time_Fastest[i,j]<60) Timescale_Fastest[i,j]<- "sec"
    if(Time_Fastest[i,j]>=60 & Time_Fastest[i,j]<3600) Timescale_Fastest[i,j]<- "min"
    if(Time_Fastest_hr[i,j]>=1 & Time_Fastest_hr[i,j]<24) Timescale_Fastest[i,j]<- "hr"
    if(Time_Fastest_day[i,j]>=1 & Time_Fastest_day[i,j]<7) Timescale_Fastest[i,j]<- "day"
    if(Time_Fastest_day[i,j]>=7 & Time_Fastest_day[i,j]<28) Timescale_Fastest[i,j]<- "wk"
    if(Time_Fastest_day[i,j]>=28 & Time_Fastest_day[i,j]<365) Timescale_Fastest[i,j]<- "mon"
    if(Time_Fastest_yr[i,j]>=1 & Time_Fastest_yr[i,j]<10) Timescale_Fastest[i,j]<- "yr"
  }
}

rownames(Timescale_Fastest) <- tested_D_num
colnames(Timescale_Fastest) <- eval_time_lab

# Color palette
cols<-brewer.pal(n = 7, name = "Set3")

pdf(file = "./New_Figures/Figure_Timescale_Fastest.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_Fastest[nrow(Time_Fastest):1, ],breaks = c("sec","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=c("blue","turquoise","green","yellow","orange","red","brown","black"),
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

################################################################################
#my version of the supplemental figures

Time_SobolminusKriging <- Time_Sobol-Time_Kriging
Time_SobolminusAKMCS <- Time_Sobol-Time_AKMCS
Time_SobolminusBASS <- Time_Sobol-Time_BASS

#nothing is on the -yr, -mon, -wk scale
#almost nothing on the second scale

Time_KrigingminusBASS <- Time_Kriging-Time_BASS
Time_AKMCSminusBASS <- Time_AKMCS-Time_BASS
Time_AKMCSminusKriging <- Time_AKMCS-Time_Kriging

################################################################################
#how much time does Kriging save?

Time_SobolminusKriging_hr<- Time_SobolminusKriging/3600
Time_SobolminusKriging_day<- Time_SobolminusKriging_hr/24
Time_SobolminusKriging_yr<- Time_SobolminusKriging_day/365

Timescale_SobolminusKriging<- matrix(NA,nrow=nrow(Time_SobolminusKriging),ncol=ncol(Time_SobolminusKriging))
for(i in 1:(nrow(Time_SobolminusKriging)-1)){
  for(j in 1:ncol(Time_SobolminusKriging)){
    if(Time_SobolminusKriging[i,j]<0 & Time_SobolminusKriging[i,j]>-3600) Timescale_SobolminusKriging[i,j]<- "-min"
    if(Time_SobolminusKriging_hr[i,j]<=-1 & Time_SobolminusKriging_hr[i,j]>-24) Timescale_SobolminusKriging[i,j]<- "-hr"
    if(Time_SobolminusKriging_day[i,j]<=-1 & Time_SobolminusKriging_day[i,j]>-7) Timescale_SobolminusKriging[i,j]<- "-day"
    if(Time_SobolminusKriging_day[i,j]<=-7 & Time_SobolminusKriging_day[i,j]>-28) Timescale_SobolminusKriging[i,j]<- "-wk"
    if(Time_SobolminusKriging_day[i,j]<=-28 & Time_SobolminusKriging_day[i,j]>-365) Timescale_SobolminusKriging[i,j]<- "-mon"
    if(Time_SobolminusKriging_yr[i,j]<=-1 & Time_SobolminusKriging_yr[i,j]>-10) Timescale_SobolminusKriging[i,j]<- "-yr"
    if(Time_SobolminusKriging[i,j]>=0 & Time_SobolminusKriging[i,j]<3600) Timescale_SobolminusKriging[i,j]<- "min"
    if(Time_SobolminusKriging_hr[i,j]>=1 & Time_SobolminusKriging_hr[i,j]<24) Timescale_SobolminusKriging[i,j]<- "hr"
    if(Time_SobolminusKriging_day[i,j]>=1 & Time_SobolminusKriging_day[i,j]<7) Timescale_SobolminusKriging[i,j]<- "day"
    if(Time_SobolminusKriging_day[i,j]>=7 & Time_SobolminusKriging_day[i,j]<28) Timescale_SobolminusKriging[i,j]<- "wk"
    if(Time_SobolminusKriging_day[i,j]>=28 & Time_SobolminusKriging_day[i,j]<365) Timescale_SobolminusKriging[i,j]<- "mon"
    if(Time_SobolminusKriging_yr[i,j]>=1 & Time_SobolminusKriging_yr[i,j]<10) Timescale_SobolminusKriging[i,j]<- "yr"
  }
}

rownames(Timescale_SobolminusKriging) <- tested_D_num
colnames(Timescale_SobolminusKriging) <- eval_time_lab
Timescale_SobolminusKriging[nrow(Time_SobolminusKriging),]<- "NA"

#only one square is on the second scale
#nothing is -yr, -mon, -wk

################################################################################

Time_SobolminusAKMCS_hr<- Time_SobolminusAKMCS/3600
Time_SobolminusAKMCS_day<- Time_SobolminusAKMCS_hr/24
Time_SobolminusAKMCS_yr<- Time_SobolminusAKMCS_day/365

Timescale_SobolminusAKMCS<- matrix(NA,nrow=nrow(Time_SobolminusAKMCS),ncol=ncol(Time_SobolminusAKMCS))
for(i in 1:(nrow(Time_SobolminusAKMCS)-1)){
  for(j in 1:ncol(Time_SobolminusAKMCS)){
    if(Time_SobolminusAKMCS[i,j]<0 & Time_SobolminusAKMCS[i,j]>-3600) Timescale_SobolminusAKMCS[i,j]<- "-min"
    if(Time_SobolminusAKMCS_hr[i,j]<=-1 & Time_SobolminusAKMCS_hr[i,j]>-24) Timescale_SobolminusAKMCS[i,j]<- "-hr"
    if(Time_SobolminusAKMCS_day[i,j]<=-1 & Time_SobolminusAKMCS_day[i,j]>-7) Timescale_SobolminusAKMCS[i,j]<- "-day"
    if(Time_SobolminusAKMCS_day[i,j]<=-7 & Time_SobolminusAKMCS_day[i,j]>-28) Timescale_SobolminusAKMCS[i,j]<- "-wk"
    if(Time_SobolminusAKMCS_day[i,j]<=-28 & Time_SobolminusAKMCS_day[i,j]>-365) Timescale_SobolminusAKMCS[i,j]<- "-mon"
    if(Time_SobolminusAKMCS_yr[i,j]<=-1 & Time_SobolminusAKMCS_yr[i,j]>-10) Timescale_SobolminusAKMCS[i,j]<- "-yr"
    if(Time_SobolminusAKMCS[i,j]>=0 & Time_SobolminusAKMCS[i,j]<3600) Timescale_SobolminusAKMCS[i,j]<- "min"
    if(Time_SobolminusAKMCS_hr[i,j]>=1 & Time_SobolminusAKMCS_hr[i,j]<24) Timescale_SobolminusAKMCS[i,j]<- "hr"
    if(Time_SobolminusAKMCS_day[i,j]>=1 & Time_SobolminusAKMCS_day[i,j]<7) Timescale_SobolminusAKMCS[i,j]<- "day"
    if(Time_SobolminusAKMCS_day[i,j]>=7 & Time_SobolminusAKMCS_day[i,j]<28) Timescale_SobolminusAKMCS[i,j]<- "wk"
    if(Time_SobolminusAKMCS_day[i,j]>=28 & Time_SobolminusAKMCS_day[i,j]<365) Timescale_SobolminusAKMCS[i,j]<- "mon"
    if(Time_SobolminusAKMCS_yr[i,j]>=1 & Time_SobolminusAKMCS_yr[i,j]<10) Timescale_SobolminusAKMCS[i,j]<- "yr"
  }
}

rownames(Timescale_SobolminusAKMCS) <- tested_D_num
colnames(Timescale_SobolminusAKMCS) <- eval_time_lab
Timescale_SobolminusAKMCS[nrow(Time_SobolminusAKMCS),]<- "NA"

#nothing is on the -yr, -mon, -wk scale
#still few are on the second scale

#############################################################F###################

Time_SobolminusBASS_hr<- Time_SobolminusBASS/3600
Time_SobolminusBASS_day<- Time_SobolminusBASS_hr/24
Time_SobolminusBASS_yr<- Time_SobolminusBASS_day/365

Timescale_SobolminusBASS<- matrix(NA,nrow=nrow(Time_SobolminusBASS),ncol=ncol(Time_SobolminusBASS))
for(i in 1:(nrow(Time_SobolminusBASS))){
  for(j in 1:ncol(Time_SobolminusBASS)){
    if(Time_SobolminusBASS[i,j]<0 & Time_SobolminusBASS[i,j]>-3600) Timescale_SobolminusBASS[i,j]<- "-min"
    if(Time_SobolminusBASS_hr[i,j]<=-1 & Time_SobolminusBASS_hr[i,j]>-24) Timescale_SobolminusBASS[i,j]<- "-hr"
    if(Time_SobolminusBASS_day[i,j]<=-1 & Time_SobolminusBASS_day[i,j]>-7) Timescale_SobolminusBASS[i,j]<- "-day"
    if(Time_SobolminusBASS_day[i,j]<=-7 & Time_SobolminusBASS_day[i,j]>-28) Timescale_SobolminusBASS[i,j]<- "-wk"
    if(Time_SobolminusBASS_day[i,j]<=-28 & Time_SobolminusBASS_day[i,j]>-365) Timescale_SobolminusBASS[i,j]<- "-mon"
    if(Time_SobolminusBASS_yr[i,j]<=-1 & Time_SobolminusBASS_yr[i,j]>-10) Timescale_SobolminusBASS[i,j]<- "-yr"
    if(Time_SobolminusBASS[i,j]>=0 & Time_SobolminusBASS[i,j]<3600) Timescale_SobolminusBASS[i,j]<- "min"
    if(Time_SobolminusBASS_hr[i,j]>=1 & Time_SobolminusBASS_hr[i,j]<24) Timescale_SobolminusBASS[i,j]<- "hr"
    if(Time_SobolminusBASS_day[i,j]>=1 & Time_SobolminusBASS_day[i,j]<7) Timescale_SobolminusBASS[i,j]<- "day"
    if(Time_SobolminusBASS_day[i,j]>=7 & Time_SobolminusBASS_day[i,j]<28) Timescale_SobolminusBASS[i,j]<- "wk"
    if(Time_SobolminusBASS_day[i,j]>=28 & Time_SobolminusBASS_day[i,j]<365) Timescale_SobolminusBASS[i,j]<- "mon"
    if(Time_SobolminusBASS_yr[i,j]>=1 & Time_SobolminusBASS_yr[i,j]<10) Timescale_SobolminusBASS[i,j]<- "yr"
  }
}

rownames(Timescale_SobolminusBASS) <- tested_D_num
colnames(Timescale_SobolminusBASS) <- eval_time_lab

#nothing is on the -yr, -mon, -wk scale
#nothing on the second scale

################################################################################
#Kriging minus BASS 

Time_KrigingminusBASS_hr<- Time_KrigingminusBASS/3600
Time_KrigingminusBASS_day<- Time_KrigingminusBASS_hr/24
Time_KrigingminusBASS_yr<- Time_KrigingminusBASS_day/365

Timescale_KrigingminusBASS<- matrix(NA,nrow=nrow(Time_KrigingminusBASS),ncol=ncol(Time_KrigingminusBASS))
for(i in 1:(nrow(Time_KrigingminusBASS)-1)){
  for(j in 1:ncol(Time_KrigingminusBASS)){
    if(Time_KrigingminusBASS[i,j]<0 & Time_KrigingminusBASS[i,j]>-3600) Timescale_KrigingminusBASS[i,j]<- "-min"
    if(Time_KrigingminusBASS_hr[i,j]<=-1 & Time_KrigingminusBASS_hr[i,j]>-24) Timescale_KrigingminusBASS[i,j]<- "-hr"
    if(Time_KrigingminusBASS_day[i,j]<=-1 & Time_KrigingminusBASS_day[i,j]>-7) Timescale_KrigingminusBASS[i,j]<- "-day"
    if(Time_KrigingminusBASS_day[i,j]<=-7 & Time_KrigingminusBASS_day[i,j]>-28) Timescale_KrigingminusBASS[i,j]<- "-wk"
    if(Time_KrigingminusBASS_day[i,j]<=-28 & Time_KrigingminusBASS_day[i,j]>-365) Timescale_KrigingminusBASS[i,j]<- "-mon"
    if(Time_KrigingminusBASS_yr[i,j]<=-1 & Time_KrigingminusBASS_yr[i,j]>-10) Timescale_KrigingminusBASS[i,j]<- "-yr"
    if(Time_KrigingminusBASS[i,j]>=0 & Time_KrigingminusBASS[i,j]<3600) Timescale_KrigingminusBASS[i,j]<- "min"
    if(Time_KrigingminusBASS_hr[i,j]>=1 & Time_KrigingminusBASS_hr[i,j]<24) Timescale_KrigingminusBASS[i,j]<- "hr"
    if(Time_KrigingminusBASS_day[i,j]>=1 & Time_KrigingminusBASS_day[i,j]<7) Timescale_KrigingminusBASS[i,j]<- "day"
    if(Time_KrigingminusBASS_day[i,j]>=7 & Time_KrigingminusBASS_day[i,j]<28) Timescale_KrigingminusBASS[i,j]<- "wk"
    if(Time_KrigingminusBASS_day[i,j]>=28 & Time_KrigingminusBASS_day[i,j]<365) Timescale_KrigingminusBASS[i,j]<- "mon"
    if(Time_KrigingminusBASS_yr[i,j]>=1 & Time_KrigingminusBASS_yr[i,j]<10) Timescale_KrigingminusBASS[i,j]<- "yr"
  }
}

rownames(Timescale_KrigingminusBASS) <- tested_D_num
colnames(Timescale_KrigingminusBASS) <- eval_time_lab
Timescale_KrigingminusBASS[nrow(Time_KrigingminusBASS),]<- "NA"
################################################################################
#AKMCS minus BASS 

Time_AKMCSminusBASS_hr<- Time_AKMCSminusBASS/3600
Time_AKMCSminusBASS_day<- Time_AKMCSminusBASS_hr/24
Time_AKMCSminusBASS_yr<- Time_AKMCSminusBASS_day/365

Timescale_AKMCSminusBASS<- matrix(NA,nrow=nrow(Time_AKMCSminusBASS),ncol=ncol(Time_AKMCSminusBASS))
for(i in 1:(nrow(Time_AKMCSminusBASS)-1)){
  for(j in 1:ncol(Time_AKMCSminusBASS)){
    if(Time_AKMCSminusBASS[i,j]<0 & Time_AKMCSminusBASS[i,j]>-3600) Timescale_AKMCSminusBASS[i,j]<- "-min"
    if(Time_AKMCSminusBASS_hr[i,j]<=-1 & Time_AKMCSminusBASS_hr[i,j]>-24) Timescale_AKMCSminusBASS[i,j]<- "-hr"
    if(Time_AKMCSminusBASS_day[i,j]<=-1 & Time_AKMCSminusBASS_day[i,j]>-7) Timescale_AKMCSminusBASS[i,j]<- "-day"
    if(Time_AKMCSminusBASS_day[i,j]<=-7 & Time_AKMCSminusBASS_day[i,j]>-28) Timescale_AKMCSminusBASS[i,j]<- "-wk"
    if(Time_AKMCSminusBASS_day[i,j]<=-28 & Time_AKMCSminusBASS_day[i,j]>-365) Timescale_AKMCSminusBASS[i,j]<- "-mon"
    if(Time_AKMCSminusBASS_yr[i,j]<=-1 & Time_AKMCSminusBASS_yr[i,j]>-10) Timescale_AKMCSminusBASS[i,j]<- "-yr"
    if(Time_AKMCSminusBASS[i,j]>=0 & Time_AKMCSminusBASS[i,j]<3600) Timescale_AKMCSminusBASS[i,j]<- "min"
    if(Time_AKMCSminusBASS_hr[i,j]>=1 & Time_AKMCSminusBASS_hr[i,j]<24) Timescale_AKMCSminusBASS[i,j]<- "hr"
    if(Time_AKMCSminusBASS_day[i,j]>=1 & Time_AKMCSminusBASS_day[i,j]<7) Timescale_AKMCSminusBASS[i,j]<- "day"
    if(Time_AKMCSminusBASS_day[i,j]>=7 & Time_AKMCSminusBASS_day[i,j]<28) Timescale_AKMCSminusBASS[i,j]<- "wk"
    if(Time_AKMCSminusBASS_day[i,j]>=28 & Time_AKMCSminusBASS_day[i,j]<365) Timescale_AKMCSminusBASS[i,j]<- "mon"
    if(Time_AKMCSminusBASS_yr[i,j]>=1 & Time_AKMCSminusBASS_yr[i,j]<10) Timescale_AKMCSminusBASS[i,j]<- "yr"
  }
}

rownames(Timescale_AKMCSminusBASS) <- tested_D_num
colnames(Timescale_AKMCSminusBASS) <- eval_time_lab
Timescale_AKMCSminusBASS[nrow(Time_AKMCSminusBASS),]<- "NA"
################################################################################
#AKMCS minus Kriging 

Time_AKMCSminusKriging_hr<- Time_AKMCSminusKriging/3600
Time_AKMCSminusKriging_day<- Time_AKMCSminusKriging_hr/24
Time_AKMCSminusKriging_yr<- Time_AKMCSminusKriging_day/365

Timescale_AKMCSminusKriging<- matrix(NA,nrow=nrow(Time_AKMCSminusKriging),ncol=ncol(Time_AKMCSminusKriging))
for(i in 1:(nrow(Time_AKMCSminusKriging)-1)){
  for(j in 1:ncol(Time_AKMCSminusKriging)){
    if(Time_AKMCSminusKriging[i,j]<0 & Time_AKMCSminusKriging[i,j]>-3600) Timescale_AKMCSminusKriging[i,j]<- "-min"
    if(Time_AKMCSminusKriging_hr[i,j]<=-1 & Time_AKMCSminusKriging_hr[i,j]>-24) Timescale_AKMCSminusKriging[i,j]<- "-hr"
    if(Time_AKMCSminusKriging_day[i,j]<=-1 & Time_AKMCSminusKriging_day[i,j]>-7) Timescale_AKMCSminusKriging[i,j]<- "-day"
    if(Time_AKMCSminusKriging_day[i,j]<=-7 & Time_AKMCSminusKriging_day[i,j]>-28) Timescale_AKMCSminusKriging[i,j]<- "-wk"
    if(Time_AKMCSminusKriging_day[i,j]<=-28 & Time_AKMCSminusKriging_day[i,j]>-365) Timescale_AKMCSminusKriging[i,j]<- "-mon"
    if(Time_AKMCSminusKriging_yr[i,j]<=-1 & Time_AKMCSminusKriging_yr[i,j]>-10) Timescale_AKMCSminusKriging[i,j]<- "-yr"
    if(Time_AKMCSminusKriging[i,j]>=0 & Time_AKMCSminusKriging[i,j]<3600) Timescale_AKMCSminusKriging[i,j]<- "min"
    if(Time_AKMCSminusKriging_hr[i,j]>=1 & Time_AKMCSminusKriging_hr[i,j]<24) Timescale_AKMCSminusKriging[i,j]<- "hr"
    if(Time_AKMCSminusKriging_day[i,j]>=1 & Time_AKMCSminusKriging_day[i,j]<7) Timescale_AKMCSminusKriging[i,j]<- "day"
    if(Time_AKMCSminusKriging_day[i,j]>=7 & Time_AKMCSminusKriging_day[i,j]<28) Timescale_AKMCSminusKriging[i,j]<- "wk"
    if(Time_AKMCSminusKriging_day[i,j]>=28 & Time_AKMCSminusKriging_day[i,j]<365) Timescale_AKMCSminusKriging[i,j]<- "mon"
    if(Time_AKMCSminusKriging_yr[i,j]>=1 & Time_AKMCSminusKriging_yr[i,j]<10) Timescale_AKMCSminusKriging[i,j]<- "yr"
  }
}

rownames(Timescale_AKMCSminusKriging) <- tested_D_num
colnames(Timescale_AKMCSminusKriging) <- eval_time_lab
Timescale_AKMCSminusKriging[nrow(Time_AKMCSminusKriging),]<- "NA"
################################################################################
# Plot results
cols<-c(brewer.pal(n = 13, name = "RdYlGn"),"#003300","black")

pdf(file = "./New_Figures/Figure_Timescale_SobolminusBASS.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_SobolminusBASS[nrow(Time_SobolminusBASS):1, ],breaks = c("-yr","-mon","-wk","-day","-hr","-min","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()


pdf(file = "./New_Figures/Figure_Timescale_SobolminusAKMCS.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_SobolminusAKMCS[nrow(Time_SobolminusAKMCS):1, ],breaks = c("-yr","-mon","-wk","-day","-hr","-min","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_SobolminusKriging.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_SobolminusKriging[nrow(Time_SobolminusKriging):1, ],breaks = c("-yr","-mon","-wk","-day","-hr","-min","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()


pdf(file = "./New_Figures/Figure_Timescale_KrigingminusBASS.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_KrigingminusBASS[nrow(Time_KrigingminusBASS):1, ],breaks = c("-yr","-mon","-wk","-day","-hr","-min","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_AKMCSminusBASS.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_AKMCSminusBASS[nrow(Time_AKMCSminusBASS):1, ],breaks = c("-yr","-mon","-wk","-day","-hr","-min","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_AKMCSminusKriging.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_AKMCSminusKriging[nrow(Time_AKMCSminusKriging):1, ],breaks = c("-yr","-mon","-wk","-day","-hr","-min","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

################################################################################

#now compare each approach to the fastest approach using a different color scheme

Time_SobolminusFastest <- Time_Sobol-Time_Fastest
Time_KrigingminusFastest <- Time_Kriging-Time_Fastest
Time_AKMCSminusFastest <- Time_AKMCS-Time_Fastest
Time_BASSminusFastest <- Time_BASS-Time_Fastest

################################################################################
#how much time does the fastest method save compared to Sobol?

Time_SobolminusFastest_hr<- Time_SobolminusFastest/3600
Time_SobolminusFastest_day<- Time_SobolminusFastest_hr/24
Time_SobolminusFastest_yr<- Time_SobolminusFastest_day/365

Timescale_SobolminusFastest<- matrix(NA,nrow=nrow(Time_SobolminusFastest),ncol=ncol(Time_SobolminusFastest))
for(i in 1:(nrow(Time_SobolminusFastest))){
  for(j in 1:ncol(Time_SobolminusFastest)){
    if(textMat[i,j]=="Sobol") Timescale_SobolminusFastest[i,j]<- "none"
    if(Time_SobolminusFastest[i,j]>0 & Time_SobolminusFastest[i,j]<3600) Timescale_SobolminusFastest[i,j]<- "min"
    if(Time_SobolminusFastest_hr[i,j]>=1 & Time_SobolminusFastest_hr[i,j]<24) Timescale_SobolminusFastest[i,j]<- "hr"
    if(Time_SobolminusFastest_day[i,j]>=1 & Time_SobolminusFastest_day[i,j]<7) Timescale_SobolminusFastest[i,j]<- "day"
    if(Time_SobolminusFastest_day[i,j]>=7 & Time_SobolminusFastest_day[i,j]<28) Timescale_SobolminusFastest[i,j]<- "wk"
    if(Time_SobolminusFastest_day[i,j]>=28 & Time_SobolminusFastest_day[i,j]<365) Timescale_SobolminusFastest[i,j]<- "mon"
    if(Time_SobolminusFastest_yr[i,j]>=1 & Time_SobolminusFastest_yr[i,j]<10) Timescale_SobolminusFastest[i,j]<- "yr"
  }
}

rownames(Timescale_SobolminusFastest) <- tested_D_num
colnames(Timescale_SobolminusFastest) <- eval_time_lab

################################################################################
#how much time does the fastest method save compared to Kriging?

Time_KrigingminusFastest_hr<- Time_KrigingminusFastest/3600
Time_KrigingminusFastest_day<- Time_KrigingminusFastest_hr/24
Time_KrigingminusFastest_yr<- Time_KrigingminusFastest_day/365

Timescale_KrigingminusFastest<- matrix(NA,nrow=nrow(Time_KrigingminusFastest),ncol=ncol(Time_KrigingminusFastest))
for(i in 1:(nrow(Time_KrigingminusFastest)-1)){
  for(j in 1:ncol(Time_KrigingminusFastest)){
    if(textMat[i,j]=="Kriging") Timescale_KrigingminusFastest[i,j]<- "none"
    if(Time_KrigingminusFastest[i,j]>0 & Time_KrigingminusFastest[i,j]<3600) Timescale_KrigingminusFastest[i,j]<- "min"
    if(Time_KrigingminusFastest_hr[i,j]>=1 & Time_KrigingminusFastest_hr[i,j]<24) Timescale_KrigingminusFastest[i,j]<- "hr"
    if(Time_KrigingminusFastest_day[i,j]>=1 & Time_KrigingminusFastest_day[i,j]<7) Timescale_KrigingminusFastest[i,j]<- "day"
    if(Time_KrigingminusFastest_day[i,j]>=7 & Time_KrigingminusFastest_day[i,j]<28) Timescale_KrigingminusFastest[i,j]<- "wk"
    if(Time_KrigingminusFastest_day[i,j]>=28 & Time_KrigingminusFastest_day[i,j]<365) Timescale_KrigingminusFastest[i,j]<- "mon"
    if(Time_KrigingminusFastest_yr[i,j]>=1 & Time_KrigingminusFastest_yr[i,j]<10) Timescale_KrigingminusFastest[i,j]<- "yr"
  }
}

rownames(Timescale_KrigingminusFastest) <- tested_D_num
colnames(Timescale_KrigingminusFastest) <- eval_time_lab

Timescale_KrigingminusFastest[nrow(Time_KrigingminusFastest),]<- "NA"

################################################################################
#how much time does the fastest method save compared to AKMCS?

Time_AKMCSminusFastest_hr<- Time_AKMCSminusFastest/3600
Time_AKMCSminusFastest_day<- Time_AKMCSminusFastest_hr/24
Time_AKMCSminusFastest_yr<- Time_AKMCSminusFastest_day/365

Timescale_AKMCSminusFastest<- matrix(NA,nrow=nrow(Time_AKMCSminusFastest),ncol=ncol(Time_AKMCSminusFastest))
for(i in 1:(nrow(Time_AKMCSminusFastest)-1)){
  for(j in 1:ncol(Time_AKMCSminusFastest)){
    if(textMat[i,j]=="AKMCS") Timescale_AKMCSminusFastest[i,j]<- "none"
    if(Time_AKMCSminusFastest[i,j]>0 & Time_AKMCSminusFastest[i,j]<3600) Timescale_AKMCSminusFastest[i,j]<- "min"
    if(Time_AKMCSminusFastest_hr[i,j]>=1 & Time_AKMCSminusFastest_hr[i,j]<24) Timescale_AKMCSminusFastest[i,j]<- "hr"
    if(Time_AKMCSminusFastest_day[i,j]>=1 & Time_AKMCSminusFastest_day[i,j]<7) Timescale_AKMCSminusFastest[i,j]<- "day"
    if(Time_AKMCSminusFastest_day[i,j]>=7 & Time_AKMCSminusFastest_day[i,j]<28) Timescale_AKMCSminusFastest[i,j]<- "wk"
    if(Time_AKMCSminusFastest_day[i,j]>=28 & Time_AKMCSminusFastest_day[i,j]<365) Timescale_AKMCSminusFastest[i,j]<- "mon"
    if(Time_AKMCSminusFastest_yr[i,j]>=1 & Time_AKMCSminusFastest_yr[i,j]<10) Timescale_AKMCSminusFastest[i,j]<- "yr"
  }
}

rownames(Timescale_AKMCSminusFastest) <- tested_D_num
colnames(Timescale_AKMCSminusFastest) <- eval_time_lab

Timescale_AKMCSminusFastest[nrow(Time_AKMCSminusFastest),]<- "NA"

################################################################################
#how much time does the fastest method save compared to BASS?

Time_BASSminusFastest_hr<- Time_BASSminusFastest/3600
Time_BASSminusFastest_day<- Time_BASSminusFastest_hr/24
Time_BASSminusFastest_yr<- Time_BASSminusFastest_day/365

Timescale_BASSminusFastest<- matrix(NA,nrow=nrow(Time_BASSminusFastest),ncol=ncol(Time_BASSminusFastest))
for(i in 1:(nrow(Time_BASSminusFastest))){
  for(j in 1:ncol(Time_BASSminusFastest)){
    if(textMat[i,j]=="BASS") Timescale_BASSminusFastest[i,j]<- "none"
    if(Time_BASSminusFastest[i,j]>0 & Time_BASSminusFastest[i,j]<3600) Timescale_BASSminusFastest[i,j]<- "min"
    if(Time_BASSminusFastest_hr[i,j]>=1 & Time_BASSminusFastest_hr[i,j]<24) Timescale_BASSminusFastest[i,j]<- "hr"
    if(Time_BASSminusFastest_day[i,j]>=1 & Time_BASSminusFastest_day[i,j]<7) Timescale_BASSminusFastest[i,j]<- "day"
    if(Time_BASSminusFastest_day[i,j]>=7 & Time_BASSminusFastest_day[i,j]<28) Timescale_BASSminusFastest[i,j]<- "wk"
    if(Time_BASSminusFastest_day[i,j]>=28 & Time_BASSminusFastest_day[i,j]<365) Timescale_BASSminusFastest[i,j]<- "mon"
    if(Time_BASSminusFastest_yr[i,j]>=1 & Time_BASSminusFastest_yr[i,j]<10) Timescale_BASSminusFastest[i,j]<- "yr"
  }
}

rownames(Timescale_BASSminusFastest) <- tested_D_num
colnames(Timescale_BASSminusFastest) <- eval_time_lab

################################################################################
# Plot results
cols<- c("blue","turquoise","green","yellow","orange","red","brown","black")

pdf(file = "./New_Figures/Figure_Timescale_SobolminusFastest.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_SobolminusFastest[nrow(Time_SobolminusFastest):1, ],breaks = c("none","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_KrigingminusFastest.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_KrigingminusFastest[nrow(Time_KrigingminusFastest):1, ],breaks = c("none","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_AKMCSminusFastest.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_AKMCSminusFastest[nrow(Time_AKMCSminusFastest):1, ],breaks = c("none","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

pdf(file = "./New_Figures/Figure_Timescale_BASSminusFastest.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_BASSminusFastest[nrow(Time_BASSminusFastest):1, ],breaks = c("none","min","hr","day","wk","mon","yr","NA"),
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

