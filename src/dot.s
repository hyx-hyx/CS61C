.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t0,1
    blt a2,t0,error_handler1
    blt a3,t0,error_handler2
    blt a4,t0,error_handler2
    j begin
error_handler1:
    li a0,36
    j exit
error_handler2:
    li a0,37
    j exit

begin:
    # Prologue
    addi sp,sp,-4
    sw ra,0(sp)

loop_start:
    addi t0,x0,4
    add t6,x0,x0 
    add t1,x0,x0
loop_continue:
    bge t1,a2,loop_end

    mul t2,t1,a3   # v0
    mul t2,t2,t0
    mul t3,t1,a4   # v1
    mul t3,t3,t0
    
    add t2,a0,t2   # get actual address of v0[i]
    add t3,a1,t3   # get actual address of v1[i]
    lw t2,0(t2)    # get v0's value 
    lw t3,0(t3)    # get v1's value
    mul t5,t2,t3   # mul
    add t6,t6,t5   # sum

    addi t1,t1,1
    j loop_continue

loop_end:
    mv a0,t6
    # Epilogue
    lw ra 0(sp)
    addi sp,sp,4
    ret
