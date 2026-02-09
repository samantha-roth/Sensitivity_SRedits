#check which of the seeds have not converged

#check 1: do T_check_BASS, T_BASSSobol, and S_BASS exist?
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_library.R")

for(k in 1:6){
  for(node in 1:4){
    print(paste0("k= ",k))
    seed<- node*k
    print(paste0("seed= ",seed))
    d=D[k]
    
    folder<-paste0(folderpath,d,"D/Kriging/seed",seed)
    
    try(load(paste0(folder, "/T_check_Kriging")))
    try(load(paste0(folder,"/T_KrigingSobol")))
    try(load(paste0(folder,"/S_Kriging")))
    try(load(paste0(folder,"/Sobol_Kriging_convergesize")))
  }
}
#all of them have converged for k<=5
#only seed 24 converged for k=6 after part 2