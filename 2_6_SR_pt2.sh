#!/bin/bash
#
#SBATCH --job-name=2_6_SR_pt2
#SBATCH --output=2_6_SR_pt2_output.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40GB
#SBATCH --time=120:00:00
#SBATCH --constraint=sc
#SBATCH --account=pches
#SBATCH --partition=sla-prio
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_80,TIME_LIMIT_90
#SBATCH --mail-user=svr5482@psu.edu

echo "Job started on `hostname` at `date`"

module load r
cd /storage/group/pches/default/users/svr5482/Sensitivity_paper_revision
Rscript 2_Kriging6_SR_pt2.R

echo "Job Ended at `date`"