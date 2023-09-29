# (C) Copyright 2013 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# FCKIT

cmake_minimum_required( VERSION 3.12 FATAL_ERROR )

find_package( ecbuild 3.4 REQUIRED HINTS ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild )

project( fckit LANGUAGES C CXX Fortran )

set(CMAKE_DIRECTORY_LABELS "fckit")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

################################################################################################
# options & dependencies

ecbuild_find_python( VERSION 3.4 REQUIRED NO_LIBS )

### Fortran ...
ecbuild_enable_fortran( REQUIRED MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/module )

ecbuild_check_fortran( FEATURES finalization )

set( FEATURE_FINAL_DEFAULT ON )
ecbuild_add_option( FEATURE FINAL
                    DESCRIPTION "Enable automatic finalisation for derived types (destructors)"
                    DEFAULT ${FEATURE_FINAL_DEFAULT}
                    CONDITION EC_HAVE_Fortran_FINALIZATION )

if( fckit_HAVE_FINAL )
    include( final-support )
    check_final_support()
    ecbuild_info( "FCKIT_HAVE_FINAL [1]")
    ecbuild_info( "  FCKIT_FINAL_FUNCTION_RESULT              = ${FCKIT_FINAL_FUNCTION_RESULT}")
    ecbuild_info( "  FCKIT_FINAL_UNINITIALIZED_LOCAL          = ${FCKIT_FINAL_UNINITIALIZED_LOCAL}")
    ecbuild_info( "  FCKIT_FINAL_UNINITIALIZED_INTENT_OUT     = ${FCKIT_FINAL_UNINITIALIZED_INTENT_OUT}")
    ecbuild_info( "  FCKIT_FINAL_UNINITIALIZED_INTENT_INOUT   = ${FCKIT_FINAL_UNINITIALIZED_INTENT_INOUT}")
    ecbuild_info( "  FCKIT_FINAL_NOT_PROPAGATING              = ${FCKIT_FINAL_NOT_PROPAGATING}")
    ecbuild_info( "  FCKIT_FINAL_NOT_INHERITING               = ${FCKIT_FINAL_NOT_INHERITING}")
    ecbuild_info( "  FCKIT_FINAL_BROKEN_FOR_ALLOCATABLE_ARRAY = ${FCKIT_FINAL_BROKEN_FOR_ALLOCATABLE_ARRAY}")
    ecbuild_info( "  FCKIT_FINAL_BROKEN_FOR_AUTOMATIC_ARRAY   = ${FCKIT_FINAL_BROKEN_FOR_AUTOMATIC_ARRAY}")
endif()
if( NOT fckit_HAVE_FINAL )
    ecbuild_info( "fckit_HAVE_FINAL [0]")
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

