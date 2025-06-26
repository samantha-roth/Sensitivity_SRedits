
rm(list = ls())
graphics.off()
setwd("/dartfs-hpc/rc/home/y/f0071xy/Sensitivity_SRedits_Final")
source("0_libraryPoly.R")

#times to load for Sobol'
for(k in 1:length(D)){
  d<-D[k]
  print(paste0("input dimensions:",d))
  folder <- paste0(folderpath,"Polynomial/", d,"D")
  load(paste0(folder,"/Sobol/T_Sobol"))
  load(paste0(folder,"/Sobol/T_check_Sobol"))
  load(paste0(folder,"/Sobol/all_eval_times"))
  load(paste0(folder,"/Sobol/S_Sobol"))
  load(paste0(folder,"/Sobol/Sobol_convergesize"))
  print(paste0("length(T_check_Sobol)==length(T_Sobol): ",length(T_check_Sobol)==length(T_Sobol)))
  print(paste0("S$C==Sobol_convergesize: ",S$C==Sobol_convergesize))
  #print(paste0("tot_size[length(T_Sobol)]: ",tot_size[length(T_Sobol)]))
  #print(paste0("Sobol_convergesize: ",Sobol_convergesize))
  #print(paste0("S$C: ", S$C))
}
#for k= 1,2,3,4,5, tot_size[length(T_Sobol)]= Sobol_convergesize
#for k= 6, tot_size[length(T_Sobol)]!= Sobol_convergesize
#Sobol_convergesize is bigger
#length(T_Sobol) matches length(T_check_Sobol) matches length(all_eval_times)
#S$C is always closer to Sobol_convergesize
#for the first 5 entries of tot_size[m], N=1.
#tot_size[length(T_Sobol)+5]=Sobol_convergesize. problem solved.
#times to load for Kriging:
for(k in 1:(length(D))){
  d<-D[k]
  print(paste0("input dimensions:",d))
  folder <- paste0(folderpath,"Polynomial/", d,"D")
  load(paste0(folder,"/Kriging/T_Kriging"))
  load(paste0(folder,"/Kriging/T_pred_Kriging"))
  load(paste0(folder,"/Kriging/Kriging_size"))
  load(paste0(folder,"/Kriging/Kriging_size_vec"))
  load(paste0(folder,"/Kriging/T_KrigingSobol"))
  load(paste0(folder,"/Kriging/T_check_Kriging"))
  load(paste0(folder,"/Kriging/S_Kriging"))
  load(paste0(folder,"/Kriging/Sobol_Kriging_convergesize"))
  print(paste0("Kriging_size==Kriging_size_vec[length(Kriging_size_vec)]: ",Kriging_size==Kriging_size_vec[length(Kriging_size_vec)]))
  print(paste0("length(Kriging_size_vec)==length(T_Kriging): ", length(Kriging_size_vec)==length(T_Kriging)))
  print(paste0("length(T_pred_Kriging)==length(T_Kriging): ", length(T_pred_Kriging)==length(T_Kriging)))
  print(paste0("length(T_KrigingSobol)==length(T_check_Kriging): ",length(T_KrigingSobol)==length(T_check_Kriging)))
  print(paste0("Sobol_Kriging_convergesize==S_Kriging$C: ",Sobol_Kriging_convergesize==S_Kriging$C))
}
#for k in 1:5, "length(T_pred_Kriging)==length(T_Kriging): TRUE"
#for k in 1:5, "length(T_KrigingSobol)==length(T_check_Kriging): TRUE"
#for k in 1:5, tot_size[length(T_Kriging)]=Sobol_Kriging_convergesize
#for k=6, tot_size[length(T_Kriging)+5]=Sobol_Kriging_convergesize
#times to load for BASS:
for(k in 1:length(D)){
  d<-D[k]
  print(paste0("input dimensions:",d))
  folder <- paste0(folderpath,"Polynomial/", d,"D")
  load(paste0(folder, "/BASS/T_BASS"))
  load(paste0(folder, "/BASS/T_pred_BASS"))
  load(paste0(folder, "/BASS/T_check_BASS"))
  load(paste0(folder,"/BASS/T_BASSSobol"))
  load(paste0(folder,"/BASS/S_BASS"))
  load(paste0(folder,"/BASS/BASS_size"))
  load(paste0(folder,"/BASS/BASS_size_vec"))
  print(paste0("BASS_size==BASS_size_vec[length(BASS_size_vec)]: ",BASS_size==BASS_size_vec[length(BASS_size_vec)]))
  print(paste0("length(T_pred_BASS)==length(T_BASS): ", length(T_pred_BASS)==length(T_BASS)))
  print(paste0("length(T_BASSSobol)==length(T_check_BASS): ",length(T_BASSSobol)==length(T_check_BASS)))
  print(paste0("length(T_BASS)==length(BASS_size_vec): ",length(T_BASS)==length(BASS_size_vec)))
}
#for k in 1:6, "length(T_pred_BASS)==length(T_BASS): TRUE"
#for k in 1:6, "length(T_BASSSobol)==length(T_check_BASS): TRUE"
#for k in 1:6, "length(T_BASS)==length(BASS_size_vec): TRUE"
#bass output lengths match. good.
#times to load for AKMCS:
for(k in 1:(length(D))){
  d<-D[k]
  print(paste0("input dimensions:",d))
  folder <- paste0(folderpath,"Polynomial/", d,"D")
  load(paste0(folder,"/AKMCS/AKMCS_size"))
  load(paste0(folder,"/AKMCS/AKMCS_size_vec"))
  load(paste(folder,"/AKMCS/T_AKMCS",sep=""))
  load(paste0(folder,"/AKMCS/T_pred_AKMCS"))
  load(paste(folder,"/AKMCS/x",sep=""))
  #load(paste(folder,"/AKMCS/a",sep=""))
  #load(paste0(folder,"/AKMCS/rows_rest"))
  load(paste0(folder,"/AKMCS/T_AKMCSSobol"))
  load(paste0(folder,"/AKMCS/T_check_AKMCS"))
  load(paste0(folder,"/AKMCS/S_AKMCS"))
  load(paste0(folder,"/AKMCS/Sobol_AKMCS_convergesize"))
  #print(paste0("length(T_AKMCS): ", length(T_AKMCS)))
  #print(paste0("length(T_pred_AKMCS): ", length(T_pred_AKMCS)))
  #print(paste0("length(AKMCS_size_vec): ", length(AKMCS_size_vec)))
  #print(paste0("nrow(x): ", nrow(x)))
  #print(paste0("AKMCS_size: ", AKMCS_size))
  #print(paste0("AKMCS_size_vec[length(AKMCS_size_vec)]: ", AKMCS_size_vec[length(AKMCS_size_vec)]))
  #print(paste0("length(T_AKMCSSobol): ", length(T_AKMCSSobol)))
  #print(paste0("length(T_check_AKMCS): ", length(T_check_AKMCS)))
  print(paste0("nrow(x)==AKMCS_size: ",nrow(x)==AKMCS_size))
  print(paste0("AKMCS_size==AKMCS_size_vec[length(AKMCS_size_vec)]: ",AKMCS_size==AKMCS_size_vec[length(AKMCS_size_vec)]))
  print(paste0("length(T_pred_AKMCS)==length(T_AKMCS): ",length(T_pred_AKMCS)==length(T_AKMCS)))
  print(paste0("length(T_pred_AKMCS)==length(AKMCS_size_vec): ",length(T_pred_AKMCS)==length(AKMCS_size_vec)))
  #print(paste0("tot_size[length(T_AKMCSSobol)]: ",tot_size[length(T_AKMCSSobol)]))
  print(paste0("Sobol_AKMCS_convergesize==S_AKMCS$C: ",Sobol_AKMCS_convergesize==S_AKMCS$C))
}
#always equal: length(T_AKMCS), length(T_pred_AKMCS), length(AKMCS_size_vec)
#always equal: nrow(x), AKMCS_size, AKMCS_size_vec[length(AKMCS_size_vec)]
#always equal: T_AKMCSSobol, T_check_AKMCS
#always equal: Sobol_AKMCS_convergesize==tot_size[length(T_AKMCSSobol)]