.text
main:
        addi a0, zero, 1
        add a1, a0, a0
        addi a2, zero, 5
loop:   
        beq a0, a2, fim
        slli a1, a1, 1
        addi a0, a0, 1
        j loop
fim:
        nop