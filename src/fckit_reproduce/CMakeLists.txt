# (C) Copyright 2013 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.


set( CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/module/fckit_reproduce )

ecbuild_add_library( TARGET  fckit_reproduce
            LINKER_LANGUAGE CXX
            SOURCES
              fckit_reproduce.F90
              fckit_reproduce_c_binding.F90
              fckit_reproduce.cc
            PUBLIC_LIBS 
              fckit
            PUBLIC_INCLUDES
              $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
              $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/src>
              $<BUILD_INTERFACE:${CMAKE_Fortran_MODULE_DIRECTORY}>
              $<INSTALL_INTERFACE:include>
              $<INSTALL_INTERFACE:module/fckit>
)

ecbuild_add_executable(
  TARGET  test_fckit_reproduce
  SOURCES test_fckit_reproduce.F90
  LIBS fckit_reproduce
)


