! (C) Copyright 2013 ECMWF.
! This software is licensed under the terms of the Apache Licence Version 2.0
! which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
! In applying this licence, ECMWF does not waive the privileges and immunities
! granted to it by virtue of its status as an intergovernmental organisation nor
! does it submit to any jurisdiction.

! This File contains Unit Tests for testing the
! C++ / Fortran Interfaces to the State Datastructure
! @author Willem Deconinck

program main

    logical :: success
    success = .true.

    write(0,*) "--------------------------------------------------------------"
    write(0,*) "test_1"
    write(0,*) "--------------------------------------------------------------"
    call test_1
    write(0,*) "--------------------------------------------------------------"
    write(0,*) "test_2"
    write(0,*) "--------------------------------------------------------------"
    call test_2
    write(0,*) "--------------------------------------------------------------"

    if (.not. success) then
      stop 1
    endif

contains

subroutine test_1
    use fckit_reproduce_module, only : Object

    type(Object) :: obj

    obj = Object(1)

    if( obj%owners() /= 1 ) then
        write(0,*) "ERROR: obj%owners /= 1"
        success = .false.
    endif

    ! call obj%final()
end subroutine

subroutine test_2
    use fckit_reproduce_module, only : Object, Derived

    type(Object) :: obj1
    type(Object) :: obj2
    
    obj1 = Object(1)
    
    if( obj1%owners() /= 1 ) then
        write(0,*) "ERROR: obj1%owners /= 1"
        success = .false.
    endif

    obj2  = obj1%create_object(2) ! this registers obj1 inside obj2 --> obj1%owners() += 1

    if( obj1%owners() /= 2 ) then
        write(0,*) "ERROR: obj1%owners /= 2"
        success = .false.
    endif

    if( obj2%owners() /= 1 ) then
        write(0,*) "ERROR: obj2%owners /= 1"
        success = .false.
    endif

    call obj2%final()
    call obj1%final()
end subroutine
end program
