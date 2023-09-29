/*
 * (C) Copyright 2013 ECMWF.
 *
 * This software is licensed under the terms of the Apache Licence Version 2.0
 * which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
 * In applying this licence, ECMWF does not waive the privileges and immunities
 * granted to it by virtue of its status as an intergovernmental organisation
 * nor does it submit to any jurisdiction.
 */

#include <cstdint>
#include <cstdlib>

using int32 = std::int32_t;
using int64 = std::int64_t;

extern "C" {
void fckit__cptr_free( void* ptr[] ) {
    delete[] ptr;
    ptr = 0;
}

int32 fckit__compare_cptr_equal( void* p1, void* p2 ) {
    return ( p1 == p2 );
}

int64 fckit__cptr_to_loc( void* ptr ) {
    std::intptr_t i = (std::intptr_t)ptr;
    return i;
}
}
