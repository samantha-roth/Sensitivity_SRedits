#is the mean worst across all seeds for each model the same? 
#models: polynomial, Sobol's G function, Hymod, SACSMA
#30D: only have an answer for polynomial

rm(list=ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_library.R")
source("extra_functions.R")

# Tested dimension, method names, and evaluation time
tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("Kriging","AKMCS","BASS")
tested_eval_time <- c(0.001,0.01,0.1,1,10,60,600,3600,3600*10)
# Label of evaluation time
eval_time_lab <- c("1ms","10ms","0.1s","1s","10s","1min","10min","1h","10h")

load("./Ranking_Data/textMat_MeanWorst")
text_Gfunc<- textMat_MeanWorst; rm(textMat_MeanWorst)

load("./polynomial/Ranking_Data/textMat_MeanWorst")
text_poly<- textMat_MeanWorst; rm(textMat_MeanWorst)

folder<- paste0(folderpath,"Hymod")
load(paste0(folder,"/textMat_MeanWorst"))
text_Hymod<- textMat_MeanWorst; rm(textMat_MeanWorst)

folder<- paste0(folderpath,"SacSma10")
load(paste0(folder,"/textMat_MeanWorst"))
text_SACSMA10<- textMat_MeanWorst; rm(textMat_MeanWorst)

text_meanWorstAllMod<- matrix(NA,nrow=nrow(text_poly),ncol=ncol(text_poly))

for(i in 1:nrow(text_Gfunc)){
  for(j in 1:ncol(text_Gfunc)){
    if(!is.na(text_Gfunc[i,j]) & !is.na(text_poly[i,j])){
      if(text_Gfunc[i,j]==text_poly[i,j]) text_meanWorstAllMod[i,j]<- text_Gfunc[i,j]
    }
  }
}

i=2
for(j in 1:ncol(text_Hymod)){
  if(!is.na(text_meanWorstAllMod[i,j])){
    if(is.na(text_Hymod[1,j])){
      text_meanWorstAllMod[i,j]<- NA
    } else if (text_Hymod[1,j]!=text_meanWorstAllMod[i,j]){
      text_meanWorstAllMod[i,j]<- NA
    } 
  }
}

i=3
for(j in 1:ncol(text_SACSMA10)){
  if(!is.na(text_meanWorstAllMod[i,j])){
    if(is.na(text_SACSMA10[1,j])){
      text_meanWorstAllMod[i,j]<- NA
    } else if (text_SACSMA10[1,j]!=text_meanWorstAllMod[i,j]){
      text_meanWorstAllMod[i,j]<- NA
    } 
  }
}

save(text_meanWorstAllMod,file="./Ranking_Data/text_meanWorstAllMod")
