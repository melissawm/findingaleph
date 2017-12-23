#!/bin/sh
gfortran -c pmodule.f90
gfortran -o findingaleph findingaleph.f90 pmodule.o -I/home/melissa/numerics/galahad/modules/pc64.lnx.gfo/double -L/home/melissa/numerics/galahad/objects/pc64.lnx.gfo/double -lgalahad -L/home/melissa/numerics/galahad/objects/pc64.lnx.gfo/double -lgalahad_lapack -L/home/melissa/numerics/galahad/objects/pc64.lnx.gfo/double -lgalahad_blas 
