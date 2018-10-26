#!/usr/bin/env python


import numpy as np 
import numba as nb 
import datetime
import sys
import os
from timeit import timeit
import multiprocessing as mp

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

if not os.path.exists('./loop_benchmark'):
	os.makedirs('./loop_benchmark')

print('number of all cores is: {}'.format(num_cores))
# diag_dict={0: eigvalsh ,1: eigh} #which type of function to use; if only eigenvalues are required, use 0, if full eigensystem is wanted, use 1
#get max number of cpus: 
def make_cores_list(max_cores):

	cores_list=[1]

	if max_cores>1:

		for i in range(2,max_cores+2,2):

			cores_list.append(i)

	return cores_list


#testing naive and numba for loops in python 
@nb.njit('complex128[:](float64[:], float64[:])', parallel=True, nogil=True, fastmath=True)
def calc_sff_nb(data, taulist):
	"""
	A function that takes a list of data (energies) and tau values and calculates the spectral
	form factor according to the formula:

	SFF(tau) = sum(exp(-1j*dat*tau) for dat in data)

	"""

	sfflist=np.zeros_like(taulist, dtype=np.complex128)

	for i in nb.prange(sfflist.size):

		sfflist[i]=np.sum(-1j*data*taulist[i])

	return sfflist

@nb.njit('complex128[:,:](float64[:,:], float64[:])', parallel=True, nogil=True, fastmath=True)
def calc_sff_ave_nb(datalist, taulist):
	"""
	Average sff over different datasets that are stored in the datalist

	"""
	n_data=datalist.shape[1]
	n_tau=taulist.size
	sfflist=np.zeros(shape=(n_data, n_tau))

	for i in nb.prange(n_data):

		sfflist[i]=calc_sff_nb(datalist[i], taulist)

	return sfflist



def calc_sff(data, taulist):

	sfflist=np.zeros_like(taulist, dtype=np.complex128)

	for i in range(sfflist.size):

		sfflist[i]=np.sum(-1j*data*taulist[i])

	return sfflist

def calc_sff_ave(datalist, taulist):
	"""
	Average sff over different datasets that are stored in the datalist

	"""
	n_data=datalist.shape[1]
	n_tau=taulist.size
	sfflist=np.zeros(shape=(n_data, n_tau))

	for i in nb.prange(n_data):

		sfflist[i]=calc_sff(datalist[i], taulist)

	return sfflist


if __name__=='__main__':




	taulist=np.logspace(-3,3,3000)
	engylist=np.sort(np.random.uniform(size=(2000,2000)), axis=1)

	f=open('./loop_benchmark/profile-time-{}.dat'.format(datetime.datetime.now().strftime("%Y%m%d%H%M%S")), 'w', 0)
	


	for ncores in make_cores_list(num_cores):
		mkl_set_num_threads(ncores)
		tlist=""

		mkl_set_num_threads(ncores)


		time=timeit(stmt='calc_sff_ave_nb(engylist, taulist)', setup='from __main__ import engylist, taulist, calc_sff_ave_nb', number=1)

		tlist +="{}: {:.3e}; ".format(ncores)+tlist
	out="numba:" + tlist
	f.write(out+"\n")
	print(out)
	for ncores in make_cores_list(num_cores):
		mkl_set_num_threads(ncores)
		tlist=""

		mkl_set_num_threads(ncores)


		time=timeit(stmt='calc_sff_ave(engylist, taulist)', setup='from __main__ import engylist, taulist, calc_sff_ave', number=1)

		tlist +="{}: {:.3e}; ".format(ncores)+tlist
	out="naive:" + tlist
	f.write(out+"\n")










