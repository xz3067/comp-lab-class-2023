#!/bin/bash
#SBATCH --job-name=week6
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=1:00:00
#SBATCH --mem=1GB
#SBATCH --output=Week6_mdrun.out

module purge
module load gromacs/openmpi/intel/2020.4
source /scratch/work/courses/CHEM-GA-2671-2023fa/software/gromacs-2019.6-plumedSept2020/bin/GMXRC.bash.modules
mpirun gmx_mpi mdrun -s ../../Inputs/topolA.tpr -nsteps 5000000 -plumed plumed.dat
#plumed sum_hills --hills HILLS --stride 100 --mintozero
