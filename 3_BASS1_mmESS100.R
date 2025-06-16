# Sobol based on the Bayesian Adaptive Spline Surface (BASS) method
# Note: the Sobol analysis in this script directly uses the function in "BASS" package instead of sensobol package

# This script also takes a time when dealing with high-dimensional models (but not extremely long).
#       Again change the dimension vector D for code replication check.
# Remove all existing environment and plots
rm(list = ls())
graphics.off()

source("0_library.R")
source("bass_mcmc_size.R")
#source("predict_modified.R")

# Set a random seed
set.seed(33)

print("3_BASS1_mmESS100.R")

# Define the model in each dimension and apply BASS method
k=1

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
  
  
  #print("files saved")
  start.time<- Sys.time()
  if(tot_steps>nwant_pred){
    
    sample_every<- round(tot_steps/nwant_pred)
    all_pred_inds<- round(seq(sample_every,tot_steps,length.out=nwant_pred))
    y<- matrix(NA,nrow=1,ncol=nrow(x_test))
    
    for(i in 1:length(mod_list)){
      
      mod_i<- mod_list[[i]]
      #print(paste0("model ",i))
      curr_inds<- all_pred_inds[which(all_pred_inds%in%which(mod_inds==i))]#; print("curr_inds done")
      pred_inds<- curr_inds-cs_steps[i]#; print("pred_inds done")
      
      valid_inds<- which(mod_i$model.lookup>0)
      use_inds<- intersect(pred_inds,valid_inds)
      
      y<- rbind(y,predict_modified(mod_i,x_test,mcmc.use=use_inds))#; print("y done")
      #y[(cs_steps[i]+1):cs_steps[i+1],]<- predict(mod_list[[i]],x_test)
    }
  } else{
    y<- matrix(NA,nrow=1,ncol=nrow(x_test))
    for(i in 1:length(mod_list)){
      mod_i<- mod_list[[i]]
      
      valid_inds<- which(mod_i$model.lookup>0)
      
      y<- rbind(y,predict_modified(mod_i,x_test,mcmc.use=valid_inds))#; print("y done")
    }
  }
  y<- y[-1,]; print("y done done")
  
  # y<- matrix(NA,nrow=1,ncol=nrow(x_test))
  # for(i in 1:length(mod_list)){
  #   mod_i<- mod_list[[i]]
  #   
  #   valid_steps<- which(mod_i$model.lookup>0)
  #   
  #   y<- rbind(y,predict(mod_i,x_test,mcmc.use= valid_steps))
  # }
  # y<- y[-1,]; print("y done")
  
  
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
    S_BASS_list<- list()
    start.time <- Sys.time()
    for(i in 1:length(mod_list)){
      S_BASS_list[[i]] <- sobol(mod_list[[i]], verbose = FALSE)
    }
    #S_BASS <- sobol(mod, verbose = FALSE)
    end.time <- Sys.time()
    time_sobol <- difftime(end.time,start.time,units = "secs")
    T_BASSSobol<- c(T_BASSSobol,time_sobol)
    
    start.time <- Sys.time()
    Important_indices <- as.numeric(names(S_BASS_list[[1]]$T[1, ]))
    
    # Because we are not using sensobol package here, we need an additional convergence check for the Sobol
    #     analysis. Usually if the emulator's quality is good enough, the sensitivity analysis results should
    #     be stable. We add a convergence check here to make sure the results are reliable. If the results are 
    #     not converged, add the BASS sample size by d.
    
    # If converged, save the emulation time, sensitivity analysis time, sensitivity indices and the sample size
    all_T<- matrix(NA,nrow=tot_steps,ncol=length(Important_indices))
    for(i in 1:length(S_BASS_list)){
      all_T[(cs_steps[i]+1):cs_steps[i+1],]<- as.matrix(S_BASS_list[[i]]$T)
    }
    
    sample_every_T<- round(tot_steps/nwant_T)
    want_T_inds<- round(seq(sample_every_T,tot_steps,length.out=nwant_T))
    
    Sens <- all_T[want_T_inds,c(1:length(Important_indices))]
    Rank <- t(apply(Sens, 1, rank))
    for (boot_ind1 in 1:99){
      T <- boot_ind1
      for (boot_ind2 in (T+1):100){
        Rho <- rep(NA,length(Important_indices))
        Weights <- rep(NA,length(Important_indices))
        for (para_ind in 1:length(Important_indices)){
          Weights[para_ind] <- (max(Sens[boot_ind1,para_ind],max(Sens[boot_ind2,para_ind])))^2
        }
        Weights_sum <- sum(Weights)
        for (para_ind in 1:length(Important_indices)){
          Rho[para_ind] <- abs(Rank[boot_ind1,para_ind]-Rank[boot_ind2,para_ind])*
            Weights[para_ind]/Weights_sum
        }
        if (boot_ind2 == 2){
          Rho_all <- Rho
        } else{
          Rho_all <- append(Rho_all,Rho)
        }
      }
    }
    Rho_all <- matrix(Rho_all, nrow = d)
    Rho_all <- apply(Rho_all, 2, sum)
    
    end.time <- Sys.time()
    time_check <- difftime(end.time,start.time,units = "secs")
    T_check_BASS<- c(T_check_BASS,time_check)
    
    save(T_check_BASS, file = paste0(folder, "/T_check_BASS"))
    save(T_BASSSobol,file = paste0(folder,"/T_BASSSobol"))
    save(S_BASS_list,file = paste0(folder,"/S_BASS_list"))
    
    if (quantile(Rho_all,probs = 0.95, na.rm = TRUE) < 1){
      break
    } else{
      BASS_size <- BASS_size + d
      BASS_size_vec<- c(BASS_size_vec,BASS_size)
    }
    
  }
}

