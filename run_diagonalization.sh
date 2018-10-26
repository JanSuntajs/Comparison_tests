#!/bin/bash 

#SBATCH --time=2:59:00
#SBATCH --mem=4000
#SBATCH -c 8
#SBATCH --exclude=compute-1-[1-28]

source deactivate
module purge
module load intel
module load intelpython2/2018-u1
which python2.7>> my-log.log

srun python2.7 python_diagonalization.py 0 13

source activate