#!/bin/sh
# Old version
#gfortran -O2 -c pmodule.f90
#gfortran -O2 findingaleph.f90 -I/home/melissa/numerics/galahad/modules/pc64.lnx.gfo/double -L/home/melissa/numerics/galahad/objects/pc64.lnx.gfo/double -lgalahad -lgalahad_blas -lgalahad_hsl -lgalahad_lapack -lgalahad_metis -lgalahad_dummy -lgalahad_pardiso -lgalahad_spral -lgalahad_wsmp pmodule.o -o findingaleph 

#gfortran -c pmodule.f90
#gfortran -fcheck=all -Ofast -o findingaleph findingaleph.f90 pmodule.o -I/home/admin/numerics/galahad/modules/pc64.lnx.gf5/double -L/home/admin/numerics/galahad/objects/pc64.lnx.gf5/double -lgalahad -L/home/admin/numerics/galahad/objects/pc64.lnx.gf5/double -lgalahad_lapack -L/home/admin/numerics/galahad/objects/pc64.lnx.gf5/double -lgalahad_blas -L/home/admin/numerics/galahad/objects/pc64.lnx.gf5/double -lgalahad_hsl

gfortran -c pmodule.f90
gfortran -fcheck=all -Ofast -o findingaleph2019 findingaleph.f90 pmodule.o -I/home/admin/numerics/galahad/modules/pc64.lnx.gf5/double -L/home/admin/numerics/galahad/objects/pc64.lnx.gf5/double -lgalahad -L/home/admin/numerics/galahad/objects/pc64.lnx.gf5/double -lgalahad_lapack -L/home/admin/numerics/galahad/objects/pc64.lnx.gf5/double -lgalahad_blas -L/home/admin/numerics/galahad/objects/pc64.lnx.gf5/double -lgalahad_hsl
