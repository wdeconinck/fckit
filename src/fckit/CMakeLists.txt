# (C) Copyright 2013 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

configure_file(fckit.h.in  fckit.h)
install( FILES ${CMAKE_CURRENT_BINARY_DIR}/fckit.h DESTINATION include/fckit )
set( source_files_properties fckit.h.in PROPERTIES HEADER_FILE_ONLY TRUE )

if( BUILD_SHARED_LIBS )
    set( fckit_type SHARED )
else()
    set( fckit_type STATIC )
endif()

if( CMAKE_Fortran_COMPILER_ID MATCHES "PGI|NVHPC" )
  # Bug tested with pgi/17.7 (fixed pgi/19.4) requires fckit to be compiled statically
  if( ${CMAKE_Fortran_COMPILER_VERSION} VERSION_LESS 19.4 )
      ecbuild_warn( "Bug in pgi < 19.4 requires fckit to be compiled statically" )
      set( fckit_type STATIC )
  endif()
endif()


ecbuild_add_library( 
    TARGET     fckit
    LINKER_LANGUAGE CXX
        # We need the C++ linker for the error handling to work
        # Otherwise death by recursion in function "fckit_terminate"
        # when uncaught exceptions are encountered
    SOURCES
           module/fckit_owned.cc
           fckit_owned.h
           module/fckit_owned_object.F90     
	   module/fckit_C_interop.cc
	   module/fckit_C_interop.F90
    PRIVATE_INCLUDES
           ${CMAKE_CURRENT_BINARY_DIR}

    INSTALL_HEADERS_LIST
           fckit_owned.h

    HEADER_DESTINATION  include/fckit

    PUBLIC_INCLUDES
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
        $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/src>
        $<BUILD_INTERFACE:${CMAKE_Fortran_MODULE_DIRECTORY}>
        $<INSTALL_INTERFACE:include>
        $<INSTALL_INTERFACE:module/fckit>

    TYPE ${fckit_type}

)

