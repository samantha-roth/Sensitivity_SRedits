# Use a MCMC size determined by how close the total chain mean and the second half of the chain mean are
library(mcmcse)

bass_mcmc_size<- function(x, y, mcmc_init_size, burn_size, nthin, wantESS){
  mod_num<- 1
  mod_list<- list()
  while(1>0){
    #print(paste0("mod_num=",mod_num))
    if(mod_num==1){
      mcmc_size<- mcmc_init_size
      print(paste0("mcmc_size=",mcmc_size, ", nsteps= ",(mcmc_size-burn_size)/nthin))
      start.time <- Sys.time()
      mod <- bass(x, y, nmcmc = mcmc_size, nburn = burn_size, thin = nthin,verbose = FALSE) # fit BASS model
      end.time <- Sys.time()
      fit_time <- difftime(end.time,start.time, units = "secs")
      tot_fit_time<- fit_time
    }
    if(mod_num>1){
      mcmc_size<- ceiling((1.5*wantESS*(mcmc_size/mESS)-mcmc_size)/n_empars)*n_empars
      print(paste0("mcmc_size=",mcmc_size, ", nsteps= ",(mcmc_size-burn_size)/nthin))
      start.time <- Sys.time()
      mod <- bass(x, y, nmcmc = mcmc_size, nburn = burn_size, thin = nthin,
                  curr.list= mod$curr.list,verbose = FALSE) # fit BASS model
      end.time <- Sys.time()
      fit_time <- difftime(end.time,start.time, units = "secs")
      tot_fit_time<- tot_fit_time+fit_time
    }
    
    mod_list[[mod_num]]<- mod
    #get the total number of steps from all models fit so far
    mod_nsteps<- unlist(lapply(mod_list, function(x) length(x$s2)))
    tot_steps<- sum(mod_nsteps)
    #get a cumulative sum of the number of steps for each model
    cs_steps<- c(0,cumsum(mod_nsteps))
    
    all_beta<- matrix(NA,nrow=tot_steps,ncol=ncol(mod_list[[1]]$beta))
    all_s2<- rep(NA,tot_steps)
    all_lam<- rep(NA,tot_steps)
    all_nbasis<- rep(NA,tot_steps)
    mod_inds<- rep(NA,tot_steps)
    
    for(i in 1:length(mod_list)){
      all_beta[(cs_steps[i]+1):cs_steps[i+1],]<- mod_list[[i]]$beta
      all_s2[(cs_steps[i]+1):cs_steps[i+1]]<- mod_list[[i]]$s2
      all_lam[(cs_steps[i]+1):cs_steps[i+1]]<- mod_list[[i]]$lam
      all_nbasis[(cs_steps[i]+1):cs_steps[i+1]]<- mod_list[[i]]$nbasis
      mod_inds[(cs_steps[i]+1):cs_steps[i+1]]<- i
    }
    
    
    beta_lengths<- apply(all_beta,2,function(x) length(na.omit(x)))
    good_beta_inds<- which(beta_lengths==length(all_s2))
    
    par_chain<-cbind(all_s2,all_lam,all_nbasis,all_beta[,good_beta_inds])
    
    mESS<- as.numeric(multiESS(par_chain))
    print(paste0("mESS=", mESS))
    #print(paste0("length(mESS)=",length(mESS)))
    mESS_good<- mESS>wantESS
    
    if(mESS_good) break
    mod_num<- mod_num+1
  }
  output<- list(mod_list,par_chain,mESS,tot_fit_time,tot_steps,cs_steps,good_beta_inds)
  return(output)
}