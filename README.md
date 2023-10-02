# Problem

Observed with compiler cce/15.0.1

    lib-4220 : UNRECOVERABLE library error
    An internal library run time error has occurred.

- libfckit.so linked with CC
- libfckit_reproduce.so linked with CC
- test_fckit_reproduce is linking to libfckit_reproduce.so

# Instructions to reproduce error:

Environment on LUMI:

    source env/lumi/cce-15.sh

Compile:

    rm -rf build
    cmake -S . -B build ${CMAKE_ARGS}
    cmake --build build

When CMAKE_ARGS is undefined, this is equivalent to

    CMAKE_ARGS="-DENABLE_FINAL=ON -DBUILD_SHARED_LIBS=ON -DENABLE_CXX_LINKER=ON -DENABLE_CRAY_WORKAROUND=OFF -DENABLE_DEBUG_OUTPUT=OFF"

Run:

    build/bin/test_fckit_reproduce

# Known workarounds

Repeat above command by adding some cmake options 

1. Compilation with static libraries

    export CMAKE_ARGS="-DBUILD_SHARED_LIBS=OFF"

2. Compilation with Fortran linker

    export CMAKE_ARGS="-DENABLE_CXX_LINKER=OFF"

    This makes the intermediate library fckit_reproduce.so linked with ftn instead of CC.

3. Compilation with undesired code changes

    export CMAKE_ARGS="-DENABLE_CRAY_WORKAROUND=ON"

