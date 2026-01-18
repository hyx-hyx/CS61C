.globl classify
# .import read_matrix.s
# .import write_matrix.s
# .import matmul.s
# .import dot.s
# .import relu.s
# .import argmax.s
# .import utils.s
.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0 5                 # error_check
    bne a0,t0,arg_error

    # Prologue
    addi sp,sp,-16
    sw ra,12(sp)
    sw s2,8(sp)
    sw s1,4(sp)
    sw s0,0(sp)
    
    mv s0,a0
    mv s1,a1
    mv s2,a2

    # Read pretrained m0
    mv a1,s1
    li a2,4
    jal read_offset
    
    addi sp,sp,-12  # save to sp
    sw a0,0(sp)
    lw t1,0(a1)
    sw t1,8(sp)
    lw t2,0(a2)
    sw t2,4(sp)
    
    # Read pretrained m1
    mv a1,s1
    li a2,8
    jal read_offset
    
    addi sp,sp,-12  # save to sp
    sw a0,0(sp)
    lw t1,0(a1)
    sw t1,8(sp)
    lw t2,0(a2)
    sw t2,4(sp)

    # Read input matrix
    mv a1,s1
    li a2,12
    jal read_offset
    
    addi sp,sp,-12  # save to sp
    sw a0,0(sp)
    lw t1,0(a1)
    sw t1,8(sp)
    lw t2,0(a2)
    sw t2,4(sp)

    # Compute h = matmul(m0, input)
    lw t1,32(sp)  # m0 row
    lw t5,4(sp)   # input col
    mul t0,t1,t5
    slli t0,t0,2
    mv a0,t0                 # allocate memory of result
    call malloc
    beq a0,x0,malloc_error
    mv a6,a0                 # set a6

    # set a0-a5
    lw a0,24(sp)  # m0 address
    lw a1,32(sp)  # m0 row
    lw a2,28(sp)  # m0 col
    lw a3,0(sp) 
    lw a4,8(sp) 
    lw a5,4(sp) 
    call matmul

    # Compute h = relu(h)
    lw t1,32(sp)
    lw t2,4(sp)
    mul a1,t1,t2
    mv a0,a6
    call relu

    # Compute o = matmul(m1, h)
    mv s0,a0      # set s0=the address of h to call matmul

    lw t1,20(sp)  # m1 row
    lw t5,4(sp)   # input col
    mul t0,t1,t5
    slli t0,t0,2
    mv a0,t0                 # allocate memory of result
    call malloc
    beq a0,x0,malloc_error

    mv a6,a0                 # set a6
    mv a3,s0
    lw a0,12(sp)  # m1 address
    lw a1,20(sp)  # m1 row
    lw a2,16(sp)  # m1 col
    lw a4,32(sp)  # h row
    lw a5,4(sp)   # h col
    call matmul
    
    # Write output matrix o
    mv s0,a6
    mv a1,s1
    lw a0,16(a1)
    mv a1,a6
    lw a2,20(sp)
    lw a3,4(sp) 
    call write_matrix

    # Compute and return argmax(o)
    lw t1,20(sp) 
    lw t2,4(sp) 
    mv a0,s0
    mul a1,t1,t2
    call argmax

    # If enabled, print argmax(o) and newline
    beq s2,x0,print

Epilogue:                    # Epilogue
    addi sp,sp,36
    lw ra,12(sp)
    lw s2,8(sp)
    lw s1,4(sp)
    lw s0,0(sp)
    addi sp,sp,16
    jr ra

arg_error:
    li a0,31
    j exit

malloc_error:
    li a0,26
    j exit
    
read_offset:
    # Prologue
    addi sp,sp,-24
    sw ra,20(sp)
    sw s2,16(sp)
    sw s1,12(sp)
    sw s0,8(sp)
    sw a2,4(sp)
    sw a1,0(sp)

    li a0,4                  # allocate memory of row
    call malloc
    beq a0,x0,malloc_error
    mv s1,a0
    
    li a0,4                  # allocate memory of col
    call malloc
    beq a0,x0,malloc_error
    mv s2,a0

    lw t1,0(sp)
    lw t2,4(sp)
    add a0,t1,t2   # a2=offset=filepath of m0 or m1 or input
    lw a0,0(a0)
    mv a1,s1
    mv a2,s2
    call read_matrix
    mv s0,a0
    
    mv a0,s0
    mv a1,s1
    mv a2,s2

    # Epilogue
    lw ra,20(sp)
    lw s2,16(sp)
    lw s1,12(sp)
    lw s0,8(sp)
    # lw a2,4(sp)   a1,a2 not need to restore
    # lw a1,0(sp)
    addi sp,sp,24

    jr ra

print:  
    mv s0,a0
    call print_int
    li a0,'\n'
    call print_char
    mv a0,s0
    j Epilogue