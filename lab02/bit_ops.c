#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns 
    // 0 or 1)
    //return -1;
    return (x&(1<<n))>>n;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    // YOUR CODE HERE
    *x=(*x)^(v<<n)^(*x&(1<<n));
//  x:      0 0 1 1  
//  v:      1 0 0 1
// answer:  1 0 0 1
// x^v      1 0 1 0
// x        0 0 1 1
// result:  1 0 0 1   (x^v^x)
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    // YOUR CODE HERE
    *x^=(1<<n);
}

