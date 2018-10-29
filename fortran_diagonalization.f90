module procedures

implicit none

contains

subroutine rnd_sym(sym_mat, iseed)

	implicit none
	real(kind=8), dimension(:,:) :: sym_mat
	integer, optional :: iseed

	integer, allocatable, dimension(:) :: seed

	integer :: s_size, i,j !mat size, loop counters
	real(kind=8) :: rnd 

	s_size=size(sym_mat,1)
	call random_seed(size=s_size)
	allocate(seed(1:s_size))
	if(.not. present(iseed)) iseed=0
	seed=iseed

	sym_mat=0.

	call RANDOM_SEED(put=seed)

	call random_number(sym_mat)

	sym_mat= 0.5*(sym_mat + transpose(sym_mat))

	deallocate(seed)

end subroutine rnd_sym

subroutine full_diag(matrix, eigvals)
	use f95_precision, only: WP=>DP
	use lapack95, ONLY: syev !, mkl_tppack
	implicit none
	! integer :: matsize, rows, cols
	real(kind=8), dimension(:,:) :: matrix
	! real(kind=8), allocatable(:) :: pmatrix !packed matrix
	real(kind=8), dimension(:) :: eigvals

	! matsize=size(matrix, 1)
	! rows=1
	! cols=int(matsize*(matsize+1)/2)
	! allocate(pmatrix(cols))

	! pmatrix=0.

	!pack
	! call mkl_tppack(pmatrix, 1,1,rows, cols, matrix, 'U')

	!diagonalize
	call syev(matrix, eigvals)

	! deallocate(pmatrix)

return 

end subroutine full_diag


end module procedures



module fortran_diag


use procedures

use omp_lib
use mkl_service

implicit none 

real(kind=8), allocatable, dimension(:, :) sym_rnd
real(kind=8), allocatable, dimension(:) :: eigvals
real(kind=8), allocatable, dimension(:,:) :: time_values
integer(kind=8) :: count1,count2, count_rate, count_max


character(len=32) :: seed, s_size
integer(KIND=8) :: N, iseed, i,j, up_bound ! matrix dimension
reald(kind=8) :: rnd, start, end
integer power, power_max !N=2**power

integer, parameter :: out_unit=20
integer, parameter :: out_unit=21

!OMP, MKL 
integer :: omp_max_thr, mkl_max_thr, mkl_thr, omp_thr 

call get_command_argument(1, s_size)
read(s_size, *) power_max 

! omp_max_thr=omp_get_max_threads()
omp_max_thr=1
mkl_max_thr=mkl_get_max_threads()

write(6,*) 'OMP max threads:', omp_max_thr
write(6,*) 'MKL max threads:', mkl_max_thr

open(unit=out_unit, file='/diag_benchmark/fortran_syev_benchmark_real.txt', action="write", status="replace")

write(20,'(a8,I3,a8,I3)') 'OMP_max: ', omp_max_thr, ' MKL max:', mkl_max_thr
write(20,*) 'First entry: omp_get_wtime. Second entry: real time.'

do omp_thr=1, omp_max_thr

	write(20,*) 'N_omp:', omp_thr

	write(20, '(a15, <omp_max_thr>I11)') adjustl('size\ N_mkl '), (i,i=1,omp_max_thr)

	call omp_set_num_threads(omp_thr)

	! do mkl_thr=1, omp_max_thr-omp_thr

	! 	call mkl_set_num_threads(mkl_thr)
	! 	write(20,*) 'N_mkl:', mkl_thr
	! 	write(20, '(a4, 2a12)') adjustr('N:'),adjustr('t_cons: '), adjustr('t_diag:')
		do power=1, power_max

			N=2**power


			! up_bound=omp_max_thr-omp_thr
			up_bound=omp_max_thr
			! if (up_bound .lt. 1) up_bound=1

			allocate(sym_rnd(N,N))
			allocate(eigvals(N))
			allocate(time_values(2,up_bound))



			do mkl_thr=1, up_bound

				call mkl_set_num_threads(mkl_thr)


				call rnd_sym(sym_rnd,0)
				eigvals=0.
				!diagonalization 
				start=omp_get_wtime()
				call full_diag_packed(sym_rnd, eigvals)
				end=omp_get_wtime()

				time_values(1,mkl_thr)=end-start
				time_values(2,mkl_thr)=real(count2- count1)/real( count_rate )
			enddo
			write(20, '(I15, <up_bound>E11.3E2)') N, time_values(2,:)
			write(20, '(I15, <up_bound>E11.3E2)') N, time_values(3,:)



			deallocate(time_values)
			deallocate(sym_rnd)
			deallocate(eigvals)
		enddo		
	enddo

close(out_unit)



end module fortran_diag