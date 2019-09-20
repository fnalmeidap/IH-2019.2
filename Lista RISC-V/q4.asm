.data
	str: .asciiz "L u z A z u l"
    
.text
#t0 eh o ponteiro que vai pra frente ->a1
#t1 eh o ponteiro que vai pra tras -> a2
	xor a0, a0, a0
    addi a0, zero, 1
	addi t2, zero, 32
    addi t3, zero, 97
	la t1, str
    add t0, t1, zero #copia do endereco em t1 (t1==t0)
    #addi t1, t1, -1
   
    .loop: # loop pra achar o zero com o t1
    	addi t1, t1, 1
         lb a2, 0(t1) # a2 contem o ponteiro q vai pra frente
        bne a2, zero, .loop
     addi t0, t0, -1 # volta pro ultimo char antes do zero
     .compara:
     	beq t0, t1, exit #verifica se t0==t1 (a palindrome eh impar, ent n tem mais oq comparar - sai do prog)
        add t4, zero, t0
        addi t4, t4, 1
        beq t4, t1, exit #verifica se t0+1 == t1 ( se a palindrome eh par e chegou na ultima posicao comparavel)
     	addi t1, t1, -1 # volta pro ultimo char antes do zero
        addi t0, t0, 1
     	lb a2, 0(t1)
        lb a1, 0(t0)
     	beq a2, t2, pulaTras #verifica se tem espaço, se tiver, pula o espaço
        beq a1, t2, pulaFrente
        blt a2, t3, .ehMaiuscula#verifica se a2 eh maiuscula
        jal .ehMinuscula
       .ehMaiuscula:#se a1 nao for igual (maiuscula)
      		bne a2, a1, seraMinuscula
            addi a0, zero, 1
         	jal .compara
       .ehMinuscula:
      		bne a2, a1, seraMaiuscula
            addi a0, zero, 1
         	jal .compara
pulaTras:
	 addi t1, t1, -1 
     jal .compara
pulaFrente:
	 addi t0, t0, 1 
     jal .compara
NehIgual:
	xor a0, a0, a0 #zera o a0 e sai do prog
    jal exit
seraMinuscula: #soma e ve se eh igual mas minuscula
	addi a1, a1, -32
    bne a1, a2 NehIgual
    addi a0, zero,1
    jal .compara
seraMaiuscula: #soma e ve se eh igual mas maiuscula 
	addi a1, a1, 32
    bne a1, a2 NehIgual
    addi a0, zero,1
    jal .compara
exit:
     
