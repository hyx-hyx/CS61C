.globl factorial

.data
n: .word 12

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE

    # BEGIN PROLOGUE
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)
    # END PROLOGUE

    # let s0=1
    addi s0, x0, 1

    # let t3=a0
    mv t3,a0

loop:
    beq t3, x0, exit
    mul s0, s0, t3
    addi t3, t3, -1
    jal x0, loop
exit:   
    add a0, x0, s0

    # BEGIN EPILOGUE
    lw ra, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    # END EPILOGUE

    jr ra

