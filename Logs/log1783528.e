slurmstepd: error: task/cgroup: unable to add task[pid=26904] to memory cg '(null)'
slurmstepd: error: task/cgroup: unable to add task[pid=26930] to memory cg '(null)'
slurmstepd: error: task/cgroup: unable to add task[pid=27099] to memory cg '(null)'
slurmstepd: error: task/cgroup: unable to add task[pid=27270] to memory cg '(null)'
forrtl: severe (174): SIGSEGV, segmentation fault occurred
Image              PC                Routine            Line        Source             
libifcoremt.so.5   00007F41DBCEB46C  for__signal_handl     Unknown  Unknown
libpthread-2.17.s  00007F41D96645E0  Unknown               Unknown  Unknown
fortran_diagonali  0000000000402FD0  Unknown               Unknown  Unknown
fortran_diagonali  0000000000401DC9  Unknown               Unknown  Unknown
fortran_diagonali  000000000040118E  Unknown               Unknown  Unknown
libc-2.17.so       00007F41D92AEC05  __libc_start_main     Unknown  Unknown
fortran_diagonali  00000000004010A9  Unknown               Unknown  Unknown
srun: error: compute-3-2: task 0: Exited with exit code 174
