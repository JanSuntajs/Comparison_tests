#!/bin/bash
name_source=$1
compiler=ifort

name_object=${name_source/.f90/.o} #substitution

echo "Compiling source code:" $name_source

libs1="-O3 -mcmodel=medium -fpic -heap-arrays 0 -align all -funroll-loops -qopenmp -mkl=parallel -lmkl_core  -lmkl_lapack95_lp64 -I${MKLROOT}/include/intel64/lp64 -I${MKLROOT}/include"

$compiler $name_source $libs1 -o $name_object
