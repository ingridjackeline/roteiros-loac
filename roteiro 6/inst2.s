.text
main:
		addi x10, x0, 2
		addi x11, x0, 4
condicao:
		beq x10, x11, soma
		add x12, x10, x10
		jal x0, fim
soma:
		add x12, x11, x11
fim:
		addi x0, x0, 0