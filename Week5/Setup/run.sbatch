#!/bin/bash
#SBATCH --job-name=week5
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=10:00:00
#SBATCH --mem=2GB
#SBATCH --output=Week5_T300.out

module purge
module load gromacs/openmpi/intel/2018.3

gmx_mpi grompp -f ./Inputs/adp_T300.mdp -c ./Inputs/adp.gro -p ./Inputs/adp.top -o ./Data/T300/adp_md.tpr 
gmx_mpi mdrun -v -deffnm ./Data/T300/adp_md

#gmx_mpi grompp -f ./Inputs/adp_T363.mdp -c ./Inputs/adp.gro -p ./Inputs/adp.top -o ./Data/T363/adp_md.tpr 
#gmx_mpi mdrun -v -deffnm ./Data/T363/adp_md

#gmx_mpi grompp -f ./Inputs/adp_T440.mdp -c ./Inputs/adp.gro -p ./Inputs/adp.top -o ./Data/T440/adp_md.tpr 
#gmx_mpi mdrun -v -deffnm ./Data/T440/adp_md