# (C) Copyright 2013 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

configure_file(fckit.h.in  ${CMAKE_CURRENT_BINARY_DIR}/fckit.h)
set( source_files_properties fckit.h.in PROPERTIES HEADER_FILE_ONLY TRUE )

set( CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/module/fckit )

add_library( fckit
           fckit_owned.cc
           fckit_owned.h
           fckit_owned_object.F90
           fckit_C_interop.cc
           fckit_C_interop.F90
)
set_target_properties( fckit PROPERTIES LINKER_LANGUAGE CXX )
target_include_directories( fckit PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    $<BUILD_INTERFACE:${CMAKE_Fortran_MODULE_DIRECTORY}>
)


