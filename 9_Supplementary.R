# This script makes the supplementary figures
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

# An adjustment for standard Sobol's time: for fast test models, it is likely the time becomes negative due
#     to random noises in the time recording.
Time_Sobol[Time_Sobol < 0] <- Time_Sobol[1,1]

PercentTime_Kriging <- Time_Sobol/Time_Kriging
PercentTime_AKMCS <- Time_Sobol/Time_AKMCS
PercentTime_BASS <- Time_Sobol/Time_BASS

# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

#-------------------------------------
#Grid plot of Kriging gain
Mat = round(log10(PercentTime_Kriging))+0.001
Cols<-brewer.pal(n = 7, name = "RdYlGn")
rownames(Mat)<-tested_D_num
colnames(Mat)<-eval_time_lab
pdf(file = "./New_Figures/Figure_S1.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,7))
plot(Mat[nrow(Mat):1, ],breaks = c(-5:2),col=Cols,xlab="Time of single run",
     ylab="Number of input parameters",digits = 1,fmt.cell='%.0f',max.col=100,
     cex.lab=1.5,cex.axis=1,main="",fmt.key = "%.0f")
mtext('Order of magnitude', side=3, line=1, at=15)
mtext('Speed gain of Kriging',side=3, line=-0.5, at=15)
dev.off()

#-------------------------------------
#Grid plot of AKMCS gain
Mat = round(log10(PercentTime_AKMCS))+0.001
Cols<-brewer.pal(n = 8, name = "RdYlGn")
rownames(Mat)<-tested_D_num
colnames(Mat)<-eval_time_lab
pdf(file = "./New_Figures/Figure_S2.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,7))
plot(Mat[nrow(Mat):1, ],breaks = c(-5:3),col=Cols,xlab="Time of single run",
     ylab="Number of input parameters",digits = 1,fmt.cell='%.0f',max.col=100,
     cex.lab=1.5,cex.axis=1,main="",fmt.key = "%.0f")
mtext('Order of magnitude', side=3, line=1, at=15)
mtext('Speed gain of AKMCS',side=3, line=-0.5, at=15)
dev.off()

#-------------------------------------
#Grid plot of BASS gain
Mat = round(log10(PercentTime_BASS))+0.001
Cols<-brewer.pal(n = 5, name = "RdYlGn")
rownames(Mat)<-tested_D_num
colnames(Mat)<-eval_time_lab
pdf(file = "./New_Figures/Figure_S3.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,7))
plot(Mat[nrow(Mat):1, ],breaks = c(-3:2),col=Cols,xlab="Time of single run",
     ylab="Number of input parameters",digits = 1,fmt.cell='%.0f',max.col=100,
     cex.lab=1.5,cex.axis=1,main="",fmt.key = "%.0f")
mtext('Order of magnitude', side=3, line=1, at=15)
mtext('Speed gain of BASS',side=3, line=-0.5, at=15)
dev.off()

#----------------------------------------------
# 
# Speed gain compared with brute force Sobol method (Figure S4)
Mat <- Time_Sobol
textMat <- matrix(NA,nrow=nrow(Mat),ncol=ncol(Mat))
for (i in 1:length(tested_D)) {
  for (j in 1:length(tested_eval_time)){
    if(i==length(tested_D)){
      Mat[i,j] <- min(Time_Sobol[i,j],Time_Kriging[i,j],
                      Time_BASS[i,j],na.rm=TRUE)
      if (Mat[i,j]==Time_Sobol[i,j]){
        textMat[i,j] <- "S"
      } 
      if (Mat[i,j]==Time_Kriging[i,j]){
        textMat[i,j] <- "K"
      } 
      if (Mat[i,j]==Time_BASS[i,j]){
        textMat[i,j] <- "B"
      }
    }
    else{
      Mat[i,j] <- min(Time_Sobol[i,j],Time_Kriging[i,j],
                      Time_AKMCS[i,j],Time_BASS[i,j],na.rm=TRUE)
      if (Mat[i,j]==Time_Sobol[i,j]){
        textMat[i,j] <- "S"
      } 
      if (Mat[i,j]==Time_Kriging[i,j]){
        textMat[i,j] <- "K"
      } 
      if (Mat[i,j]==Time_AKMCS[i,j]){
        textMat[i,j] <- "A"
      } 
      if (Mat[i,j]==Time_BASS[i,j]){
        textMat[i,j] <- "B"
      }
    }
  }
}
Mat <- Time_Sobol/Mat
Mat <- round(log10(Mat))
rownames(Mat)<-tested_D_num
colnames(Mat)<-eval_time_lab
Cols<-brewer.pal(n = 2, name = "Reds")
pdf(file = "./New_Figures/Figure_S4.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,6))
time<-plot(Mat[nrow(Mat):1, ],breaks=c(0:2),digits=1,fmt.cell='%.0f',
           xlab="Time of single run",ylab="Number of input parameters",col=Cols,
           text.cell=list(pos=3, cex=1),max.col=100,
           cex.lab=1.5,cex.axis=1,main="",fmt.key = "%.0f")
for (i in 1:nrow(Mat)) {
  for (j in 1:ncol(Mat)) {
    args<-time$cell.text[[nrow(Mat)+1-i,j]]
    args$labels <- textMat[i,j]
    args$cex    <- 1.5
    args$pos    <- 1
    do.call(text, args)
  }
}
mtext("Orders of",side = 3, at = 15)
mtext("magnitude",side = 3, at = 15, line = -1)
dev.off()

#-------------------
# speed gain of best method compared with the second best method (Figure S5)
Mat<-Time_Sobol
textMat <- matrix(NA,nrow=nrow(Mat),ncol=ncol(Mat))
for (i in 1:nrow(Mat)){
  for (j in 1:ncol(Mat)){
    if(i==nrow(Mat)){
      vec <- c(Time_Sobol[i,j],Time_Kriging[i,j],Time_BASS[i,j])
      Text <- c("S","K","B")
      vec <- vec[!is.na(vec)]
      r <- order(vec)
      Mat[i,j]<-vec[r[2]]/vec[r[1]]
      textMat[i,j]<-paste(Text[r[1]],"(",Text[r[2]],")",sep="")
    }
    else{
      vec <- c(Time_Sobol[i,j],Time_Kriging[i,j],Time_AKMCS[i,j],Time_BASS[i,j])
      Text <- c("S","K","A","B")
      vec <- vec[!is.na(vec)]
      r <- order(vec)
      Mat[i,j]<-vec[r[2]]/vec[r[1]]
      textMat[i,j]<-paste(Text[r[1]],"(",Text[r[2]],")",sep="")
    }
  }
}
Mat <- round(log10(Mat))
rownames(Mat)<-tested_D_num
colnames(Mat)<-eval_time_lab
Cols<-brewer.pal(n = 4, name = "Reds")
pdf(file = "./New_Figures/Figure_S5.pdf",width = 12,height = 7)
par(mar=c(5,5,2.6,5.5))
Fast<-plot(Mat[nrow(Mat):1, ],breaks = c(0:4),col=Cols,digits = 1,fmt.cell='%.0f',
     xlab="Time of single run",ylab="Number of input parameters",
     text.cell=list(pos=3, cex=1),cex.lab=1.5,cex.axis=1,main="",fmt.key = "%.0f")
for (i in 1:nrow(Mat)) {
  for (j in 1:ncol(Mat)) {
    args<-Fast$cell.text[[nrow(Mat)+1-i,j]]
    args$labels <- textMat[i,j]
    args$cex    <- 1.5
    args$pos    <- 1
    do.call(text, args)
  }
}
mtext('Order of magnitude', side=3, line=1, at=15)
mtext(expression(paste("(",plain("T")[plain("2nd")]," / ",plain("T")[plain("1st")],")")),
      side=3, line=-0.5, at=15)
dev.off()

#-----------------------
