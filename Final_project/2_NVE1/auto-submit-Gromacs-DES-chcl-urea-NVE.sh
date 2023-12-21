#!/bin/bash  
#SBATCH --nodes=1
#SBATCH -c 28
#SBATCH --mem=5gb
#SBATCH --job-name="npt1"
#SBATCH --mail-type=END  
##SBATCH --mail-user=xz3067@nyu.edu
#SBATCH --output=MYOUTPUT.%j.stdout 
##SBATCH --error=MYOUTPUT.%j.stderr 
#SBATCH --time=7-00:00:00
#SBATCH --partition=argon
#SBATCH --constraint=g6132

# This is the MD preparation for pure system
module purge
export MODULEPATH=$MODULEPATH:/gpfsnyu/modules/
module load gromacs/2016.5
export RUNDIR=$(pwd)
TEMPDIR=/tmp/${SLURM_JOB_USER}_${SLURM_JOB_ID}
mkdir -p $TEMPDIR
cd $TEMPDIR
TT=T315

cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/choline_cl_urea.top . 
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/nve.mdp . 

cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/2_NVE1/${TT}/nvt.gro .

gmx grompp -f nve.mdp -c nvt.gro -p choline_cl_urea.top -o nve.tpr
gmx mdrun -pin on -ntmpi 1 -ntomp 28 -deffnm nve

cp nve.xtc /gpfsnyu/xspace/projects/DES/ChCl_Urea/2_NVE1/${TT}
cp nve.tpr /gpfsnyu/xspace/projects/DES/ChCl_Urea/2_NVE1/${TT}
rm -rf $TEMPDIR
                 