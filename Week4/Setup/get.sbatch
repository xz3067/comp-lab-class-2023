#!/bin/bash
#SBATCH --job-name="2Water_Amber"
#SBATCH --nodes=1
#SBATCH --tasks-per-node=20
#SBATCH --mem=8GB
#SBATCH --time=7-00:00:00

module purge
module load gromacs/openmpi/intel/2020.4

gmx_mpi trjcat -f step5_1.xtc step5_2.xtc step5_3.xtc step5_4.xtc step5_5.xtc step5_6.xtc step5_7.xtc step5_7.xtc step5_8.xtc step5_9.xtc -o con9.xtc

gmx_mpi trjconv -f con9.xtc -s step5_9.tpr -o unwrapped.xtc -pbc nojump

