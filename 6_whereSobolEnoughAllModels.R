
rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_library.R")

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

################################################################################
#using the mean Sobol time
load("./Ranking_Data/textMat_SobolEnough")
textMat_SobolEnough_G<- textMat_SobolEnough; rm(textMat_SobolEnough)

load("./Ranking_Data/Hymod/textMat_SobolEnough")
textMat_SobolEnough_Hymod<- textMat_SobolEnough; rm(textMat_SobolEnough)

load("./Ranking_Data/SacSma10/textMat_SobolEnough")
textMat_SobolEnough_SACSMA<- textMat_SobolEnough; rm(textMat_SobolEnough)

load("./polynomial/Ranking_Data/textMat_SobolEnough")
textMat_SobolEnough_Poly<- textMat_SobolEnough; rm(textMat_SobolEnough)


textMat_SobolEnough_All<- matrix(NA, nrow=length(tested_D_num),ncol=length(tested_eval_time))

for(i in 1:length(tested_D)){
  if(tested_D_num[i]==5){
    
    good_inds1<- intersect(which(textMat_SobolEnough_G[i,]=="yes"),
                          which(textMat_SobolEnough_Poly[i,]=="yes"))
    good_inds<- intersect(good_inds1,which(textMat_SobolEnough_Hymod[1,]=="yes"))
    
  }else if(tested_D_num[i]==10){
    
    good_inds1<- intersect(which(textMat_SobolEnough_G[i,]=="yes"),
                          which(textMat_SobolEnough_Poly[i,]=="yes"))
    good_inds<- intersect(good_inds1,which(textMat_SobolEnough_SACSMA[1,]=="yes"))
    
  }else{
    good_inds<- intersect(which(textMat_SobolEnough_G[i,]=="yes"),
                          which(textMat_SobolEnough_Poly[i,]=="yes"))
  }
  
  textMat_SobolEnough_All[i,good_inds]<- "yes"
}

textMat_SobolEnough_All[which(textMat_SobolEnough_All=="yes")]<- "Yes"
textMat_SobolEnough_All[which(is.na(textMat_SobolEnough_All))]<- "No"

colnames(textMat_SobolEnough_All)<- eval_time_lab
rownames(textMat_SobolEnough_All)<- tested_D

save(textMat_SobolEnough_All,file="./Ranking_Data/textMat_SobolEnough_All")

################################################################################
#using the max Sobol time
load("./Ranking_Data/textMat_SobolMaxEnough")
textMat_SobolMaxEnough_G<- textMat_SobolMaxEnough; rm(textMat_SobolMaxEnough)

load("./Ranking_Data/Hymod/textMat_SobolMaxEnough")
textMat_SobolMaxEnough_Hymod<- textMat_SobolMaxEnough; rm(textMat_SobolMaxEnough)

load("./Ranking_Data/SacSma10/textMat_SobolMaxEnough")
textMat_SobolMaxEnough_SACSMA<- textMat_SobolMaxEnough; rm(textMat_SobolMaxEnough)

load("./polynomial/Ranking_Data/textMat_SobolMaxEnough")
textMat_SobolMaxEnough_Poly<- textMat_SobolMaxEnough; rm(textMat_SobolMaxEnough)


textMat_SobolMaxEnough_All<- matrix(NA, nrow=length(tested_D_num),ncol=length(tested_eval_time))

for(i in 1:length(tested_D)){
  if(tested_D_num[i]==5){
    
    good_inds1<- intersect(which(textMat_SobolMaxEnough_G[i,]=="yes"),
                           which(textMat_SobolMaxEnough_Poly[i,]=="yes"))
    good_inds<- intersect(good_inds1,which(textMat_SobolMaxEnough_Hymod[1,]=="yes"))
    
  }else if(tested_D_num[i]==10){
    
    good_inds1<- intersect(which(textMat_SobolMaxEnough_G[i,]=="yes"),
                           which(textMat_SobolMaxEnough_Poly[i,]=="yes"))
    good_inds<- intersect(good_inds1,which(textMat_SobolMaxEnough_SACSMA[1,]=="yes"))
    
  }else{
    good_inds<- intersect(which(textMat_SobolMaxEnough_G[i,]=="yes"),
                          which(textMat_SobolMaxEnough_Poly[i,]=="yes"))
  }
  
  textMat_SobolMaxEnough_All[i,good_inds]<- "yes"
}

textMat_SobolMaxEnough_All[which(textMat_SobolMaxEnough_All=="yes")]<- "Yes"
textMat_SobolMaxEnough_All[which(is.na(textMat_SobolMaxEnough_All))]<- "No"

colnames(textMat_SobolMaxEnough_All)<- eval_time_lab
rownames(textMat_SobolMaxEnough_All)<- tested_D

save(textMat_SobolMaxEnough_All,file="./Ranking_Data/textMat_SobolMaxEnough_All")