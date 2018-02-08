#!/bin/sh
# Old version
#gfortran -O2 -c pmodule.f90
#gfortran -O2 findingaleph.f90 -I/home/melissa/numerics/galahad/modules/pc64.lnx.gfo/double -L/home/melissa/numerics/galahad/objects/pc64.lnx.gfo/double -lgalahad -lgalahad_blas -lgalahad_hsl -lgalahad_lapack -lgalahad_metis -lgalahad_dummy -lgalahad_pardiso -lgalahad_spral -lgalahad_wsmp pmodule.o -o findingaleph 

gfortran -c pmodule.f90
gfortran -o findingaleph findingaleph.f90 pmodule.o -I/home/melissa/numerics/galahad/modules/pc64.lnx.gfo/double -L/home/melissa/numerics/galahad/objects/pc64.lnx.gfo/double -lgalahad -L/home/melissa/numerics/galahad/objects/pc64.lnx.gfo/double -lgalahad_lapack -L/home/melissa/numerics/galahad/objects/pc64.lnx.gfo/double -lgalahad_blas 
