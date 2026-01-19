#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    
    //set_bit(*reg,15,get_bit(*reg,0)^get_bit(*reg,2)^get_bit(*reg,3)^get_bit(*reg,5));
    uint16_t b0=(*reg&(1<<0))>>0;
    uint16_t b2=(*reg&(1<<2))>>2;
    uint16_t b3=(*reg&(1<<3))>>3;
    uint16_t b5=(*reg&(1<<5))>>5;

    uint16_t t=b0^b2^b3^b5;
    *reg>>=1;
    *reg=(*reg)^(t<<15)^(*reg&(1<<15));
}

