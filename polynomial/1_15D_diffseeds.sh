#!/bin/bash
#
#SBATCH --job-name=1_4_diffseeds
#SBATCH --output=1_4_diffseeds_output.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=20GB
#SBATCH --time=72:00:00
#SBATCH --account=pches_cr_default
#SBATCH --partition=himem
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_80,TIME_LIMIT_90
#SBATCH --mail-user=svr5482@psu.edu

echo "Job started on `hostname` at `date`"

module load r
cd /storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/polynomial
Rscript 1_Sobol4_diffseeds.R

echo "Job Ended at `date`"