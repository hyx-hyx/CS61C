.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    bge a1,1,begin
    li a1,78
    li a0,17
    ecall
    
begin:
    # Prologue
    addi sp,sp, -4
    sw ra 0(sp)
loop_start:
    addi t0,x0,4
    add t1,x0,x0
loop_continue:
    bge t1,a1,loop_end
    mul t2,t1,t0  # get actual offset
    add t3,a0,t2  # get actual address
    lw t4,0(t3)   # t3=a[t1]
    bge t4,x0,done # if t3<0 then t3=0 
    mv t4,x0
done:
    sw t4,0(t3)  # a[t1]=max(t3,0)
    addi t1,t1,1
    j loop_continue
loop_end:


    # Epilogue
<<<<<<< HEAD
    lw ra 0(sp)
    addi sp,sp, 4
	ret
=======


    jr ra
>>>>>>> 7981a1b2a4150c44a0594279fa7d98a11977355b
