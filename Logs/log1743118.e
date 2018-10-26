slurmstepd: error: task/cgroup: unable to add task[pid=26220] to memory cg '(null)'
slurmstepd: error: task/cgroup: unable to add task[pid=26247] to memory cg '(null)'
Traceback (most recent call last):
  File "python_for_loops.py", line 80, in <module>
    @nb.njit('complex128[:,:](float64[:,:], float64[:])', parallel=True, nogil=True, fastmath=True)
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/decorators.py", line 199, in wrapper
    disp.compile(sig)
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/dispatcher.py", line 579, in compile
    cres = self._compiler.compile(args, return_type)
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/dispatcher.py", line 80, in compile
    flags=flags, locals=self.locals)
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/compiler.py", line 763, in compile_extra
    return pipeline.compile_extra(func)
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/compiler.py", line 360, in compile_extra
    return self._compile_bytecode()
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/compiler.py", line 722, in _compile_bytecode
    return self._compile_core()
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/compiler.py", line 709, in _compile_core
    res = pm.run(self.status)
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/compiler.py", line 246, in run
    raise patched_exception
numba.errors.TypingError: Caused By:
Traceback (most recent call last):
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/compiler.py", line 238, in run
    stage()
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/compiler.py", line 452, in stage_nopython_frontend
    self.locals)
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/compiler.py", line 865, in type_inference_stage
    infer.propagate()
  File "/share/apps2/intelpython2/lib/python2.7/site-packages/numba/typeinfer.py", line 844, in propagate
    raise errors[0]
TypingError: Cannot resolve setitem: array(float64, 2d, C)[int64] = array(complex128, 1d, A)
File "python_for_loops.py", line 92
[1] During: typing of setitem at python_for_loops.py (92)

Failed at nopython (nopython frontend)
Cannot resolve setitem: array(float64, 2d, C)[int64] = array(complex128, 1d, A)
File "python_for_loops.py", line 92
[1] During: typing of setitem at python_for_loops.py (92)
srun: error: compute-3-2: task 0: Exited with exit code 1
