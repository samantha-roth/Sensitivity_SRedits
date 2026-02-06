#!/bin/bash
#
#SBATCH --job-name=4AKMCS6SR_pt2
#SBATCH --output=4AKMCS6SRpt2_output.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=20GB
#SBATCH --time=144:00:00
#SBATCH --constraint=sc
#SBATCH --account=pches
#SBATCH --partition=sla-prio
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_50,TIME_LIMIT_90
#SBATCH --mail-user=svr5482@psu.edu  

echo "Job starting on `hostname` at `date`"

module load r
cd /storage/group/pches/default/users/svr5482/Sensitivity_paper_revision
Rscript 4_AKMCS6_SR_pt2.R

echo "Job ending on `hostname` at `date`"