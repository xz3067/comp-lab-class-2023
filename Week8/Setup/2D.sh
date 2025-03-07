#!/bin/bash

# Directory for log files
LOG_DIR="../Data/2DLog"
# Directory for trajectory files
TRAJ_DIR="../Data/2DTrajectories"

# Run simulations for densities from 0.5 to 1.1 with a step of 0.1
for density in $(seq 0.5 0.1 1.1)
do

    LOGFILE="$LOG_DIR/simulation_2D_density_$density.log"

    mpirun lmp -var density "$density"  -in ./Inputs/2dWCA.in -log "$LOGFILE"

done
