.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp,sp, -4
    sw ra 0(sp)
loop_start:
    add t5,x0,x0   # save index
    lw t6,0(a0)    # max element
    add t1,x0,x0   # t1=0
    addi t0,x0,4    # t0=stride=4
loop_continue:
    bge t1,a1,loop_end  # for i<x1
    mul t2,t1,t0        # get actual offset
    add t3,a0,t2        # get actual address
    lw t4,0(t3)         # get a[t1]
    bge t6,t4,skip      # if t6<t4 t6=t4 t5=t1
    mv t6,t4
    mv t5,t1
skip:
    addi t1,t1,1
    j loop_continue
loop_end:
    mv a0,t5

    # Epilogue
    lw ra 0(sp)
    addi sp,sp, 4

    ret
