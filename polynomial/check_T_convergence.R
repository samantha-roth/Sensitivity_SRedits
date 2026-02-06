check_T_convergence<- function(mod_list, burn_size, nthin, nwant_T){
  mod_num<- length(mod_list)
  iter=1
  while(1>0){
    
    S_BASS_list<- list()
    start.time <- Sys.time()
    
    for(i in 1:length(mod_list)){
      mod_i<- mod_list[[i]]
      
      valid_inds<- which(mod_i$model.lookup>0)
      
      S_BASS_list[[i]] <- sobol(mod_i, mcmc.use= valid_inds, verbose = FALSE)
    }
    
    end.time <- Sys.time()
    time_sobol <- difftime(end.time,start.time,units = "secs")
    T_BASSSobol<- c(T_BASSSobol,time_sobol)
    
    start.time <- Sys.time()
    Important_indices <- as.numeric(names(S_BASS_list[[1]]$T[1, ]))
    
    SBASS_nsteps<- unlist(lapply(S_BASS_list, function(x) nrow(x$T)))
    #get a cumulative sum of the number of steps for each model
    cs_steps_SBASS<- c(0,cumsum(SBASS_nsteps))
    tot_steps_SBASS<- sum(SBASS_nsteps)
    
    # If converged, save the emulation time, sensitivity analysis time, sensitivity indices and the sample size
    all_T<- matrix(NA,nrow=tot_steps_SBASS,ncol=length(Important_indices))
    #print(paste0("ncol(all_T)=",length(Important_indices)))
    for(i in 1:length(S_BASS_list)){
      #print(paste0("i=",i))
      
      T_i<- as.matrix(S_BASS_list[[i]]$T)
      #print(paste0("nrow(T_i)=",nrow(T_i)))
      #print(paste0("ncol(T_i)=",ncol(T_i)))
      #print(paste0("nrow(all_T[(cs_steps_SBASS[i]+1):cs_steps_SBASS[i+1],])=",cs_steps_SBASS[i+1]-cs_steps_SBASS[i]))
      
      all_T[(cs_steps_SBASS[i]+1):cs_steps_SBASS[i+1],]<- T_i
    }
    
    sample_every_T<- round(tot_steps_SBASS/nwant_T)
    want_T_inds<- round(seq(sample_every_T,tot_steps_SBASS,length.out=nwant_T))
    
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
    
    q95<- quantile(Rho_all,probs = 0.95, na.rm = TRUE)
    
    print(paste0("q95: ",q95))
    # return(q95,T_check_BASS,T_BASSSobol,S_BASS_list)
    
    if (q95< 1){
      break
    } else{
      if(iter==1) tot_fit_time<-0
      print(paste0("Need more steps"))
      mcmc_size<- n_empars*(1+1e3)
      print(paste0("mcmc_size=",mcmc_size, ", nsteps= ",(mcmc_size-burn_size)/nthin))
      start.time <- Sys.time()
      mod <- bass(X_01, Y, nmcmc = mcmc_size, nburn = burn_size, thin = nthin,
                  curr.list= mod$curr.list,verbose = FALSE) # fit BASS model
      end.time <- Sys.time()
      fit_time <- difftime(end.time,start.time, units = "secs")
      tot_fit_time<- tot_fit_time+fit_time
      
      mod_list[[mod_num+iter]]<- mod
      
      iter<- iter+1
    }
    
  }
  out<- list(mod_list,S_BASS_list,T_BASSSobol,T_check_BASS)
  return(out)
  
}
