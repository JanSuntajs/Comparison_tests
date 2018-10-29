# Comparison tests #
## WHAT IS THIS ALL ABOUT? ##

This project contains code speed comparisons between different python and fortran programs run 
on the compute nodes of the spinon cluster of the F1 department at IJS. I am particularly interested
in comparing performance of `intelpython2/2018-u1` and `Anaconda2/5.3.0` in diagonalization of symmetric 
(non-sparse, at the moment) matrices, as well as the performance of the `syev` diagonalization subroutine
from intel's MKL library. 

Additionally, comparison of the naive `python` for loop implementation and the speeded-up `numba` version 
will also be available in the future. 

## COMPILER DIRECTIONS FOR FORTRAN PROGRAMS ##

```bash
#!/bin/bash
name_source=$1
compiler=ifort

name_object=${name_source/.f90/.o} #substitution

echo "Compiling source code:" $name_source

libs1="-O3 -mcmodel=medium -fpic -heap-arrays 0 -align all -funroll-loops -qopenmp -mkl=parallel -lmkl_core  -lmkl_lapack95_lp64 -I${MKLROOT}/include/intel64/lp64 -I${MKLROOT}/include"

$compiler $name_source $libs1 -o $name_object

```

## SBATCH SUBMISSION SCRIPT ##

The code below submits jobs to the `spinon` cluster. Diagonalization of different symmetric random matrices is then performed, with the largest ones having size
```latex
$N=2^{p_\mathrm{max}}, \hspace{5mm} p_\mathrm{max}=14$
```
```bash 

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

```



