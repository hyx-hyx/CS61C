.globl read_matrix
# .import utils.s
.data
# filename: .asciiz "/home/hyx/CS61C/fa20-proj2-starter/tests/read-matrix-1/input.bin"
# .align 4
dimension: .word -1 -1
buffer:
.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp,sp,-20
    sw ra,16(sp)
    sw s0,12(sp)
    sw s1,8(sp)
    sw s2,4(sp)
    sw s3,0(sp)

    mv s1,a1        # save int* address of row
    mv s2,a2        # save int* address of column

    # la a0,filename (debug)
    li a1,0
    call fopen

    li t0,-1              # error_check
    bne a0,t0,call_fread  
    li a0,27
    j exit

call_fread:
    
    la a1,dimension
    li a2,8
    mv s0,a0              # s0=fd
    call fread  

    li a2,8
    beq a2,a0,pre_malloc  # error_check
    li a0,29
    j exit

pre_malloc:
    la t0,dimension     # get dimension address
    lw t1,0(t0)      # get row
    lw t2,4(t0)      # get col
    sw t1,0(s1)      # set row to *a1
    sw t2,0(s2)      # set col to *a2

    mul s3,t1,t2   # set s2= # of bytes
    slli a0,s3,2

    call malloc

    bne a0,x0,begin_read  #error_check
    li a0,26
    j exit

begin_read:
    
call_fread_again:
    slli a2,s3,2
    mv s2,a2
    mv a1,a0           #a1=the address of the matrix in memory
    mv s1,a1
    mv a0,s0           # a0=fd
    call fread  

    beq s2,a0,call_fclose # error_check
    li a0,29
    j exit


call_fclose:
    mv a0,s0
    call fclose
    bne a0,x0,error_fclose
    mv a0,s1   #restore a0=the aaddress of matrix

    # Epilogue
    lw ra,16(sp)
    lw s0,12(sp)
    lw s1,8(sp)
    lw s2,4(sp)
    lw s3,0(sp)
    addi sp,sp,20

    jr ra

error_fclose:
    li a0,28
    j exit
