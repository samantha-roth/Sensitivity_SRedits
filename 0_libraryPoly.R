# This script records all the global variables, functions and libraries

#The working folder with scripts and data
# testing
setwd("/Users/jeremywang/Documents/GitHub/Sensitivity_SRedits_Final")

# Load the required functions and packages
source("sobol_indices_boot.R")
#source("sib_simplified.R")
library(GPfit)
library(lhs)
library(BASS)

# The dimensions we consider
D <- c(2,5,10,15,20,30)

# The list of sample sizes we consider
tot_size <- c(seq(100,1000,by=100),seq(1250,5e3,by=250),seq(6e3,5e4,by=1e3), #original
              seq(5.2e4,1.5e5,by=2.5e3),seq(1.55e5,3e5,by=5e3),
              seq(3e5,5e5,by=1e4))

# The root folder that saves all the data during code running
folderpath <- "./Ranking_Data/"

# Choose the test model, the number can only be 1 (G function), 2 (Hymod) or 3 (Sacsma)
Testmodel_ind <- 0

# Test comment

if (Testmodel_ind == 0) {# polynomial function
  Testmodel<-function (X) {
    S = 0
    ## d is a numerical value selected from numeric D
    for (i in 1:d){
      if (i%%3==1){
        a = i
        b = X[i]
      } else if (i%%3==2){
        a = i
        b = X[i]^2*X[i-1]
      } else {
        a = i
        b = X[i]
      }
      S = S + a*b
    }
    return(S)
  }
}


if (Testmodel_ind == 1){ # G function
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
}

if (Testmodel_ind == 2){ # Hymod
  source("Hymod.R")
  load("arnosubbiano.rda")
  
  Testmodel <- hymodr
  D <- 5
  
  ## Catchment area [km^2]
  area<-751  
  
  ## Precipitation [mm/day]
  precipit<-arnosubbiano[ ,2]
  
  ## Potential arnosubbiano [mm/day]
  evapo<-arnosubbiano[ ,3]
  
  ## Q observation
  Q_obs <- arnosubbiano[ ,4]
  
  Range <- matrix(data = c(70,400,0,0.95,0,0.9,0,0.1,0.1,1),nrow = 2,ncol = 5,byrow = FALSE)
  
}

if (Testmodel_ind == 3){ # SacSma
  source("sacSma.R")
  load("SacSma_dataframe")
  Testmodel <- sacSma
  D <- 16
  
  ## Precipitation [mm/day]
  precipit<-SacSma_dataframe$precipit
  
  ## Potential arnosubbiano [mm/day]
  evapo<-SacSma_dataframe$evapo
  
  ## Q observation
  Q_obs <- SacSma_dataframe$Q_obs
  
  Range <- matrix(data = c(5,300,5,150,10,700,100,1200,
                           5,500,0.1,0.75,0.001,0.05,0.01,0.6,
                           5,350,1,5,0,0.9,0,0.1,
                           0,0.4,0.3,0.3,0,0,0,0),nrow = 2,ncol = 16,byrow = FALSE)
  known_pars<- c(0.3,0,0)
}

# A function that maps [0,1] to any input range
Mapping <- function (X, Range){ 
  # Range is a matrix with 2 rows (min and max)
  if (dim(Range)[2]!=dim(X)[2]){
    return("The input dimensions must match")
  }
  for (i in 1:dim(X)[2]){
    X[ ,i] <- Range[1,i] + X[ ,i]*(Range[2,i]-Range[1,i])
  }
  return(X)
}


#Kriging function, used when calling the emulator in the Sobol analysis
Kriging <- function (X){
  a <- predict(GPmodel,X)
  a$Y_hat
}

nboot=100