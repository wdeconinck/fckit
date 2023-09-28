! (C) Copyright 2013 ECMWF.
! This software is licensed under the terms of the Apache Licence Version 2.0
! which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
! In applying this licence, ECMWF does not waive the privileges and immunities
! granted to it by virtue of its status as an intergovernmental organisation nor
! does it submit to any jurisdiction.

! This File contains Unit Tests for testing the
! C++ / Fortran Interfaces to the State Datastructure
! @author Willem Deconinck

#include "fckit/fctest.h"
#include "fckit/fckit.h"

! -----------------------------------------------------------------------------

TESTSUITE(test_owned_object)

! -----------------------------------------------------------------------------

TESTSUITE_INIT
END_TESTSUITE_INIT

! -----------------------------------------------------------------------------

TESTSUITE_FINALIZE
END_TESTSUITE_FINALIZE

! -----------------------------------------------------------------------------


TEST( test_1 )
use fckit_reproduce_module, only : Object

type(Object) :: obj

obj = Object(1)

FCTEST_CHECK_EQUAL( obj%owners(), 1 )

call obj%final()
END_TEST

! -----------------------------------------------------------------------------

TEST( test_2 )
use fckit_reproduce_module, only : Object, Derived

type(Object) :: obj
type(Derived) :: der

obj = Object(1)
der  = obj%create_derived(2)

FCTEST_CHECK_EQUAL( obj%owners(), 1 )

call der%final()
call obj%final()
END_TEST



! -----------------------------------------------------------------------------

END_TESTSUITE

