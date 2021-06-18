#!/bin/bash
#SBATCH --job-name="marino"
#SBATCH --output="matlab.%j.%N.out"
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --export=ALL
#SBATCH --ntasks-per-node=24
#SBATCH -L matlab:1
#SBATCH -t 48:00:00
ulimit -u 2048
module load matlab
matlab -nodesktop -nodisplay -r "run Der_Tutorial;quit"
