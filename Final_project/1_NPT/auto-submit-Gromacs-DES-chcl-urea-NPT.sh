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
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/choline_cl_urea.gro . 
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/choline_cl_urea.top . 
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/min1.mdp . 
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/min2.mdp . 
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/heat.mdp .
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/npt.mdp . 
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/nvt.mdp . 
cp -ri /gpfsnyu/xspace/projects/DES/ChCl_Urea/0_MD_prep/nve.mdp . 
 
gmx grompp  -f min1.mdp -c choline_cl_urea.gro -p choline_cl_urea.top -o min1.tpr
gmx mdrun -pin on -ntmpi 1 -ntomp 28 -deffnm min1
cp min1.edr /gpfsnyu/xspace/projects/DES/ChCl_Urea/1_NPT/${TT}

gmx grompp -f min2.mdp -c min1.gro -p choline_cl_urea.top -o min2.tpr
gmx mdrun -pin on -ntmpi 1 -ntomp 28 -deffnm min2
cp min2.edr /gpfsnyu/xspace/projects/DES/ChCl_Urea/1_NPT/${TT}

gmx grompp -f heat.mdp -c min2.gro -p choline_cl_urea.top -o heat.tpr
gmx mdrun -pin on -ntmpi 1 -ntomp 28 -deffnm heat
cp heat.edr /gpfsnyu/xspace/projects/DES/ChCl_Urea/1_NPT/${TT}

gmx grompp -f npt.mdp -c heat.gro -p choline_cl_urea.top -o npt.tpr
gmx mdrun -pin on -ntmpi 1 -ntomp 28 -deffnm npt
cp npt.edr /gpfsnyu/xspace/projects/DES/ChCl_Urea/1_NPT/${TT}
cp npt.gro /gpfsnyu/xspace/projects/DES/ChCl_Urea/1_NPT/${TT}
rm -rf $TEMPDIR
                 