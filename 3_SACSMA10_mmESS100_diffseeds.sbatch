#!/bin/bash
#
#SBATCH --job-name=3_SACSMA10_mmESS100_diffseeds
#SBATCH --output=3_SACSMA10_mmESS100_diffseeds_output.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5
#SBATCH --mem=120GB
#SBATCH --time=120:00:00
#SBATCH --account=pches_cr_default
#SBATCH --partition=himem
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_90
#SBATCH --mail-user=svr5482@psu.edu

echo "Job started on `hostname` at `date`"

# Don't forget where we live

cd $SLURM_SUBMIT_DIR
# cd /storage/group/pches/default/users/svr5482/Sensitivity_paper_revision

########################################
# User input section:
# Start setting important variables
########################################

#
# Top-level PCHES directory that contains the required container files
#

export PCHES_GROUP_DIR=/storage/group/pches/default

#
# Scratch directory for hosting the container
# Do not use /scratch as the file age limit killer
# will wipe out the container
#

export PCHES_SCRATCH=/tmp

# SIF file to use

SIF_FILE="$PCHES_GROUP_DIR/sw/common/SIF/ubuntu_22.04_2024_02_modified_v4.sif"

# Directory to build/use SIF container image

SIF_IMAGE_DIR="$PCHES_SCRATCH/ubuntu_22.04_2024_02"

########################################
# Begin sanity checks
########################################

# Make sure our home base PCHES_GROUP_DIR exists, otherwise we're unable to run

if [[ ! -d $PCHES_GROUP_DIR ]]
then
echo "Master directory $PCHES_GROUP_DIR not found, unable to continue"
exit 249
fi

# Check if SIF file exists

if [ ! -f $SIF_FILE ]
then
echo "SIF File $SIF_FILE does not exist, unable to continue"
exit 2
fi

########################################
# End of user input, setup, and checks.
########################################

########################################
# Start up our singularity instance.
########################################

#
# Create an instance id based on numeric portion of SLURM job id
#

instance_id=` echo $SLURM_JOBID `

#
# Name our instance based on the instance id
#

current_instance="pches_instance_$instance_id"

#
# Export the instance name so other scripts can use it
#

export PCHES_SINGULARITY_INSTANCE=$current_instance

# Build the container image

echo " "
echo "**********************************************************************"
echo "*"
echo "* INFO:  Building Apptainer (Singularity) Container"
echo "*"
echo "*    Container instance name is $SIF_IMAGE_DIR"
echo "* "

singularity build --sandbox --force $SIF_IMAGE_DIR $SIF_FILE
local_rc=$?
  
  if [[ $local_rc == 0 ]]
then
echo "Singularity build successful `hostname`"
echo " "
else
  echo "Singularity build failed on `hostname` with code $local_rc. Exiting"
exit $local_rc
fi

if [ ! -d $SIF_IMAGE_DIR ]
then
echo "SIF Directory $SIF_IMAGE_DIR does not exist, unable to continue"
exit 2
fi

echo "*"
echo "**********************************************************************"

echo " "
echo "**********************************************************************"
echo "*"
echo "* INFO:  Starting Apptainer (Singularity) Container"
echo "*"
echo "*    Singularity instance name is $current_instance"
echo "* "
singularity instance start  \
$SIF_IMAGE_DIR \
$current_instance
local_rc=$?
  
  if [[ $local_rc == 0 ]]
then
echo "*  Singularity instance $current_instance started on `hostname`"
echo " "
else
  echo "*  Singularity instance $current_instance failed on `hostname` with code $local_rc. Exiting"
exit $local_rc
fi

echo "*"
echo "**********************************************************************"

########################################
# After the container starts, call the R script
########################################

# Now run the R script "Rscript 3_BASS_propmean.R"

singularity exec instance://$PCHES_SINGULARITY_INSTANCE sh -c "Rscript -e \"source('3_SACSMA10_mmESS100_diffseeds.R')\""
local_rc=$?
  
  echo " "
echo "**********************************************************************"
echo "*"
echo "* INFO: R runs completed with exit code $local_rc"
echo "*"
echo "**********************************************************************"

########################################
# Shut down our singularity instance.
########################################

echo " "
echo "**********************************************************************"
echo "*"
echo "* INFO: Shutting down container $PCHES_SINGULARITY_INSTANCE"
echo "*"

singularity instance stop $current_instance
local_rc=$?
  
  if [[ $local_rc == 0 ]]
then
echo "*  Instance $current_instance shutdown on host `hostname`"
echo "* "
else
  echo "*  ERROR: Instance $current_instance shutdown failed with code $local_rc."
echo "*  You may need to manually check host `hostname` to delete the instance"
echo "* "
fi

echo "**********************************************************************"
echo " "

echo "Job Ended at `date`"