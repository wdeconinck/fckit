#include <stdio.h>
#include <iostream>
#include <sstream>
#include <string>

#include "fckit/fckit_owned.h"

extern "C" {
void fckit_write_to_fortran_unit( int unit, const char* msg );
int fckit_fortranunit_stdout();
int fckit_fortranunit_stderr();
}

class Object : eckit::Owned {
public:
    Object( int i ) : eckit::Owned(), i_( i ) {
        std::stringstream out;
        out << "constructing Object " << i_;
        fckit_write_to_fortran_unit( fckit_fortranunit_stderr(), out.str().c_str() );
    }
    ~Object() {
        std::stringstream out;
        out << "destructing Object " << i_;
        fckit_write_to_fortran_unit( fckit_fortranunit_stderr(), out.str().c_str() );
    }
    int id() const { return i_; }

    void set_other(Object* other) {
        if (other_) {
            other_->detach();
        }
        other_ = other;
        other_->attach();
    }

    Object* other() const {
        return other_;
    }

private:
    int i_;
    Object* other_{nullptr};
};

extern "C" {
Object* new_Object( int i ) {
    return new Object( i );
}
void delete_Object( Object* p ) {
    delete p;
}
int Object__id( const Object* p ) {
    return p->id();
}
void Object__set_other( Object* p, Object* o ) {
    p->set_other(p);
}
Object* Object__other( Object* p) {
    return p->other();
}

}
