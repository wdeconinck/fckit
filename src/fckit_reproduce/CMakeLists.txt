# (C) Copyright 2013 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.


# reproducer library

set( CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/module/fckit_reproduce )

add_library( fckit_reproduce
  fckit_reproduce.F90
  fckit_reproduce_c_binding.F90
  fckit_reproduce.cc
)
if (ENABLE_CXX_LINKER)
  set_target_properties( fckit_reproduce PROPERTIES LINKER_LANGUAGE CXX )
else()
  set_target_properties( fckit_reproduce PROPERTIES LINKER_LANGUAGE Fortran )
endif()

target_include_directories( fckit PUBLIC $<BUILD_INTERFACE:${CMAKE_Fortran_MODULE_DIRECTORY}> )
target_link_libraries( fckit_reproduce PUBLIC fckit )

# executable

add_executable( test_fckit_reproduce test_fckit_reproduce.F90 )
target_link_libraries( test_fckit_reproduce PUBLIC fckit_reproduce )
