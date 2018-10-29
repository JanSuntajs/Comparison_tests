#!/bin/bash
name_source=$1
compiler=ifort

name_object=${name_source/.f90/.o} #substitution

echo "Compiling source code:" $name_source

libs1="-O3 -mcmodel=medium -fpic -align all -funroll-loops -qopenmp -mkl=parallel -lmkl_intel_lp64 -lmkl_core -lpthread -lm -ldl -larpack ${MKLROOT}/lib/intel64/li$"

$compiler $name_source $libs1 -o $name_object