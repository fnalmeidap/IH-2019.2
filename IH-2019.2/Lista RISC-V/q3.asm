.data
	str: .asciiz "RISCV EH LEGAL"
.text
    la t0, str # pega endereco da string
    addi a1, zero, 65 # A
    addi a2, zero, 69 # E
    addi a3, zero, 73 # I
    addi a4, zero, 79 # O
    addi a5, zero, 85 # U
    addi t0, t0, -1 # volta um endereco pra dar certo no loop abaixo
    xor x18, x18, x18 # zera o contador
    	
    loop:
 	addi t0, t0, 1 # aumenta em 1 byte o endereco
    	lb a7 ,  0(t0) # pega o que tem no endereco
    	beq a7, zero, exit  # se a string acabou, sai do programa
        beq a7, a1, ehvogal  #verifica se eh vogal
        beq a7, a2, ehvogal #verifica se eh vogal
        beq a7, a3, ehvogal #verifica se eh vogal
        beq a7, a4, ehvogal #verifica se eh vogal
        beq a7, a5, ehvogal #verifica se eh vogal
        jal x1, loop # se nao for nenhuma das vogais, volta pro comeco do laco
	
   ehvogal:
   	addi x18, x18, 1 # incrementa o contador
	jal x1, loop # volta pro loop de verificacao da string
	
   exit: # encerra o programa
