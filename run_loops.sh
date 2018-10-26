#!/bin/bash 

#SBATCH --time=2:59:00
#SBATCH --mem=4000
#SBATCH -c 8
#SBATCH --exclude=compute-1-[1,2,5-16,18-22,24,26,27,28]
#SBATCH --output=./Logs/log%J.out
#SBATCH --error=./Logs/log%J.e


echo ${SLURM_CPUS_PER_TASK}

source deactivate
module purge
module load intelpython2/2018-u1
export MKL_NUM_THREADS=${SLURM_CPUS_PER_TASK}
which python2.7>> my-log.log

srun python2.7 python_for_loops

source activate jan2