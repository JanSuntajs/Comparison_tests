# Comparison tests #
## WHAT IS THIS ALL ABOUT? ##

This project contains code speed comparisons between different python and fortran programs run 
on the compute nodes of the spinon cluster of the F1 department at IJS. I am particularly interested
in comparing performance of *intelpython2/2018-u1* and *Anaconda2/5.3.0* in diagonalization of symmetric 
(non-sparse, at the moment) matrices, as well as the performance of the *syev* diagonalization subroutine
from intel's MKL library. 

Additionally, comparison of the naive *python* for loop implementation and the speeded-up *numba* version 
will also be available in the future. 





