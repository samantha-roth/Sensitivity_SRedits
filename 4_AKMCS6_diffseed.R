# Sobol based on the Adaptive Kriging combined with Monte Carlo Sampling (AKMCS) method
# Note: This script also takes an extremely long time when dealing with high-dimensional
#       models. Again change the dimension vector D for code replication check. 

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

source("0_library.R")

print("4_AKMCS6.R")

# Define the test model in each dimension, apply AKMCS and perform the Sobol analysis
#for (k in 1:6){
k=6
# model dimension
d <- D[k]

set.seed(8)

folder<-paste(folderpath,d,"D/AKMCS",sep="")
if (Testmodel_ind==2){
  folder <- paste(folderpath,"Hymod/AKMCS",sep="") 
}
if (Testmodel_ind==3){
  folder <- paste(folderpath,"SacSma/AKMCS",sep="") 
}
if (!dir.exists(folder)){
  dir.create(folder, recursive = TRUE)
}

# Start recording the time from AKMCS initial state
# AKMCS also begins with 20,000 training samples
start.time <- Sys.time()
candidate_size <- 20000
X <- randomLHS(candidate_size,d)

#Y <- apply(X,1,Testmodel)

# Save these training samples
#save(X,file = paste(folder,"/initial_sample",sep=""))

# Begin with 12 random samples from these training samples
n_init <- 10 + d
indx <- sample(candidate_size,n_init)

# Update the used samples and remaining samples
x <- X[indx, ]
x_rest <- X[-indx, ]
#y_rest <- apply(x_rest,1,Testmodel)

rows<- 1:nrow(X)
rows_rest<- rows[-indx]

# Evaluate model outputs and fit a Kriging model
if (Testmodel_ind >= 2){
  y <- apply(Mapping(x,Range) ,1,Testmodel)      
} else {
  y <- apply(x,1,Testmodel)
}

GPmodel <- GP_fit(x, y)
a <- predict(GPmodel,x_rest)

# U is the learning function, which is simply the standard error here
U <- sqrt(a$MSE)
print(paste("sample size =",dim(x)[1], "max(U) =",max(U),"range = ",(max(a$Y_hat)-min(a$Y_hat))/20,sep=" "))

# End the loop if the stopping criterion is fulfilled
# Stopping criterion: all the remaining samples have standard errors larger than 1
# If the criterion is not reached, pick the next sample adaptively based on the learning function
if (max(U)>(max(a$Y_hat)-min(a$Y_hat))/20){
  while (1>0){
    # Find which sample has the largest standard error
    m <- which(U==max(U))
    if (length(m)>1){
      m <- sample(m,1)
    }
    
    # Add that sample and update the remaining samples
    x_add <- x_rest[m, ]
    x_rest <- x_rest[-m, ]
    rows_rest<- rows_rest[-m]
    # Evaluate the output of that sample and update
    if (Testmodel_ind >= 2){
      y_add <- Testmodel(Mapping(t(as.matrix(x_add)),Range))      
    } else {
      y_add <- Testmodel(x_add)
    }
    
    y <- append(y,y_add)
    x <- rbind(x,x_add)
    indx<- append(indx,m)
    
    # Fit the Kriging model again
    GPmodel <- GP_fit(x, y)
    a <- predict(GPmodel,x_rest)
    
    # Get the learning function again
    U <- sqrt(a$MSE)
    print(paste("sample size =",dim(x)[1], "max(U) =",max(U),"range = ",(max(a$Y_hat)-min(a$Y_hat))/20,sep=" "))
    
    # Then record the total used time
    end.time <- Sys.time()
    time.taken <- difftime(end.time,start.time,units = "secs")
    T_AKMCS <- as.numeric(time.taken)
    save(T_AKMCS,file = paste(folder,"/T_AKMCS_diffseed",sep=""))
    save(x,file = paste(folder,"/x_diffseed",sep=""))
    save(a,file = paste(folder,"/a_diffseed",sep=""))
    save(rows_rest,file=paste0(folder,"/rows_rest_diffseed"))
    #save(y_rest,file = paste(folder,"/y_rest",sep=""))
    
    # End the loop if the stopping criterion is fulfilled
    if (max(U)<(max(a$Y_hat)-min(a$Y_hat))/20){
      break
    }
  }
}


# Next perform the sensitivity analysis, and again directly get the convergence size of standard Sobol
if (Testmodel_ind == 1){
  load(paste(folderpath,"Sobol_convergencesize",sep = ""))
}
if (Testmodel_ind == 2){
  load(paste(folderpath,"/Hymod/Sobol_convergencesize",sep = ""))
}
if (Testmodel_ind == 3){
  load(paste(folderpath,"/SacSma/Sobol_convergencesize",sep = ""))
}
N <- floor(Sobol_convergesize[k]/(d+2+d*(d-1)/2))

# Time for sensitivity analysis
start.time <- Sys.time()
mat <- sobol_matrices(N = N, params = as.character(c(1:d)), order = "second")
if (Testmodel_ind>2){
  mat <- Mapping(mat,Range)
}
Y_S <- Kriging(mat)
S_AKMCS <- sobol_indices(Y=Y_S,N=N,params = as.character(c(1:d)),
                         boot=TRUE,R=100,order="second")
end.time<-Sys.time()
T_AKMCSSobol<-difftime(end.time,start.time,units = "secs")

# Save the time and sensitivity indices
save(T_AKMCSSobol,file = paste(folder,"/T_AKMCSSobol_diffseed",sep=""))
save(S_AKMCS,file=paste(folder,"/S_AKMCS_diffseed",sep=""))
#}