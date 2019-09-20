.data  
	a: .word 3
	b: .word 65
	c: .word 25
	x: .word 5
	
.text  #Carregando os valores nos registradores
	lw a0, a
	lw a1, b
	lw a2, c
	lw a3, x
	la t3, x

	addi a3, zero, 0 #Flags para as comparações
	addi a4, zero, 0
	addi a5, zero, 64
	addi a6, zero, 24
	sw a3, 0(t3) #Atribuindo o valor 0 ao endereço de memória de x

	bge a0, a4, cond1  #Verificando se (a >= 0)
	beq x0, x0, exit
    
cond1:
    beq a1, a5, cond2 #Verificando se (b == 64)
    blt a1, a5, cond2 #Verificando se (b < 64)
    beq x0,x0, exit #Caso não seja finaliza o programa
    
cond2:
	bge a2, a6, nehigual #Verifica se (c >= 24)
    beq x0,x0, exit
    
nehigual:
	beq a2, a6, exit   # Verifica se (c != 24)
	beq x0,x0, result
    
result:
	addi a3, zero, 1  # Caso a condição seja verdadeira atribui x = 1
    sw a3, 0(t3)	  # Salva x = 1 no endereço de memória de x
    beq x0,x0, exit			 
  
exit:
    
