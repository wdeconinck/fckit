
module fckit_reproduce_c_binding

implicit none

public

interface
    function new_Object(i) bind(c,name="new_Object")
      use, intrinsic :: iso_c_binding, only : c_ptr, c_int32_t
      type(c_ptr) :: new_Object
      integer(c_int32_t), value :: i
    end function

    subroutine Object__set_other(cptr,obj) bind(c,name="Object__set_other")
      use, intrinsic :: iso_c_binding, only : c_ptr
      type(c_ptr), value :: cptr
      type(c_ptr), value :: obj
    end subroutine
 
   subroutine delete_Object(cptr) bind(c,name="delete_Object")
     use, intrinsic :: iso_c_binding, only : c_ptr
     type(c_ptr), value :: cptr
   end subroutine
end interface

contains

end module
