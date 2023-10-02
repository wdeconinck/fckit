# Unload to be certain
module --force purge

# Load modules

module load prgenv/intel
module load cmake/new
module load intel/2023.2
module list 

export CC=icc
export CXX=icpc
export FC=ifort
