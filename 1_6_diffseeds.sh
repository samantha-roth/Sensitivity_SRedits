#!/bin/bash
#
#SBATCH --job-name=1_6_diffseeds
#SBATCH --output=1_6_diffseeds_output.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5
#SBATCH --mem=30GB
#SBATCH --time=144:00:00
#SBATCH --constraint=sc
#SBATCH --account=pches
#SBATCH --partition=sla-prio
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_80,TIME_LIMIT_90
#SBATCH --mail-user=svr5482@psu.edu

echo "Job started on `hostname` at `date`"

module load r
cd /storage/group/pches/default/users/svr5482/Sensitivity_paper_revision
Rscript 1_Sobol6_diffseeds.R

echo "Job Ended at `date`"