.globl write_matrix
# .import utils.s
.data
# filename: .asciiz "/home/hyx/CS61C/fa20-proj2-starter/tests/write-matrix-1/output.bin"
# .align 4
# m: .word 1 2 3 4 5 6 7 8 9

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # test:
    # la a0,filename
    # la a1,m
    # li a2,3
    # li a3,3

    # Prologue
    addi sp,sp,-24
    sw ra,20(sp)
    sw s0,16(sp)
    sw s1,12(sp)
    sw s2,8(sp)
    sw s3,4(sp)
    sw s4,0(sp)

    # save a0,a1
    mv s0,a0
    mv s1,a1
    mv s2,a2
    mv s3,a3
    mul s4,a2,a3

    li a1,1
    call fopen

    li t0,-1              # error_check
    bne a0,t0,call_fwrite  
    li a0,27
    j exit

call_fwrite:
    mv a1,s1
    mv a2,s2
    mv a3,s3

    lw s2,0(a1)  #save a1[0],a1[1]
    lw s3,4(a1)
    sw a2,0(a1)  #set a1[0]=a2,a1[1]=a3
    sw a3,4(a1)

    li a2,2
    li a3,4
    mv s0,a0
    call fwrite

    li t0,2
    beq a0,t0,call_fwrite_again  # error_check
    li a0,30
    j exit

call_fwrite_again:
    #prepare data
    mv a0,s0
    mv a1,s1
    sw s2,0(a1)
    sw s3,4(a1)
    mv a2,s4
    li a3,4
    call fwrite

    beq a0,s4,call_fclose  # error_check
    li a0,30
    j exit

call_fclose:
    mv a0,s0
    call fclose

    bne a0,x0,error_fclose # error_check

    # Epilogue
    lw ra,20(sp)
    lw s0,16(sp)
    lw s1,12(sp)
    lw s2,8(sp)
    lw s3,4(sp)
    lw s4,0(sp)
    addi sp,sp,24

    jr ra

error_fclose:
    li a0,28
    j exit