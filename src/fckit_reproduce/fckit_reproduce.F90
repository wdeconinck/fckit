#include "fckit.h"

module fckit_reproduce_module

use fckit_owned_object_module, only: fckit_owned_object

implicit none

public :: Object
public :: Derived
public :: object_destroyed

private

! #undef FCKIT_FINAL_NOT_INHERITING
! #define FCKIT_FINAL_NOT_INHERITING 0

!------------------------------------------------------------------------------
TYPE, extends(fckit_owned_object) :: Object
contains
  procedure, public :: create_object
#if FCKIT_FINAL_NOT_INHERITING
  ! This is the case for cray compiler cce/15
  final :: Object__final_auto
#endif
  procedure, public :: assignment_operator_hook => Object__assignment_operator_hook

END TYPE

interface Object
  module procedure Object__ctor_id
end interface

!------------------------------------------------------------------------------
TYPE, extends(Object) :: Derived
contains
#if FCKIT_FINAL_NOT_INHERITING
  ! This is the case for cray compiler cce/15
  final :: Derived__final_auto
#endif
END TYPE

interface Derived
  module procedure Derived__ctor_id
end interface

!========================================================
contains
!========================================================

function object_destroyed(id) result(destroyed)
  use fckit_reproduce_c_binding
  integer :: id
  logical :: destroyed
  destroyed = .false.
  if (Object__destroyed(id) == 1) then
    destroyed = .true.
  endif
end function

function create_object(this,id) result(obj)
  use fckit_reproduce_c_binding
  class(Object), intent(in) :: this
  integer :: id
  type(fckit_owned_object) :: obj
  call obj%reset_c_ptr( new_Object(id) )
  call Object__set_other(obj%c_ptr(), this%c_ptr())
  call obj%return()
end function

! -----------------------------------------------------------------------------
! Destructor

#if FCKIT_FINAL_NOT_INHERITING
! This is the case for cray compiler cce/15
FCKIT_FINAL subroutine Object__final_auto(this)
  type(Object), intent(inout) :: this
#if FCKIT_FINAL_DEBUGGING
  write(0,'(A,I0,A)') "fckit_reproduce.F90 @ ", __LINE__, " :  Object__final_auto"
#endif
! #if FCKIT_FINAL_NOT_PROPAGATING
  call this%final()
! #endif
end subroutine

FCKIT_FINAL subroutine Derived__final_auto(this)
  type(Derived), intent(inout) :: this
#if FCKIT_FINAL_NOT_PROPAGATING
  call this%final()
#endif
end subroutine
#endif


! -----------------------------------------------------------------------------
! Constructors

function Object__ctor_id(identifier) result(this)
  use fckit_reproduce_c_binding
  use, intrinsic :: iso_c_binding, only : c_ptr
  type(Object) :: this
  integer, intent(in) :: identifier
  type(c_ptr) :: cptr
#if FCKIT_FINAL_DEBUGGING
  write(0,'(A,I0,A)') "fckit_reproduce.F90 @ ", __LINE__, " :  Object__ctor_id begin"
#endif
cptr = new_Object(identifier)
#if FCKIT_FINAL_DEBUGGING
  write(0,'(A,I0,A)') "fckit_reproduce.F90 @ ", __LINE__, " :  this%reset_c_ptr(  )"
#endif
  call this%reset_c_ptr( cptr )
#if FCKIT_FINAL_DEBUGGING
  write(0,'(A,I0,A)') "fckit_reproduce.F90 @ ", __LINE__, " :  this%return()"
#endif
  call this%return()
#if FCKIT_FINAL_DEBUGGING
  write(0,'(A,I0,A)') "fckit_reproduce.F90 @ ", __LINE__, " :  Object__ctor_id end"
#endif
end function

! -----------------------------------------------------------------------------

function Derived__ctor_id(identifier) result(this)
  use fckit_reproduce_c_binding
  type(Derived) :: this
  integer, intent(in) :: identifier
  call this%reset_c_ptr( new_Object(identifier) )
  call this%return()
end function

! ----------------------------------------------------------------------------------------

subroutine Object__assignment_operator_hook(this, other)
  use fckit_reproduce_c_binding
  class(Object) :: this
  class(fckit_owned_object) :: other
#if FCKIT_FINAL_DEBUGGING
  write(0,'(A,I0,A,I0)') "fckit_reproduce.F90 @ ", __LINE__, " :  Object__assignment_operator_hook for Object ", &
      & Object__id(this%c_ptr())
#endif
end subroutine
  
end module


