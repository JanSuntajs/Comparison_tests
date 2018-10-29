#!/usr/bin/env python

"""
Dependencies on the cluster: check loading basic anaconda and intelpython anaconda and
compare the two versions

"""

#imports

import numpy as np 
from numpy.linalg import eigvalsh, eigh
import datetime
import sys
import os
import numpy as np
import multiprocessing as mp
from timeit import timeit


try:
    import ctypes #ctypes, used for determining the mkl num threads
        
    mkl_rt=ctypes.CDLL('libmkl_rt.so')

    def mkl_set_num_threads(cores):
        #Set # of MKL threads
        mkl_rt.MKL_Set_Num_Threads(cores)

    def mkl_get_max_threads():
        # # of used MKL threads
        print(mkl_rt.MKL_Get_Max_Threads())

    print('mkl maximum number of threads is:')
    mkl_get_max_threads()

except OSError:

    print('WARNING: No libmkl_rt shared object! The program will not use mkl routines and optimizations!')



#SET UP THE NUMBER OF CORES FOR MULTIPROCESSING; THIS IS DIFFERENT IF THE CODE IS RAN ON THE COMPUTE NODES OR 
#WHETHER IT IS RAN IN THE HEAD NODE!

try:
  num_cores=int(os.environ['SLURM_CPUS_PER_TASK'])
except KeyError: #if the job is not run on slurm, a key error is raised
  num_cores=mp.cpu_count()


if not os.path.exists('./diag_benchmark'):
    os.makedirs('./diag_benchmark')


print('number of all cores is: {}'.format(num_cores))
# diag_dict={0: eigvalsh ,1: eigh} #which type of function to use; if only eigenvalues are required, use 0, if full eigensystem is wanted, use 1
#get max number of cpus: 
def make_cores_list(max_cores):

    cores_list=[1]

    if max_cores>1:

        for i in range(2,max_cores+2,2):

            cores_list.append(i)

    return cores_list

def initMatrix(N):

    np.random.seed(seed=1)
    mat=np.random.uniform(size=(N, N))
    mat=0.5*(mat+mat.T)

    return mat

diag_dict={0: eigvalsh, 1: eigh}

def eig(matrix, case):

    return diag_dict[case](matrix)



if __name__=='__main__':

    args=sys.argv
        
    full_system=int(args[1]) #whether to calculate full eigensystem or just the eigenvalues
    max_size=int(args[2])
    """
    Initialize a random matrix, make it symmetric

    """

    namestring=''
    if 'Intel' in sys.version:
        namestring='intel_'
    elif 'Anaconda' in sys.version:
        namestring='anaconda_'
    else:
        pass



    # sizelist=np.arange(1,15,1)# N=2**power    
    f = open('./diag_benchmark/{}_profile-time-{}.dat'.format(namestring, datetime.datetime.now().strftime("%Y%m%d%H%M%S")), 'w', 0)

    for size in range(1,max_size+1,1):
        N=2**size
        
        mat=initMatrix(N)
        tlist = ""
        for ncores in make_cores_list(num_cores):
            mkl_set_num_threads(ncores)
            

            time=timeit(stmt='eig(mat, full_system)', setup='from __main__ import eig,mat, diag_dict,full_system', number=1)
            tlist += "{}: {:.3e}; ".format(ncores, time)

        out = "size: {:>8}; ".format(N)+tlist
        f.write(out+"\n")
        print(out)

    f.write('System information: \n')
    f.write(sys.version)

    f.close()



        #diagonalization 


