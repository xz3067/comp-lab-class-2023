#!/bin/bash
#SBATCH --job-name=run-gromacs
#SBATCH --nodes=1
#SBATCH --tasks-per-node=4
#SBATCH --mem=8GB
#SBATCH --time=7-00:00:00
##SBATCH --gres=gpu:1 ## To ask for a gpu, remove #, don’t need right now

module purge
module load gromacs/openmpi/intel/2020.4

# This is to construct the Gro and top file
# mpirun grep -v HOH 1aki.pdb > 1AKI_Clean.pdb
# mpirun gmx_mpi pdb2gmx -f 1AKI_Clean.pdb -o 1AKI_Process.gro -water spce
# mpirun gmx_mpi editconf -f 1AKI_Process.gro -o 1AKI_Newbox.gro -c -d 1.0 -bt cubic
# mpirun gmx_mpi solvate -cp 1AKI_Newbox.gro -cs spc216.gro -o 1AKI_Solv.gro -p topol.top
# mpirun gmx_mpi grompp -f ions.mdp -c 1AKI_Solv.gro -p topol.top -o ions.tpr
# mpirun gmx_mpi genion -s ions.tpr -o 1AKI_solv_ions.gro -p topol.top -pname NA -nname CL -neutral

# This is the MD steps: md1:EM, md2:NVT, md3: NPT, md4: Production Run
# mpirun gmx_mpi grompp -f md1.mdp -c 1AKI_solv_ions.gro -p topol.top -o md1.tpr
#mpirun gmx_mpi mdrun -v -deffnm md1
 
# mpirun gmx_mpi grompp -f md2.mdp -c md1.gro -r md1.gro -p topol.top -o md2.tpr
# mpirun gmx_mpi mdrun -deffnm md2

# mpirun gmx_mpi grompp -f md3.mdp -c md2.gro -r md2.gro -t md2.cpt -p topol.top -o md3.tpr
# mpirun gmx_mpi mdrun -deffnm md3

# mpirun gmx_mpi grompp -f md4.mdp -c md3.gro -t md3.cpt -p topol.top -o md4.tpr
# mpirun gmx_mpi mdrun -deffnm md4

# This is to output the each steps parameters to see if the MD is in equlibrum.
# mpirun gmx_mpi energy -f md1.edr -o potential.xvg
# mpirun gmx_mpi energy -f md2.edr -o temperature.xvg
# mpirun gmx_mpi energy -f md3.edr -o pressure.xvg
# mpirun gmx_mpi energy -f md3.edr -o density.xvg

# This is to Analyse the MD production run simulation result.
# mpirun gmx_mpi trjconv -s md4.tpr -f md4.xtc -o md4_noPBC.xtc -pbc mol -center
# mpirun gmx_mpi rms -s md4.tpr -f md4_noPBC.xtc -o rmsd.xvg -tu ns
# mpirun gmx_mpi rms -s md1.tpr -f md4_noPBC.xtc -o rmsd_xtal.xvg -tu ns
# mpirun gmx_mpi gyrate -s md4.tpr -f md4_noPBC.xtc -o gyrate.xvg
