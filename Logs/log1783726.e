slurmstepd: error: task/cgroup: unable to add task[pid=32424] to memory cg '(null)'
slurmstepd: error: task/cgroup: unable to add task[pid=32451] to memory cg '(null)'
slurmstepd: error: task/cgroup: unable to add task[pid=32624] to memory cg '(null)'
slurmstepd: error: task/cgroup: unable to add task[pid=32795] to memory cg '(null)'
forrtl: severe (174): SIGSEGV, segmentation fault occurred
Image              PC                Routine            Line        Source             
libifcoremt.so.5   00007FD22BDE346C  for__signal_handl     Unknown  Unknown
libpthread-2.17.s  00007FD22975C5E0  Unknown               Unknown  Unknown
fortran_diagonali  0000000000402FD0  Unknown               Unknown  Unknown
fortran_diagonali  0000000000401DC9  Unknown               Unknown  Unknown
fortran_diagonali  000000000040118E  Unknown               Unknown  Unknown
libc-2.17.so       00007FD2293A6C05  __libc_start_main     Unknown  Unknown
fortran_diagonali  00000000004010A9  Unknown               Unknown  Unknown
srun: error: compute-3-2: task 0: Exited with exit code 174
