#!/bin/bash
#
#SBATCH --job-name=4_6_node3
#SBATCH --output=4_6_node3_output.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=20GB
#SBATCH --time=144:00:00
#SBATCH --account=pches_cr_default
#SBATCH --partition=himem
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_90

echo "Job started on `hostname` at `date`"

module load r
cd /storage/group/pches/default/users/svr5482/Sensitivity_paper_revision/polynomial
Rscript 4_AKMCS6_node3.R

echo "Job Ended at `date`"