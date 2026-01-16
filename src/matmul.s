.globl matmul
# .import dot.s
# .data
# array1:
#     .word 1 2 3 4 5 6 7 8 9
# array2:
#     .word 1 2 3 4 5 6 7 8 9
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

    # test_simple
    # la a0,array1
    # la a3,array2
    # li a1,3
    # li a2,3
    # li a4,3
    # li a5,3

    # Error checks
    li t0,1
    blt a1,t0,error_handler1
    blt a2,t0,error_handler1
    blt a4,t0,error_handler2
    blt a5,t0,error_handler2
    bne a2,a4,error_handler3
    j begin
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

begin:
    # Prologue
    addi sp,sp,-40
    sw ra,36(sp)
    sw s8,32(sp)
    sw s7,28(sp)
    sw s6,24(sp)
    sw s5,20(sp)
    sw s4,16(sp)
    sw s3,12(sp)
    sw s2,8(sp)
    sw s1,4(sp)
    sw s0,0(sp)
    
    li s8,0   #outer_loop: i
outer_loop_start:
    bge s8,a1,outer_loop_end
    li s7,0   #outer_loop: j
inner_loop_start:
    bge s7,a5,inner_loop_end
loop_continue:  
    mul t3,s8,a2  # row address
    mul t3,t3,t0
    add t3,t3,a0

    mul t4,s7,t0  # column address
    add t4,t4,a3

    mv s0,a0   #save register
    mv s1,a1
    mv s2,a2
    mv s3,a3
    mv s4,a4
    mv s5,a5
    mv s6,a6
    
    mv a0,t3  #prepare dot
    mv a1,t4
    li a3,1
    mv a4,a5

    jal dot   #call dot
    
    mv t3,a0  # t3=dot(v0,v1)

    mv a0,s0  #restore register
    mv a1,s1
    mv a2,s2
    mv a3,s3
    mv a4,s4
    mv a5,s5
    mv a6,s6
    
    mul t4,s8,a5  #a6[i*a5+j]=dot(v0,v1)
    add t4,t4,s7
    li t0,4
    mul t4,t4,t0
    add t4,t4,a6
    sw t3,0(t4)
    
    addi s7,s7,1
    j inner_loop_start
inner_loop_end:
    addi s8,s8,1
    j outer_loop_start
outer_loop_end:
    

    # Epilogue
    lw ra,36(sp)
    lw s8,32(sp)
    lw s7,28(sp)
    lw s6,24(sp)
    lw s5,20(sp)
    lw s4,16(sp)
    lw s3,12(sp)
    lw s2,8(sp)
    lw s1,4(sp)
    lw s0,0(sp)
    addi sp,sp,40

    ret
