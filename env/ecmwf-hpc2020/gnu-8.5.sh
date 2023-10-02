# Unload to be certain
module --force purge

# Load modules

module load prgenv/gnu
module load cmake/new
module load gcc/8.5.0
module list 

export CC=gcc
export CXX=g++
export FC=gfortran
