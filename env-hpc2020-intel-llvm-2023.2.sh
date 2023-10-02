# Unload to be certain
module --force purge

# Load modules

module load prgenv/intel
module load cmake/new
module load intel/2023.2
module list 

export CC=icx
export CXX=icpx
export FC=ifx
