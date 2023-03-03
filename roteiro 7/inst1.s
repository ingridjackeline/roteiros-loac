.text
main:
        addi x12, x0, 4
        addi x13, x12, 0
        addi x14, x0, 1 
check:
        blt x12, x0, erro
loop:
        beq x13, x0, result
        mul x14, x14, x13
        addi x13, x13, -1
        jal x0, loop
result:
        addi x10, x0, 4
        la x11, mensagem1
        ecall

        addi x10, x0, 1
        addi x11, x12, 0
        ecall

        addi x10, x0, 4
        la x11, mensagem2
        ecall

        addi x10, x0, 1
        addi x11, x14, 0
        ecall

        addi x10, x0, 4
        la x11, mensagem3
        ecall

        jal x0, fim
erro:
        addi x10, x0, 4
        la x11, mensagem_erro
        ecall
fim:
        addi x0, x0, 0

.data
mensagem1: .asciiz "O valor do fatorial de "
mensagem2: .asciiz " eh: "
mensagem3: .asciiz ". :)"
mensagem_erro: .asciiz "Nao existe fatorial de numero negativo. :("