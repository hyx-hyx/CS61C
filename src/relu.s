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
    # Prologue
    addi sp, sp, -8
    sw ra, 8(sp)
loop_start:
    add t2,x0,x0
    bge t0, a1 ,loop_end
    mv t1,4
loop_continue:
    mul t2,t2,t1
    addi t3, a0,t2  
    

loop_end:


    # Epilogue

    
	ret
