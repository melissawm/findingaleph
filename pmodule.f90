module pmodule

  ! This module contains routines needed to read/write the matrix files.
  ! It is used in findingaleph.f90

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! If option == 'pmatf' in findingaleph.f90, do
  ! 45 -> choose input file number
  ! 59 -> choose problem number range
  ! 83 -> choose output file number
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  integer, parameter :: wp=kind(1.0d0)
  real (kind=wp) :: P(4,4)
  real (kind=wp), parameter :: one = 1.0_wp, zero = 0.0_wp
  save
  
contains

  subroutine readpfile(probnumber,option)

    integer :: i, j, probnumber, mypos
    character*9 :: teste
    character*5 :: option
    integer, parameter :: input=47

    if (option .eq. 'pairs') then
       open(input, file='pairs.txt', status = 'old', access='stream')
       inquire(input, pos=mypos)
       do i = 1,4
          do j = 1,4
             mypos = (probnumber-1)*160+1+40*(i-1)+10*(j-1)
             read(input, pos=mypos) teste
             !print *, "P(",i,",",j,")=", teste
             read(teste, fmt='(f9.7)') P(i,j)
          enddo
       enddo
    elseif (option .eq. 'pmatf') then
       ! Matrices are stored in 10 files calles matrizes01.txt - matrizes10.txt
       ! In order to read each file, the mypos variable must contain the index given by
       ! mypos = (probnumber-xx000001)*160+1+40*(i-1)+10*(j-1)
       ! Example: the file matrizes04.txt contains problems 30000000 to 39999999
       ! thus
       ! mypos = (probnumber-30000001)*160+1+40*(i-1)+10*(j-1)
       open(input, file='matrizes01.txt', status='old', access='stream')
       ! matrizes01.txt -> probnumber-00000001 (problems from 0 to 09999999)
       ! matrizes02.txt -> probnumber-10000001 (problems from 10000000 to 19999999)
       ! matrizes03.txt -> probnumber-20000001 (problems from 20000000 to 29999999)
       ! matrizes04.txt -> probnumber-30000001 (problems from 30000000 to 39999999)
       ! matrizes05.txt -> probnumber-40000001 (problems from 40000000 to 49999999)
       ! matrizes06.txt -> probnumber-50000001 (problems from 50000000 to 59999999)
       ! matrizes07.txt -> probnumber-60000001 (problems from 60000000 to 69999999)
       ! matrizes08.txt -> probnumber-70000001 (problems from 70000000 to 79999999)
       ! matrizes09.txt -> probnumber-80000001 (problems from 80000000 to 89999999)
       ! matrizes10.txt -> probnumber-90000001 (problems from 90000000 to 99999999)
       inquire(input, pos=mypos)
       do i = 1,4
          do j = 1,4
             mypos = (probnumber-00000001)*160+1+40*(i-1)+10*(j-1)
             read(input, pos=mypos) teste
             read(teste, fmt='(f9.7)') P(i,j)
          enddo
       enddo
    endif
    close(input)
    
  endsubroutine readpfile

  subroutine writepefile(probnumber,x,option)

    integer, intent(in) :: probnumber
    integer, parameter :: output=75, wp = kind(1.0d0)
    real (kind = wp), intent(in) :: x(:)
    character*28 :: outfilename
    character*5 :: option

    if (option .eq. 'pairs') then
       open(output, file='pefilepairs.txt', status='old', access='stream', form='formatted', position='append')
       write(output, fmt='(20(f10.7,x))', advance='yes') x
    else 
       ! All P+E matrices are written to 10 files named pefile01.txt - pefile10.txt
       ! The number on this file must match the number on the matrizesxx.txt file
       open(output, file='pefile01.txt', status='old', access='stream', form='formatted', position='append')
       write(output, fmt='(20(f10.7,x))', advance='yes') x
    endif
    close(output)

  endsubroutine writepefile

endmodule pmodule
