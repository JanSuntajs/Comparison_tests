#!/bin/bash 

#SBATCH --time=2:59:00
#SBATCH --mem=4000
#SBATCH -c 8
#SBATCH --exclude=compute-1-[1,2,5-16,18-22,24,26,27,28]
#SBATCH --output=./Logs/log%J.out
#SBATCH --error=./Logs/log%J.e


echo ${SLURM_CPUS_PER_TASK}

conda deactivate

module purge
which python2.7
srun python 2.7 python_diagonalization.py 0 12



module purge
module load intelpython2/2018-u1
export MKL_NUM_THREADS=${SLURM_CPUS_PER_TASK}
#which python2.7>> my-log.log
which python2.7
srun python2.7 python_diagonalization.py 0 14


module purge
module load Anaconda2/5.3.0
export MKL_NUM_THREADS=${SLURM_CPUS_PER_TASK}
which python2.7
srun python2.7 python_diagonalization.py 0 14

module purge
export MKL_NUM_THREADS=${SLURM_CPUS_PER_TASK}
module load intel/2018b

srun ./fortran_diagonalization.o 14

conda activate jan2
