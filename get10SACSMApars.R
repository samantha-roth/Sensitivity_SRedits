#select a parameter to leave out from the SACSMA model
rm(list=ls())

n_fix<- 3
n_total<-13

set.seed(41)

pars_fix<- sample(1:n_total,n_fix)

pars_fix<- sort(pars_fix)

save(pars_fix,file="SACSMA_pars_fix")