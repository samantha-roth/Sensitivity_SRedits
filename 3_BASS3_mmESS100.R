# Sobol based on the Bayesian Adaptive Spline Surface (BASS) method
# Note: the Sobol analysis in this script directly uses the function in "BASS" package instead of sensobol package

# This script also takes a time when dealing with high-dimensional models (but not extremely long).
#       Again change the dimension vector D for code replication check.
# Remove all existing environment and plots
rm(list = ls())
graphics.off()

source("0_library.R")
source("bass_mcmc_size.R")
source("check_T_convergence.R")

# Set a random seed
set.seed(33)

print("3_BASS3_mmESS100.R")

# Define the model in each dimension and apply BASS method
k=3

T_LHS_BASS<- vector()
T_BASS<- vector()
T_pred_BASS<- vector()
T_BASSSobol<- vector()
T_check_BASS<- vector()
T_model_BASS<- vector()

# Model dimension
d=D[k]

# Folder for d dimension test scenario
folder <- paste0(folderpath,d,"D/BASS_mmESS")
if (!dir.exists(folder)) dir.create(file.path(folder), showWarnings = FALSE)

# Use 20,000 LHS training data points to test emulator quality
x_test <- randomLHS(2e4,d)
save(x_test,file = paste0(folder,"/x_test"))

# Similar to Kriging method, we begin with 10 times model dimension samples
BASS_size <- 10*d
BASS_size_vec <- BASS_size

n_empars<- d*10+4
nthin<-n_empars
burn_size<-n_empars
mcmc_init_size <- ceiling(2e5/n_empars)*n_empars+n_empars*1e3+burn_size
wantESS<-100
nwant_pred<- 1e4
nwant_T<- 100

while (1>0) {
  #set.seed(33)
  if(length(BASS_size_vec)==1){
    start.time<- Sys.time()
    X_BASS <- randomLHS(BASS_size, d)
    end.time<- Sys.time()
    LHS_time <- difftime(end.time,start.time, units = "secs")
    T_LHS_BASS<- c(T_LHS_BASS,LHS_time)
  }
  if(length(BASS_size_vec)>1){
    start.time<- Sys.time()
    X_BASS <- augmentLHS(X_BASS,d)
    end.time<- Sys.time()
    LHS_time <- difftime(end.time,start.time, units = "secs")
    T_LHS_BASS<- c(T_LHS_BASS,LHS_time)
  }
  save(T_LHS_BASS, file = paste0(folder, "/T_LHS_BASS"))
  save(X_BASS, file = paste0(folder, "/X_BASS"))
  save(BASS_size,file = paste0(folder,"/BASS_size"))
  save(BASS_size_vec,file = paste0(folder,"/BASS_size_vec"))
  
  start.time<- Sys.time()
  Y <- apply(X_BASS, 1, Testmodel)
  end.time <- Sys.time()
  model_time <- difftime(end.time,start.time, units = "secs")
  T_model_BASS<- c(T_model_BASS,model_time)
  save(T_model_BASS, file = paste0(folder,"/T_model_BASS"))
  
  # Use a MCMC size determined by multivariate ESS
  mcmc_out<- bass_mcmc_size(x=X_BASS, y=Y, mcmc_init_size=mcmc_init_size, 
                            burn_size=burn_size, nthin=nthin, wantESS=wantESS)
  mod_list<- mcmc_out[[1]]
  par_chain<- mcmc_out[[2]]
  mESS<- mcmc_out[[3]]
  tot_fit_time<- mcmc_out[[4]]
  tot_steps<- mcmc_out[[5]]
  cs_steps<- mcmc_out[[6]]
  good_beta_inds<- mcmc_out[[7]]
  
  T_BASS<- c(T_BASS,tot_fit_time)
  save(T_BASS, file = paste0(folder, "/T_BASS"))
  save(tot_steps,file=paste0(folder,"/tot_steps"))
  save(par_chain,file=paste0(folder,"/par_chain"))
  save(cs_steps,file=paste0(folder,"/cs_steps"))
  save(mESS,file=paste0(folder,"/mESS"))
  save(mod_list,file=paste0(folder,"/mod_list"))
  
  y<- matrix(NA,nrow=1,ncol=nrow(x_test))
  for(i in 1:length(mod_list)){
    mod_i<- mod_list[[i]]
    
    valid_steps<- which(mod_i$model.lookup>0)
    
    y<- rbind(y,predict(mod_i,x_test,mcmc.use= valid_steps))
  }
  y<- y[-1,]
  
  end.time<- Sys.time()
  pred_time<- difftime(end.time,start.time, units = "secs")
  T_pred_BASS<- c(T_pred_BASS, pred_time)
  
  std <- sqrt(apply(y, 2, var)); print("std done")
  mean <- colMeans(y)
  print(paste0("sample size = ",BASS_size))
  print(paste0("max std = ",max(std), ", thres value = ", (max(mean)-min(mean))/20))
  
  #save(others_ESS,beta_ESS,file=paste0(folder,"/ESS_vals"))
  #save(others_ESS,file=paste0(folder,"/ESS_vals"))
  
  save(T_pred_BASS, file = paste0(folder, "/T_pred_BASS"))
  
  # If still need to take more samples, add the sample size by d
  if (max(std) > ((max(mean)-min(mean))/20)){
    BASS_size <- BASS_size + d
    BASS_size_vec<- c(BASS_size_vec,BASS_size)
  }
  # otherwise perform sensitivity analysis and record the time
  else{
    check_T_out<- check_T_convergence(x=x,y=y,mod_list=mod_list, burn_size=burn_size, nthin=nthin, nwant_T=nwant_T)
    
    mod_list<- check_T_out[[1]]
    S_BASS_list<- check_T_out[[2]]
    T_BASSSobol<- check_T_out[[3]]
    T_check_BASS<- check_T_out[[4]]
    
    save(mod_list,file=paste0(folder,"/mod_list"))
    save(T_check_BASS, file = paste0(folder, "/T_check_BASS"))
    save(T_BASSSobol,file = paste0(folder,"/T_BASSSobol"))
    save(S_BASS_list,file = paste0(folder,"/S_BASS_list"))
    break
  }
}

