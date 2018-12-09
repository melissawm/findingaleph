program main

  use pmodule
  use lancelot_simple_double
  implicit none
	
  ! 
  ! Variable declaration
  ! 

  integer :: exitcode, print_level, i, j, iterations, its, k, &
       nprobs, iargc, numarg, probnumber
  integer*8 :: mypos
  integer, parameter :: input = 47
  real (kind = wp) :: x(20), fx, lower(20), upper(20), w(4), maxerror, &
       maxerror_array(1428), PP(4,4,1428), PE(4,4), DXPE(4,4), normdif, t1, t2
  real (kind = wp), parameter :: eps = 1.e-3_wp
  double precision :: dlange
  character(len=9) :: teste, filename
  character(len=19) :: outfilename
  character(len=5) :: option
  character(len=80) :: arg
  ! due to a bug in GALAHAD, the objective function subroutine MUST be
  ! called probfun.
  external :: probfun, grad, hess, dlange
  
  ! ============================================================
  !

  ! The user must call findingaleph.f90 with the following command:
  !
  ! ./findingaleph <argument> <opt-arg>
  !
  ! If <argument> is 'pairs', we will read the file with the bacterial data, pairs.txt
  ! If <argument> is 'pmatf', we will read the files with random data. There are 10 files,
  ! called matrizes01.txt--matrizes10.txt
  ! <opt-arg> is the number of the problem we wish to read. There are 100 million problems.
  ! The actual reading of these problems is done in pmodule.f90

  numarg = iargc()
  if ( numarg .lt. 1 ) then
     print *, "Error! The first argument must be the pairs or pmatf option."
     stop
  else
     call getarg(1,arg)
     read(arg,'(A5)') option
     if ( option .eq. 'pairs' ) then
        !
        ! Reading file with matrices from bacterial data.
        !
        probnumber = 1
        nprobs = 1428
     elseif ( option .eq. 'pmatf' ) then        
        !
        ! Reading file with matrices from random data.
        !
        if ( numarg .eq. 2 ) then
           call getarg(2,arg)
           read(arg,'(i9)') probnumber
           if (( probnumber .lt. 1) .or. ( probnumber .gt. 100000000 )) then
              print *, "Error! Problem number must be between 1 and 100000000."
           else
              nprobs = probnumber
           endif
        else
           probnumber = 1
           nprobs = 1
        endif
        !filename = 'pmatf.txt'
        !filename = "matrizes.txt" ! this is not used. pmodule is responsible
                                   ! for reading these matrices.
     else
        print *, "Unknown option. Must be \'pairs\' or \'pmatf\'."
        stop
     endif
  endif

  call cpu_time(t1)

  ! x is a 20-element vector with E stored in x as 
  !
  ! x(4+j+(i-1)*4) = E(i,j)
  !
  ! such that E is stored by rows:
  !
  ! x(5)  x(6)  x(7)  x(8)
  ! x(9)  x(10) x(11) x(12)
  ! x(13) x(14) x(15) x(16)
  ! x(17) x(18) x(19) x(20)

  maxerror_array = zero

  do k = probnumber,nprobs
     ! readpfile(k,option) reads the P matrix for problem k from the master file
     ! located at findingaleph/data/matrizesnn.txt, where nn is 01 through 10 
     ! (depending on the number of the problem).
     call readpfile(k,option)
     ! Bound constraints
     lower = zero
     upper = 1.0e20_wp
     do j = 1,4
        do i = 1,4
           lower(4+j+(i-1)*4) = -P(i,j)
           upper(4+j+(i-1)*4) = 1-P(i,j)
        enddo
     enddo
     lower(4) = one
     upper(4) = one
  
     ! Initial point
     x = one

     ! Call solver
     call lancelot_simple(20, x, fx, exitcode, my_fun = probfun, my_grad = grad, &
          my_hess = hess, bl = lower, bu = upper, neq = 10, nin = 0, &
          iters = iterations, maxit = 1000, gradtol = eps, feastol = eps, &
          print_level = 0)

     ! PE is P+E
     do i = 1,4
        do j = 1,4
           PE(i,j) = P(i,j) + x(4+j+(i-1)*4)
        enddo
     enddo
     !DXPE is diag(x)*(P+E)
     DXPE(1,1:4) = PE(1,1:4)*x(1)
     DXPE(2,1:4) = PE(2,1:4)*x(2)
     DXPE(3,1:4) = PE(3,1:4)*x(3)
     DXPE(4,1:4) = PE(4,1:4) ! x(4) = one
     
     ! Persymmetric error
     maxerror = max(abs(DXPE(1,3)-DXPE(2,4)), abs(DXPE(1,2)-DXPE(3,4)), &
          abs(DXPE(1,1)-DXPE(4,4)), abs(DXPE(2,2)-DXPE(3,3)), &
          abs(DXPE(2,1)-DXPE(4,3)), abs(DXPE(3,1)-DXPE(4,2)))
     if ( option .eq. 'pairs' ) then
        maxerror_array(k) = maxerror
     endif

     ! writepfile(k, x, option) writes the solution x(1:20) for problem k in the
     ! file pefilenn.txt, where nn is 01 through 10, depending on the problem
     ! number (agrees with matrizesnn.txt) if options is 'pmatf'. If options is
     ! 'pairs', the output file is called 'pefilepairs.txt'.
     call writepefile(k, x, option)

     !
     ! Print outcome for each problem
     !

     write(*,*) ""
     write(*,'(A)') "===================================================="
     write(*,'(A,i9)') "             Problem ",k
     write(*,'(A)') ""
     normdif = DLANGE('f',4,4,P(1:4,1:4)-PE,4,w)
     write(*,'(A,4g15.7)') "x = ", (x(j), j = 1,4)
     write(*,'(A,g12.7)') "norm(P-(P+E),fro) = ", normdif
     write(*,'(A,g12.7)') "maxerror = ", maxerror
     write(*,'(A,i3)') "LANCELOT_SIMPLE exit code: ", exitcode
     write(*,'(A)') "===================================================="

  enddo
  if ( option .eq. 'pairs' ) then
     print *, "Maximum error for all problems: ", maxval(maxerror_array)
     print *, "Mean error for all problems: ", sum(maxerror_array)/1428.0_wp
  endif

  call cpu_time(t2)

  print *, "Elapsed time: ", t2-t1

  !
  !  Exit
  !

  ! if ( exitcode .ne. 0 ) then
  !    print *, "Exitcode = ", exitcode
  !    stop -1
  ! else
  !    stop
  ! endif

  stop
  
  ! ============================================================
  ! ============================================================

end program main

! ============================================================

subroutine probfun(x, fx, i)

  use pmodule
  implicit none

  real (kind = wp), intent(in) :: x(:)
  real (kind = wp), intent(out) :: fx
  integer, optional :: i
  integer :: j,k
  
  ! x(1:4) is x_i
  ! x(5:20) is E(i,j), such that x(4+j+(i-1)*n) = E(i,j)

  fx = zero
  if ( .not. present(i) ) then
     ! Objective function
     fx = sum(x(5:20)**2)
  else
     select case (i) 
        ! Equality constraints
        case(1)
           fx = x(1)*(P(1,1)+x(5)) - x(4)*(P(4,4)+x(20))
        case(2)
           fx = x(1)*(P(1,2)+x(6)) - x(3)*(P(3,4)+x(16))
        case(3)
           fx = x(1)*(P(1,3)+x(7)) - x(2)*(P(2,4)+x(12))
        case(4)
           fx = x(2)*(P(2,1)+x(9)) - x(4)*(P(4,3)+x(19))
        case(5)
           fx = x(2)*(P(2,2)+x(10)) - x(3)*(P(3,3)+x(15))
        case(6)
           fx = x(3)*(P(3,1)+x(13)) - x(4)*(P(4,2)+x(18))
        case(7)
           fx = sum(x(5:8))
        case(8)
           fx = sum(x(9:12))
        case(9)
           fx = sum(x(13:16))
        case(10)
           fx = sum(x(17:20))
     end select
  endif
  return
end subroutine probfun

subroutine grad(x, gradx, i)

  use pmodule
  implicit none

  real (kind = wp), intent(in) :: x(:)
  real (kind = wp), intent(out) :: gradx(:)
  integer :: j, k
  integer, optional :: i

  ! x(1:4) is x_i
  ! x(5:20) is E(i,j), such that x(4+j+(i-1)*n) = E(i,j)

  gradx = zero
  if ( .not. present(i) ) then
     gradx(5:20) = 2.0_wp*x(5:20)
  else
     select case (i) 
        ! Equality constraints
        case(1)
           !c = x(1)*(P(1,1)+x(5)) - x(4)*(P(4,4)+x(20))
           gradx(1) = P(1,1)+x(5)
           gradx(4) = -P(4,4)-x(20)
           gradx(5) = x(1)
           gradx(20) = -x(4)
        case(2)
           !c = x(1)*(P(1,2)+x(6)) - x(3)*(P(3,4)+x(16))
           gradx(1) = P(1,2)+x(6)
           gradx(3) = -P(3,4)-x(20)
           gradx(6) = x(1)
           gradx(16) = -x(3)
        case(3)
           !c = x(1)*(P(1,3)+x(7)) - x(2)*(P(2,4)+x(12))
           gradx(1) = P(1,3)+x(7)
           gradx(2) = -P(2,4)-x(12)
           gradx(7) = x(1)
           gradx(12) = -x(2)
        case(4)
           !c = x(2)*(P(2,1)+x(9)) - x(4)*(P(4,3)+x(19))
           gradx(2) = P(2,1)+x(9)
           gradx(4) = -P(4,3)-x(19)
           gradx(9) = x(2)
           gradx(19) = -x(4)
        case(5)
           !c = x(2)*(P(2,2)+x(10)) - x(3)*(P(3,3)+x(15))
           gradx(2) = P(2,2)+x(10)
           gradx(3) = -P(3,3)-x(15)
           gradx(10) = x(2)
           gradx(15) = -x(3)
        case(6)
           !c = x(3)*(P(3,1)+x(13)) - x(4)*(P(4,2)+x(18))
           gradx(3) = P(3,1)+x(13)
           gradx(4) = -P(4,2)-x(18)
           gradx(13) = x(3)
           gradx(18) = -x(4)
        case(7)
           !c = sum(x(5:8))
           gradx(5:8) = one
        case(8)
           !c = sum(x(9:12))
           gradx(9:12) = one
        case(9)
           !c = sum(x(13:16))
           gradx(13:16) = one
        case(10)
           !c = sum(x(17:20))
           gradx(17:20) = one
     end select
  endif
  return
end subroutine grad

subroutine hess(x,H,i)

  use pmodule, only : wp, one, zero
  implicit none

  ! Documentation excerpt from Galahad - lancelot_simple:
  !
  !      "If, additionally, the second-derivative matrix of f at X can be      !
  !      computed, the (optional) input argument MY_HESS must be               !
  !      specified and given the name of the user-supplied routine computing   !
  !      the Hessian, whose interface must be of the form                      !
  !                                                                            !
  !       HESSPROB( X, H )                                                     !
  !                                                                            !
  !      where H is a double precision vector of size n*(n+1)/2 in which the   !
  !      subroutine returns the entries of the upper triangular part of the    !
  !      Hessian of f at X, stored by columns.'
  
  integer:: j, k
  real(kind=wp), intent(in) :: x(:)
  real(kind=wp), intent(out) :: H(:)
  integer, optional :: i

  ! x(1:4) is x_i
  ! x(5:20) is E(i,j), such that x(4+j+(i-1)*n) = E(i,j)

  ! H is stored such that for k <= j
  ! H(k,j) = H(j*(j-1)/2 + k)
  !
  ! H(1) H(2) H(4)  H(7) 
  !      H(3) H(5)  H(8) 
  !           H(6)  H(9) 
  !                H(10) ...
  !*H is 20x20

  H = zero
  if ( .not. present(i) ) then
     ! Hessian of the objective function sum(x(1:16)**2)
     ! Fill the diagonal for x(5:20)
     ! H([15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210])
     H(15) = 2.0_wp
     H(21) = 2.0_wp
     H(28) = 2.0_wp
     H(36) = 2.0_wp
     H(45) = 2.0_wp
     H(55) = 2.0_wp
     H(66) = 2.0_wp
     H(78) = 2.0_wp
     H(91) = 2.0_wp
     H(105) = 2.0_wp
     H(120) = 2.0_wp
     H(136) = 2.0_wp
     H(153) = 2.0_wp
     H(171) = 2.0_wp
     H(190) = 2.0_wp
     H(210) = 2.0_wp
  else
     select case (i) 
        ! Equality constraints
     case(1)
        !c = x(1)*(P(1,1)+x(5)) - x(4)*(P(4,4)+x(20))
        !gradx(1) = P(1,1)+x(5)
        !gradx(4) = -P(4,4)-x(20)
        !gradx(5) = x(1)
        !gradx(20) = -x(4)
        !H(1,5) = 1 = H(11)
        !H(4,20) = -1 = H(194)
        !j = 5
        !k = 1
        ! 5*4/2+1 = 11
        H(11) = one
        !j = 20
        !k = 4
        ! 20*19/2+4 = 194
        H(194) = -one
     case(2)
        !c = x(1)*(P(1,2)+x(6)) - x(3)*(P(3,4)+x(16))
        !gradx(1) = P(1,2)+x(6)
        !gradx(3) = -P(3,4)-x(20)
        !gradx(6) = x(1)
        !gradx(16) = -x(3)
        ! H(1,6) = 1 = H(16)
        ! H(3,16) = -1 = H(123)
        !j = 6
        !k = 1
        ! 6*5/2+1 = 16
        H(16) = one
        !j = 16
        !k = 3
        ! 16*15/2+3 = 123
        H(123) = -one
     case(3)
        !c = x(1)*(P(1,3)+x(7)) - x(2)*(P(2,4)+x(12))
        !gradx(1) = P(1,3)+x(7)
        !gradx(2) = -P(2,4)-x(12)
        !gradx(7) = x(1)
        !gradx(12) = -x(2)
        ! H(1,7) = 1 = H(22)
        ! H(2,12) = -1 = H(68)
        !j = 7
        !k = 1
        ! 7*6/2+1 = 22
        H(22) = one
        !j = 12
        !k = 2
        ! 12*11/2+2 = 68
        H(68) = -one
     case(4)
        !c = x(2)*(P(2,1)+x(9)) - x(4)*(P(4,3)+x(19))
        !gradx(2) = P(2,1)+x(9)
        !gradx(4) = -P(4,3)-x(19)
        !gradx(9) = x(2)
        !gradx(19) = -x(4)
        !H(2,9) = 1 = H(38)
        !H(4,19) = -1 = H(175)
        !j = 9
        !k = 2
        ! 9*8/2+2 = 38
        H(38) = one
        !j = 19
        !k = 4
        ! 19*18/2+4 = 175
        H(175) = -one
     case(5)
        !c = x(2)*(P(2,2)+x(10)) - x(3)*(P(3,3)+x(15))
        !gradx(2) = P(2,2)+x(10)
        !gradx(3) = -P(3,3)-x(15)
        !gradx(10) = x(2)
        !gradx(15) = -x(3)
        !H(2,10) = 1 = H(47)
        !H(3,15) = -1 = H(108)
        !j = 10
        !k = 2
        ! 10*9/2+2 = 47
        H(47) = one
        !j = 15
        !k = 3
        ! 15*14/2+3 = 108
        H(108) = -one
     case(6)
        !c = x(3)*(P(3,1)+x(13)) - x(4)*(P(4,2)+x(18))
        !gradx(3) = P(3,1)+x(13)
        !gradx(4) = -P(4,2)-x(18)
        !gradx(13) = x(3)
        !gradx(18) = -x(4)
        !H(3,13) = 1 = H(81)
        !H(4,18) = -1 = H(157)
        !j = 13
        !k = 3
        ! 13*12/2+k = 81
        H(81) = one
        !j = 18
        !k = 4
        ! 18*17/2+4 = 157
        H(157) = -one
     end select
  endif
  return
end subroutine hess
