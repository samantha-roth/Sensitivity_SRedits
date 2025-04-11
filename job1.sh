#!/bin/bash
#SBATCH --job-name=1_Sobol
#SBATCH --output=1_Sobol.%j.out
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=5gb

echo "Job starting on `hostname` at `date`"

cd /dartfs-hpc/rc/home/t/f0071xy/Sensitivity_SRedits_Final

Rscript 1_Sobol.R

echo "Job ending on `hostname` at `date`"
