# Compiler tests 

This code is extracted from https://github.com/ecmwf/fckit to illustrate 2 Cray compiler bugs
The code is altered compared to the original in order to create a minimal reproducer

## Problem 1

Consider following Fortran code:

```f90
    type :: Object
    contains
      final :: destructor
    endtype
    
    type, extends(Object) :: ObjectDerived
    contains
    endtype
    
    type, extends(Object) :: ObjectDerivedWithDummyFinal
    contains
      final :: destructor_ObjectDerivedWithDummyFinal
    endtype
    
    ...

    subroutine destructor(this)
      type(Object) :: this
      write(0,*) 'destructor called'
    end subroutine 

    subroutine destructor_ObjectDerivedWithDummyFinal(this)
      type(ObjectDerivedWithDummyFinal) :: this
      ! dummy, just so destructor will be called
    end subroutine 
```

Constructing an instance of `ObjectDerived` should call the 'destructor' subroutine from 'Object' but it doesn't.
A workaround seems to be creating a dummy 'final' routine which is empty such as done in `ObjectDerivedWithDummyFinal`

### Instructions to reproduce error:

Environment on LUMI:

    source env/lumi/cce-15.sh

Compile:

    rm -rf build
    cmake -S . -B build
    cmake --build build --target test_inherit_final

    build/bin/test_inherit_final


## Problem 2

The second problem is observed with compiler cce/15.0.1

    lib-4220 : UNRECOVERABLE library error
    An internal library run time error has occurred.

It involves compilation of 2 mixed C++/Fortran libraries:

- `libfckit_lite.so` linked with CC (c++)
- `libatlas_lite.so` linked with CC (c++) and linking to `libfckit_lite.so`
- `test_atlas_lite` is linking to `libatlas_lite.so`


### Instructions to reproduce error:

Environment on LUMI:

    source env/lumi/cce-15.sh

Compile:

    rm -rf build
    cmake -S . -B build ${CMAKE_ARGS}
    cmake --build build

When `CMAKE_ARGS` is undefined, this is equivalent to

    CMAKE_ARGS="-DENABLE_FINAL=ON -DBUILD_SHARED_LIBS=ON -DENABLE_CXX_LINKER=ON -DENABLE_CRAY_WORKAROUND=OFF -DENABLE_DEBUG_OUTPUT=OFF"

Run:

    build/bin/test_atlas_lite

### Known workarounds

Three different methods have been succesful but unsatisfactory in working around the problem, and could help to
understand the underlying problem.

Repeat above command by adding some cmake options 

1. Compilation with static libraries, NOT DESIRED

        export CMAKE_ARGS="-DBUILD_SHARED_LIBS=OFF"

2. Compilation of library `libatlas_lite.so` with Fortran linker, NOT DESIRED!

        export CMAKE_ARGS="-DENABLE_CXX_LINKER=OFF"

    This uses `ftn` instead of `CC` to link the intermediate library `libatlas_lite.so`

3. Compilation with code changes, NOT DESIRED

        export CMAKE_ARGS="-DENABLE_CRAY_WORKAROUND=ON"

   These code changes, which avoid type-bound procedures should not be necessary.

# Compilers known to work:

- gnu 8.5
- gnu 13.1
- intel 2021.4
- intel 2023.2
- nvidia 22.11

# Compilers known to fail:

- cce 15.0.1
 
