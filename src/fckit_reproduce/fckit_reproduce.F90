#include "fckit/fckit.h"

module fckit_reproduce_module

use fckit_owned_object_module, only: fckit_owned_object

implicit none

public :: Object
public :: Derived

private

!------------------------------------------------------------------------------
TYPE, extends(fckit_owned_object) :: Object
contains
  procedure, public :: create_derived
#if FCKIT_FINAL_NOT_INHERITING
  final :: Object__final_auto
#endif
END TYPE

interface Object
  module procedure Object__ctor_id
end interface

!------------------------------------------------------------------------------

TYPE, extends(Object) :: Derived
contains
#if FCKIT_FINAL_NOT_INHERITING
  final :: Derived__final_auto
#endif

END TYPE

interface Derived
  module procedure Derived__ctor_id
end interface

!------------------------------------------------------------------------------

!========================================================
contains
!========================================================

function create_derived(this,id) result(derived)
  use fckit_reproduce_c_binding
  class(Object), intent(in) :: this
  integer :: id
  type(fckit_owned_object) :: derived
  call derived%reset_c_ptr( new_Object(id) )
  call derived%return()
end function

! -----------------------------------------------------------------------------
! Destructor

#if FCKIT_FINAL_NOT_INHERITING
FCKIT_FINAL subroutine Object__final_auto(this)
  type(Object), intent(inout) :: this
#if FCKIT_FINAL_NOT_PROPAGATING
  call this%final()
#endif
  FCKIT_SUPPRESS_UNUSED( this )
end subroutine

FCKIT_FINAL subroutine Derived__final_auto(this)
  type(Derived), intent(inout) :: this
#if FCKIT_FINAL_NOT_PROPAGATING
  call this%final()
#endif
  FCKIT_SUPPRESS_UNUSED( this )
end subroutine
#endif


! -----------------------------------------------------------------------------
! Constructors

function Object__ctor_id(identifier) result(this)
  use fckit_reproduce_c_binding
  type(Object) :: this
  integer, intent(in) :: identifier
  call this%reset_c_ptr( new_Object(identifier) )
  call this%return()
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

end module


