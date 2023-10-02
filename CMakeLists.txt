# (C) Copyright 2013 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

cmake_minimum_required( VERSION 3.12 FATAL_ERROR )

project( fckit_reproduce LANGUAGES C CXX Fortran )

set(CMAKE_DIRECTORY_LABELS "fckit")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib )
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib )
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin )

option( ENABLE_FINAL "Enable final" ON )
option( ENABLE_CXX_LINKER "Enable CXX linker" ON )
option( ENABLE_DEBUG_OUTPUT "Enable debug output" OFF )
option( ENABLE_CRAY_WORKAROUND "Enable workaround" OFF )
option( BUILD_SHARED_LIBS "Build shared libs" ON )

message("")
message("Configuration:")
message("   ENABLE_FINAL           : ${ENABLE_FINAL}")
message("   ENABLE_DEBUG_OUTPUT    : ${ENABLE_DEBUG_OUTPUT}")
message("   ENABLE_CXX_LINKER      : ${ENABLE_CXX_LINKER}")
message("   ENABLE_CRAY_WORKAROUND : ${ENABLE_CRAY_WORKAROUND}" )
message("   BUILD_SHARED_LIBS      : ${BUILD_SHARED_LIBS}" )

if( ENABLE_DEBUG_OUTPUT )
  add_compile_definitions("ENABLE_DEBUG_OUTPUT")
endif()
if( ENABLE_CRAY_WORKAROUND )
  add_compile_definitions("ENABLE_CRAY_WORKAROUND")
endif()


if( ENABLE_FINAL )
  add_compile_definitions("ENABLE_FINAL")
  set(fckit_HAVE_FINAL 1)
  set(fckit_HAVE_FINAL 1)
else()
  set(fckit_HAVE_FINAL 0)
  set(fckit_HAVE_FINAL 0)
endif()

if( fckit_HAVE_FINAL )
    include( ${CMAKE_CURRENT_SOURCE_DIR}/cmake/final-support.cmake )
    check_final_support()
    message( "" )
    message( "FCKIT_HAVE_FINAL [1]")
    message( "  FCKIT_FINAL_FUNCTION_RESULT              = ${FCKIT_FINAL_FUNCTION_RESULT}")
    message( "  FCKIT_FINAL_UNINITIALIZED_LOCAL          = ${FCKIT_FINAL_UNINITIALIZED_LOCAL}")
    message( "  FCKIT_FINAL_UNINITIALIZED_INTENT_OUT     = ${FCKIT_FINAL_UNINITIALIZED_INTENT_OUT}")
    message( "  FCKIT_FINAL_UNINITIALIZED_INTENT_INOUT   = ${FCKIT_FINAL_UNINITIALIZED_INTENT_INOUT}")
    message( "  FCKIT_FINAL_NOT_PROPAGATING              = ${FCKIT_FINAL_NOT_PROPAGATING}")
    message( "  FCKIT_FINAL_NOT_INHERITING               = ${FCKIT_FINAL_NOT_INHERITING}")
    message( "  FCKIT_FINAL_BROKEN_FOR_ALLOCATABLE_ARRAY = ${FCKIT_FINAL_BROKEN_FOR_ALLOCATABLE_ARRAY}")
    message( "  FCKIT_FINAL_BROKEN_FOR_AUTOMATIC_ARRAY   = ${FCKIT_FINAL_BROKEN_FOR_AUTOMATIC_ARRAY}")
endif()
if( NOT fckit_HAVE_FINAL )
    message( "fckit_HAVE_FINAL [0]")
    set( FCKIT_FINAL_FUNCTION_RESULT              0 )
    set( FCKIT_FINAL_UNINITIALIZED_LOCAL          0 )
    set( FCKIT_FINAL_UNINITIALIZED_INTENT_OUT     0 )
    set( FCKIT_FINAL_UNINITIALIZED_INTENT_INOUT   0 )
    set( FCKIT_FINAL_NOT_PROPAGATING              0 )
    set( FCKIT_FINAL_NOT_INHERITING               0 )
    set( FCKIT_FINAL_BROKEN_FOR_ALLOCATABLE_ARRAY 0 )
    set( FCKIT_FINAL_BROKEN_FOR_AUTOMATIC_ARRAY   0 )
endif()

add_subdirectory( src )

