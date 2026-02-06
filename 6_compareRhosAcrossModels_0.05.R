#compare traditional Rho values across methods
#considering only parameters with total sensitivities >0.05
#results don't really change

# Remove all existing environment and plots
rm(list = ls())
graphics.off()

setwd("/storage/group/pches/default/users/svr5482/Sensitivity_paper_revision")

tested_D_num <- c(2,5,10,15,20,30)
tested_D <- c("2D","5D","10D","15D","20D","30D")
tested_M <- c("AKMCS","BASS","Kriging")

##############################################################################
#Sobol's G function

source("0_library.R")

folder <- paste0("./Ranking_Data/")

load(paste0(folder,"all_Rho_AKMCS_0.05"))
load(paste0(folder,"all_Rho_BASS_0.05"))
load(paste0(folder,"all_Rho_Kriging_0.05"))

all_Rho_AKMCS_G<- all_Rho_AKMCS; rm(all_Rho_AKMCS)
all_Rho_BASS_G<- all_Rho_BASS; rm(all_Rho_BASS)
all_Rho_Kriging_G<- all_Rho_Kriging; rm(all_Rho_Kriging)

##############################################################################
#Polynomial

folder <- paste0("./polynomial/Ranking_Data/")

load(paste0(folder,"all_Rho_AKMCS_0.05"))
load(paste0(folder,"all_Rho_BASS_0.05"))
load(paste0(folder,"all_Rho_Kriging_0.05"))

all_Rho_AKMCS_Poly<- all_Rho_AKMCS; rm(all_Rho_AKMCS)
all_Rho_BASS_Poly<- all_Rho_BASS; rm(all_Rho_BASS)
all_Rho_Kriging_Poly<- all_Rho_Kriging; rm(all_Rho_Kriging)

##############################################################################
#SACSMA10
source("0_librarySACSMA10par.R")

folder <- paste0("./Ranking_Data/SacSma10")

load(paste0(folder,"all_Rho_AKMCS_0.05"))
load(paste0(folder,"all_Rho_BASS_0.05"))
load(paste0(folder,"all_Rho_Kriging_0.05"))

all_Rho_AKMCS_SACSMA10<- all_Rho_AKMCS; rm(all_Rho_AKMCS)
all_Rho_BASS_SACSMA10<- all_Rho_BASS; rm(all_Rho_BASS)
all_Rho_Kriging_SACSMA10<- all_Rho_Kriging; rm(all_Rho_Kriging)

##############################################################################
#Hymod

source("0_libraryHymod.R")

folder <- paste0("./Ranking_Data/Hymod")

load(paste0(folder,"all_Rho_AKMCS_0.05"))
load(paste0(folder,"all_Rho_BASS_0.05"))
load(paste0(folder,"all_Rho_Kriging_0.05"))

all_Rho_AKMCS_Hymod<- all_Rho_AKMCS; rm(all_Rho_AKMCS)
all_Rho_BASS_Hymod<- all_Rho_BASS; rm(all_Rho_BASS)
all_Rho_Kriging_Hymod<- all_Rho_Kriging; rm(all_Rho_Kriging)

##############################################################################

#consider 2D first-- all 0's
print(paste0("G AKMCS max: ",max(all_Rho_AKMCS_G[,1])))
print(paste0("G BASS max: ",max(all_Rho_BASS_G[,1])))
print(paste0("G Kriging max: ",max(all_Rho_Kriging_G[,1])))

print(paste0("Poly AKMCS max: ",max(all_Rho_AKMCS_Poly[,1])))
print(paste0("Poly BASS max: ",max(all_Rho_BASS_Poly[,1])))
print(paste0("Poly Kriging max: ",max(all_Rho_Kriging_Poly[,1])))

##############################################################################

#consider 5D
print(paste0("G AKMCS max: ",max(all_Rho_AKMCS_G[,2])))
print(paste0("G BASS max: ",max(all_Rho_BASS_G[,2])))
print(paste0("G Kriging max: ",max(all_Rho_Kriging_G[,2])))

print(paste0("Poly AKMCS max: ",max(all_Rho_AKMCS_Poly[,2])))
print(paste0("Poly BASS max: ",max(all_Rho_BASS_Poly[,2])))
print(paste0("Poly Kriging max: ",max(all_Rho_Kriging_Poly[,2])))

print(paste0("Hymod AKMCS max: ",max(all_Rho_AKMCS_Hymod)))
print(paste0("Hymod BASS max: ",max(all_Rho_BASS_Hymod)))
print(paste0("Hymod Kriging max: ",max(all_Rho_Kriging_Hymod)))

#no approach has value >0.18 for the G function and polynomial
#However, the values for Hymod were all between 2 and 3
#Model structure influences the performance of emulation approaches to Sobol' 
#AKMCS was highest (worst) for 2/3 but not by much, BASS highest for 1/3
##############################################################################

#consider 10D
print(paste0("G AKMCS max: ",max(all_Rho_AKMCS_G[,3])))
print(paste0("G BASS max: ",max(all_Rho_BASS_G[,3])))
print(paste0("G Kriging max: ",max(all_Rho_Kriging_G[,3])))

print(paste0("Poly AKMCS max: ",max(all_Rho_AKMCS_Poly[,3])))
print(paste0("Poly BASS max: ",max(all_Rho_BASS_Poly[,3])))
print(paste0("Poly Kriging max: ",max(all_Rho_Kriging_Poly[,3])))

print(paste0("SACSMA10 AKMCS max: ",max(all_Rho_AKMCS_SACSMA10)))
print(paste0("SACSMA10 BASS max: ",max(all_Rho_BASS_SACSMA10)))
print(paste0("SACSMA10 Kriging max: ",max(all_Rho_Kriging_SACSMA10)))

#SACSMA was much easier for the emulation-based approaches to approximate, had much smaller values
#AKMCS was worst for 2/3, BASS was worst for 1/3
#for no model was the value > .7
##############################################################################

#consider 15D
print(paste0("G AKMCS max: ",max(all_Rho_AKMCS_G[,4])))
print(paste0("G BASS max: ",max(all_Rho_BASS_G[,4])))
print(paste0("G Kriging max: ",max(all_Rho_Kriging_G[,4])))

print(paste0("Poly AKMCS max: ",max(all_Rho_AKMCS_Poly[,4])))
print(paste0("Poly BASS max: ",max(all_Rho_BASS_Poly[,4])))
print(paste0("Poly Kriging max: ",max(all_Rho_Kriging_Poly[,4])))

#no consistent best or worst. all < 1
#BASS worst once. AKMS worst once
##############################################################################

#consider 20D
print(paste0("G AKMCS max: ",max(all_Rho_AKMCS_G[,5])))
print(paste0("G BASS max: ",max(all_Rho_BASS_G[,5])))
print(paste0("G Kriging max: ",max(all_Rho_Kriging_G[,5])))

print(paste0("Poly AKMCS max: ",max(all_Rho_AKMCS_Poly[,5])))
print(paste0("Poly BASS max: ",max(all_Rho_BASS_Poly[,5])))
print(paste0("Poly Kriging max: ",max(all_Rho_Kriging_Poly[,5])))

#For both: AKMCS by far the worst, BASS in middle, Kriging best
#Kriging only one that isn't >1 for G func
##############################################################################

#consider 30D

print(paste0("Poly AKMCS max: ",max(all_Rho_AKMCS_Poly[,6])))
print(paste0("Poly BASS max: ",max(all_Rho_BASS_Poly[,6])))
print(paste0("Poly Kriging max: ",max(all_Rho_Kriging_Poly[,6])))

#AKMCS by far the worst, BASS and Kriging about the same
