# This script prepares the required data of Figure 5 in the paper
# Show the sensitivity indices's ranking's convergence

# Remove all existing environment and plots
rm(list = ls())
graphics.off()
source("0_library.R")

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

# Plot the results in the example of 5D problem
d<-5
folder<-paste("./Ranking_Data/",d,"D/Traceplot_rank",sep="")

# Test model in 5D
Testmodel<-function (X) {
  a = rep(NA,d)
  for (i in 1:d){
    a[i] <- i
  }
  
  up <- abs(4*X-2) + a
  down <- 1 + a
  prod <- prod(up/down)
  
  return(prod)
}


# Sizes used for Sobol trace plot
# Standard Sobol's results do not vary by random seeds, other methods' results do. 
Size_S <- c(seq(40,1000,by=40),seq(1000,5000,by=1000))
T_S <- matrix(NA, nrow=5,ncol=length(Size_S))


# Sizes used for Kriging traceplot
# 5 different seeds for the emulation methods
Size_K <- c(5:10,seq(12,100,by=2))

# Total-order indices
T_K <- matrix(NA,nrow=5,ncol=length(Size_K))

# Sizes used for AKMCS traceplot
Size_A <- c(3:100)
T_A <- matrix(NA,nrow=5,ncol=length(Size_A))

# Sizes used for BASS traceplot
Size_B <- c(5:10,seq(12,100,by=2))
T_B <- matrix(NA,nrow=5,ncol=length(Size_B))

# Test for 5 seeds for the emulation methods
set.seed(1)

# AKMCS records the results after each step
# 20,000 training points
candidate_size <- 20000
X <- randomLHS(candidate_size,d)
# Begin with 15 initial samples
n_init <- 15
indx <- sample(candidate_size,n_init)
x <- X[indx, ]
x_rest <- X[-indx, ]
# Evaluate their outputs, fit a Kriging model
y <- apply(x,1,Testmodel)
GPmodel <- GP_fit(x, y)
a<-predict(GPmodel,x_rest)
# Learning function
U<-sqrt(a$MSE)
# Take the next sample adaptively, repeat these steps
for (i in 1:length(Size_A)){
  k<-which(U==max(U))
  if (length(k)>1){
    k <- sample(k,1)
  }
  x_add<-x_rest[k, ]
  x_rest<-x_rest[-k, ]
  y_add<-Testmodel(x_add)
  y <- append(y,y_add)
  x <- rbind(x,x_add)
  GPmodel <- GP_fit(x, y)
  a<-predict(GPmodel,x_rest)
  U<-sqrt(a$MSE)
  
  # Save the sensitivity analysis results
  mat <- sobol_matrices(N = 1000, params = as.character(c(1:d)), order = "second")
  Y_A <- Kriging(mat)
  S <- sobol_indices(Y = Y_A, N = 1000, params = as.character(c(1:d)),
                     boot = TRUE, R = 100, order = "second")
  T_A[ ,i] <- S$results$original[6:10]
}
save(T_A,file = paste(folder,"/T_A",sep=""))
