#code to generate new figure 4 for Sobol's G function

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

Diff_Time_AKMCS<- Max_Time_AKMCS_G
Diff_Time_BASS<- Max_Time_BASS_G
Diff_Time_Kriging<- Max_Time_Kriging_G
Diff_Time_Sobol<- Max_Time_Sobol_G

for(i in 1:length(tested_D)){
  for(j in 1:length(tested_eval_time)){
    Diff_Time_AKMCS[i,j]<- max(c(Max_Time_AKMCS_G[i,j],Max_Time_AKMCS_poly[i,j]))-
      min(c(Min_Time_AKMCS_G[i,j],Min_Time_AKMCS_poly[i,j]))
    Diff_Time_BASS[i,j]<- max(c(Max_Time_BASS_G[i,j],Max_Time_BASS_poly[i,j]))-
      min(c(Min_Time_BASS_G[i,j],Min_Time_BASS_poly[i,j]))
    Diff_Time_Kriging[i,j]<- max(c(Max_Time_Kriging_G[i,j],Max_Time_Kriging_poly[i,j]))-
      min(c(Min_Time_Kriging_G[i,j],Min_Time_Kriging_poly[i,j]))
    Diff_Time_Sobol[i,j]<- max(c(Max_Time_Sobol_G[i,j],Max_Time_Sobol_poly[i,j]))-
      min(c(Min_Time_Sobol_G[i,j],Min_Time_Sobol_poly[i,j]))
  }
}

################################## AKMCS ########################################

Diff_Time_AKMCS_hr<- Diff_Time_AKMCS/3600
Diff_Time_AKMCS_day<- Diff_Time_AKMCS_hr/24
Diff_Time_AKMCS_yr<- Diff_Time_AKMCS_day/365

Timescale_MaxDiff_AKMCS<- matrix(NA,nrow=nrow(Diff_Time_AKMCS),ncol=ncol(Diff_Time_AKMCS))
for(i in 1:nrow(Diff_Time_AKMCS)){
  for(j in 1:ncol(Diff_Time_AKMCS)){
    if(!is.na(Diff_Time_AKMCS[i,j])){
      if(Diff_Time_AKMCS[i,j]<60) Timescale_MaxDiff_AKMCS[i,j]<- "second"
      if(Diff_Time_AKMCS[i,j]>=60 & Diff_Time_AKMCS[i,j]<3600) Timescale_MaxDiff_AKMCS[i,j]<- "minute"
      if(Diff_Time_AKMCS_hr[i,j]>=1 & Diff_Time_AKMCS_hr[i,j]<24) Timescale_MaxDiff_AKMCS[i,j]<- "hour"
      if(Diff_Time_AKMCS_day[i,j]>=1 & Diff_Time_AKMCS_day[i,j]<7) Timescale_MaxDiff_AKMCS[i,j]<- "day"
      if(Diff_Time_AKMCS_day[i,j]>=7 & Diff_Time_AKMCS_day[i,j]<28) Timescale_MaxDiff_AKMCS[i,j]<- "week"
      if(Diff_Time_AKMCS_day[i,j]>=28 & Diff_Time_AKMCS_day[i,j]<365) Timescale_MaxDiff_AKMCS[i,j]<- "month"
      if(Diff_Time_AKMCS_yr[i,j]>=1 & Diff_Time_AKMCS_yr[i,j]<10) Timescale_MaxDiff_AKMCS[i,j]<- "year"
      if(Diff_Time_AKMCS_yr[i,j]>=10) Timescale_MaxDiff_AKMCS[i,j]<- "decade"
    }
  }
}

rownames(Timescale_MaxDiff_AKMCS) <- tested_D_num
colnames(Timescale_MaxDiff_AKMCS) <- eval_time_lab

Timescale_MaxDiff_AKMCS[which(is.na(Timescale_MaxDiff_AKMCS))]<- "NA"

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Figure_Timescale_MaxDiff_AKMCS.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_MaxDiff_AKMCS[nrow(Timescale_MaxDiff_AKMCS):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

################################## BASS ########################################

Diff_Time_BASS_hr<- Diff_Time_BASS/3600
Diff_Time_BASS_day<- Diff_Time_BASS_hr/24
Diff_Time_BASS_yr<- Diff_Time_BASS_day/365

Timescale_MaxDiff_BASS<- matrix(NA,nrow=nrow(Diff_Time_BASS),ncol=ncol(Diff_Time_BASS))
for(i in 1:nrow(Diff_Time_BASS)){
  for(j in 1:ncol(Diff_Time_BASS)){
    if(!is.na(Diff_Time_BASS[i,j])){
      if(Diff_Time_BASS[i,j]<60) Timescale_MaxDiff_BASS[i,j]<- "second"
      if(Diff_Time_BASS[i,j]>=60 & Diff_Time_BASS[i,j]<3600) Timescale_MaxDiff_BASS[i,j]<- "minute"
      if(Diff_Time_BASS_hr[i,j]>=1 & Diff_Time_BASS_hr[i,j]<24) Timescale_MaxDiff_BASS[i,j]<- "hour"
      if(Diff_Time_BASS_day[i,j]>=1 & Diff_Time_BASS_day[i,j]<7) Timescale_MaxDiff_BASS[i,j]<- "day"
      if(Diff_Time_BASS_day[i,j]>=7 & Diff_Time_BASS_day[i,j]<28) Timescale_MaxDiff_BASS[i,j]<- "week"
      if(Diff_Time_BASS_day[i,j]>=28 & Diff_Time_BASS_day[i,j]<365) Timescale_MaxDiff_BASS[i,j]<- "month"
      if(Diff_Time_BASS_yr[i,j]>=1 & Diff_Time_BASS_yr[i,j]<10) Timescale_MaxDiff_BASS[i,j]<- "year"
      if(Diff_Time_BASS_yr[i,j]>=10) Timescale_MaxDiff_BASS[i,j]<- "decade"
    }
  }
}

rownames(Timescale_MaxDiff_BASS) <- tested_D_num
colnames(Timescale_MaxDiff_BASS) <- eval_time_lab

Timescale_MaxDiff_BASS[which(is.na(Timescale_MaxDiff_BASS))]<- "NA"

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Figure_Timescale_MaxDiff_BASS.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_MaxDiff_BASS[nrow(Timescale_MaxDiff_BASS):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

################################## Kriging ########################################

Diff_Time_Kriging_hr<- Diff_Time_Kriging/3600
Diff_Time_Kriging_day<- Diff_Time_Kriging_hr/24
Diff_Time_Kriging_yr<- Diff_Time_Kriging_day/365

Timescale_MaxDiff_Kriging<- matrix(NA,nrow=nrow(Diff_Time_Kriging),ncol=ncol(Diff_Time_Kriging))
for(i in 1:nrow(Diff_Time_Kriging)){
  for(j in 1:ncol(Diff_Time_Kriging)){
    if(!is.na(Diff_Time_Kriging[i,j])){
      if(Diff_Time_Kriging[i,j]<60) Timescale_MaxDiff_Kriging[i,j]<- "second"
      if(Diff_Time_Kriging[i,j]>=60 & Diff_Time_Kriging[i,j]<3600) Timescale_MaxDiff_Kriging[i,j]<- "minute"
      if(Diff_Time_Kriging_hr[i,j]>=1 & Diff_Time_Kriging_hr[i,j]<24) Timescale_MaxDiff_Kriging[i,j]<- "hour"
      if(Diff_Time_Kriging_day[i,j]>=1 & Diff_Time_Kriging_day[i,j]<7) Timescale_MaxDiff_Kriging[i,j]<- "day"
      if(Diff_Time_Kriging_day[i,j]>=7 & Diff_Time_Kriging_day[i,j]<28) Timescale_MaxDiff_Kriging[i,j]<- "week"
      if(Diff_Time_Kriging_day[i,j]>=28 & Diff_Time_Kriging_day[i,j]<365) Timescale_MaxDiff_Kriging[i,j]<- "month"
      if(Diff_Time_Kriging_yr[i,j]>=1 & Diff_Time_Kriging_yr[i,j]<10) Timescale_MaxDiff_Kriging[i,j]<- "year"
      if(Diff_Time_Kriging_yr[i,j]>=10) Timescale_MaxDiff_Kriging[i,j]<- "decade"
    }
  }
}

rownames(Timescale_MaxDiff_Kriging) <- tested_D_num
colnames(Timescale_MaxDiff_Kriging) <- eval_time_lab

Timescale_MaxDiff_Kriging[which(is.na(Timescale_MaxDiff_Kriging))]<- "NA"

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Figure_Timescale_MaxDiff_Kriging.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_MaxDiff_Kriging[nrow(Timescale_MaxDiff_Kriging):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()

################################## Sobol ########################################

Diff_Time_Sobol_hr<- Diff_Time_Sobol/3600
Diff_Time_Sobol_day<- Diff_Time_Sobol_hr/24
Diff_Time_Sobol_yr<- Diff_Time_Sobol_day/365

Timescale_MaxDiff_Sobol<- matrix(NA,nrow=nrow(Diff_Time_Sobol),ncol=ncol(Diff_Time_Sobol))
for(i in 1:nrow(Diff_Time_Sobol)){
  for(j in 1:ncol(Diff_Time_Sobol)){
    if(!is.na(Diff_Time_Sobol[i,j])){
      if(Diff_Time_Sobol[i,j]<60) Timescale_MaxDiff_Sobol[i,j]<- "second"
      if(Diff_Time_Sobol[i,j]>=60 & Diff_Time_Sobol[i,j]<3600) Timescale_MaxDiff_Sobol[i,j]<- "minute"
      if(Diff_Time_Sobol_hr[i,j]>=1 & Diff_Time_Sobol_hr[i,j]<24) Timescale_MaxDiff_Sobol[i,j]<- "hour"
      if(Diff_Time_Sobol_day[i,j]>=1 & Diff_Time_Sobol_day[i,j]<7) Timescale_MaxDiff_Sobol[i,j]<- "day"
      if(Diff_Time_Sobol_day[i,j]>=7 & Diff_Time_Sobol_day[i,j]<28) Timescale_MaxDiff_Sobol[i,j]<- "week"
      if(Diff_Time_Sobol_day[i,j]>=28 & Diff_Time_Sobol_day[i,j]<365) Timescale_MaxDiff_Sobol[i,j]<- "month"
      if(Diff_Time_Sobol_yr[i,j]>=1 & Diff_Time_Sobol_yr[i,j]<10) Timescale_MaxDiff_Sobol[i,j]<- "year"
      if(Diff_Time_Sobol_yr[i,j]>=10) Timescale_MaxDiff_Sobol[i,j]<- "decade"
    }
  }
}

rownames(Timescale_MaxDiff_Sobol) <- tested_D_num
colnames(Timescale_MaxDiff_Sobol) <- eval_time_lab

Timescale_MaxDiff_Sobol[which(is.na(Timescale_MaxDiff_Sobol))]<- "NA"

# Color palette
cols<-c("blue","turquoise","green","yellow","orange","red","brown","black","white")
brks<-c("second","minute","hour","day","week","month","year","decade","NA")

pdf(file = "./Sam_Figures/Figure_Timescale_MaxDiff_Sobol.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
plot(Timescale_MaxDiff_Sobol[nrow(Timescale_MaxDiff_Sobol):1, ],breaks = brks,
     xlab="Time of single run",ylab="Number of input parameters",col=cols,
     cex.lab=1.5,cex.axis=1,main="")
dev.off()


