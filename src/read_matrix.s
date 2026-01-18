.globl read_matrix
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

    li a1,0
    call fopen
    mv s0,a0        # sava s0=fd

    li t0,-1              # error_check
    bne a0,t0,get_row_col  
    li a0,27
    j exit

get_row_col:
    mv a0,s0
    mv a1,s1
    li a2,4
    call fread  

    mv a0,s0
    mv a1,s2
    li a2,4
    call fread  

pre_malloc:
    lw t1,0(s1)      # get row
    lw t2,0(s2)      # get col

    mul s3,t1,t2   # set s3= # of bytes
    slli a0,s3,2

    call malloc

    bne a0,x0,get_data  #error_check
    li a0,26
    j exit

get_data:
    slli a2,s3,2
    mv s2,a2
    mv a1,a0           #a1=the address of the matrix in memory
    mv s1,a1
    mv a0,s0           # a0=fd
    call fread  

    beq s2,a0,call_fclose # error_check
    mv a0,s1
    call free             # free memory
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
    mv a0,s1
    call free             # free memory
    li a0,28
    j exit
