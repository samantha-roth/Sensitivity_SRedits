#!/bin/bash
#
#SBATCH --job-name=1SACSMA10
#SBATCH --output=1SACSMA10_output.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10GB
#SBATCH --time=48:00:00
#SBATCH --account=pches_cr_default
#SBATCH --partition=standard
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_80,TIME_LIMIT_90
#SBATCH --mail-user=svr5482@psu.edu

echo "Job started on `hostname` at `date`"

module load r
cd /storage/group/pches/default/users/svr5482/Sensitivity_paper_revision
Rscript 1_SobolSACSMA10.R

echo "Job Ended at `date`"