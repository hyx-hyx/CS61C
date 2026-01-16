.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    blt a1,1,error_handler1
    blt a2,1,error_handler1
    blt a4,1,error_handler2
    blt a5,1,error_handler2
    bne a2,a4,error_handler3
error_handler1:
    li a1,72
    j error_handler
error_handler2:
    li a1,73
    j error_handler
error_handler3:
    li a1,74
    j error_handler
error_handler:
    li a0,17
    ecall

    # Prologue
    add sp,sp,--24

outer_loop_start:
    li t0,4
    li t1,0   #outer_loop: i
    li t3,0
inner_loop_start:
    li t2,0   #outer_loop: j
    li t4,0
loop_continue:  
    mul t5,t1,a2  # row
    mul t5,t5,t0
    add t5,t5,a0
    lw t5,0(t5)

    mul t6,t2,t0  # column
    add t6,t6,a0
    lw t6,0(t6)

    




inner_loop_end:




outer_loop_end:


    # Epilogue
    
    
    ret
