.data
	G1: .asciiz "AEIOUNRS"
    G2: .asciiz "DGT"
    G3: .asciiz "BCMP"
    G4: .asciiz "FHVWY"
    G5: .asciiz "K"
    G8: .asciiz "JLX"
    G10: .asciiz "QZ"
  	Player1: .asciiz "MALUUU"
    Player2: .asciiz "MALUUUU"
    # declara grupo de letras de determinada pontuação
.text
#result play1 -> t1, play2 ->t2
addi t5, zero, 91
#acima de 91 eh letra minuscula
xor t2, t2, t2
	carregaP1:
     la t0, Player1 #carrega a palavra do jogador 1
     addi t0, t0, -1
     jal comparaP1

     carregaP2:
     xor t1, t1, t1 #zeramos t1 para comecar a contar a pontuacao do player 2
     la t0, Player2 #carrega palavra do jogador 2
     addi t0, t0, -1
     jal comparaP2

     comparaP1:
     	addi t0, t0, 1 				#anda na palavra
        lb a0, 0(t0) 				#pega a letra atual
        blt t5, a0, comparaP1	 	#se for letra minuscula, ja passa pra proxima letra
     	beq a0, zero,writeResult1 	# se chegou no final da string vai salvar o resultado do player 1
        jal compG1 					#se for uma letra valida, vai checar quantos pontos ela vale

    writeResult1:
    	add t2, zero, t1 # se terminou player 1, agora vamos para o player 2 e passamos a pontuacao do t1 pra variavel t2
        jal carregaP2

    comparaP2:
     	addi t0, t0, 1 					#anda na palavra
        lb a0, 0(t0)					#pega as letras do player 2
        blt t5, a0, comparaP2			#se for minusculo pega prox letra
     	beq a0, zero, writeResult2		#se terminou a frase, vai pra comparacao
        jal compG1

     writeResult2:
    	#add t2, zero, a1
        jal comparaFinal

    sera:
    	beq t2, zero, comparaP1 		#Checa se essa comparacao era pro player 1 ou 2
        jal comparaP2

    compG1: 					 					 	#testa se eh alguma letra com pontuacao 1
    	la t3, G1 			 					 	#pega as letra de pontuacao 1
        .loop1:
        	lb a1, 0(t3) 					 	#pega a letra atual
            beq a1, zero, compG2 	#checa se ja passou por todas as letra de pontuacao 1, se ja vai pra comparacao de letras de pontucao 2
            beq a1, a0, .igual1 	#checa se a letra do player 1 eh igual a alguma letra de pontuacao 1
            addi t3, t3, 1 				#se nao for, passa pra proxima letra de pontuacao 1
            jal .loop1
         .igual1:
        # addi a0, zero, 11
		#addi a1, zero, 70
		#ecall
         	addi t1, t1, 1 					# se for igual, soma um ponto a pontuacao do player 1
            jal sera

    compG2:  											#segue a mesma ideia de letras de pontuacao 1, mas agora para letra de pontuacao 2
    	la t3, G2
        .loop2:
        	lb a1, 0(t3)						#pega a letra atual
            beq a1, zero, compG3 	#checa se ja passou por todas as letra de pontuacao 2, se ja vai pra comparacao de letras de pontucao 3
            beq a1, a0, .igual2   #checa se a letra do player 2 eh igual a alguma letra de pontuacao 2
            addi t3, t3, 1  			#se nao for, passa pra proxima letra de pontuacao 2
            jal .loop2
         .igual2:
          #addi a0, zero, 11
		#addi a1, zero, 71
		#ecall
         	addi t1, t1, 2				# se for igual, soma dois ponto a pontuacao do player 1
            jal sera

    compG3:									#segue a mesma ideia de letras de pontuacao 1, mas agora para letra de pontuacao 3
    	la t3, G3
        .loop3:
        	lb a1, 0(t3)								#pega a letra atual
            beq a1, zero, compG4			#checa se ja passou por todas as letra de pontuacao 3, se ja vai pra comparacao de letras de pontucao 4
            beq a1, a0, .igual3				#checa se a letra do player 3 eh igual a alguma letra de pontuacao 3
            addi t3, t3, 1						#se nao for, passa pra proxima letra de pontuacao 3
            jal .loop3
         .igual3:
          	addi t1, t1, 3    # se for igual, soma tres ponto a pontuacao do player 1
            jal sera

    compG4:							#segue a mesma ideia de letras de pontuacao 1, mas agora para letra de pontuacao 4
    	la t3, G4
        .loop4:
        	lb a1, 0(t3)               #pega a letra atual
            beq a1, zero, compG5       #ve se ha chegou no final das letras de pontuacao 4, e se, vai pra pontuacao 5
            beq a1, a0, .igual4
            addi t3, t3, 1
            jal .loop4
         .igual4:
          #addi a0, zero, 11
		#addi a1, zero, 73
		#ecall
         	addi t1, t1, 4
            jal sera

    compG5:							#segue a mesma ideia de letras de pontuacao 1, mas agora para letra de pontuacao 5
    	la t3, G5
        .loop5:
        	lb a1, 0(t3)
            beq a1, zero, compG8
            beq a1, a0, .igual5
            addi t3, t3, 1
            jal .loop5
         .igual5:
          #addi a0, zero, 11
		#addi a1, zero, 74
		#ecall
         	addi t1, t1, 5
            jal sera

    compG8:						#segue a mesma ideia de letras de pontuacao 1, mas agora para letra de pontuacao 8
    	la t3, G8
        .loop8:
        	lb a1, 0(t3)
            beq a1, zero, compG10
            beq a1, a0, .igual8
            addi t3, t3, 1
            jal .loop8
         .igual8:
          #addi a0, zero, 11
		#addi a1, zero, 75
		#ecall
         	addi t1, t1, 8
            jal sera

    compG10:						#segue a mesma ideia de letras de pontuacao 1, mas agora para letra de pontuacao 10
    	la t3, G10
        .loop10:
        	lb a1, 0(t3)
            beq a1, zero, sera
            beq a1, a0, .igual10
            addi t3, t3, 1
            jal .loop10
         .igual10:
          #addi a0, zero, 11
		#addi a1, zero, 76
		#ecall
         	addi t1, t1, 10
   			jal sera

    comparaFinal:
    	beq t1, t2, empate    #compara se sao iguais para dizer q empatou
        blt t1, t2, P1vence   #ve se o player 1 eh maior, se for ganhou
        addi a0, zero, 11
		addi a1, zero, 66
		ecall #PRINTA E
        jal exit

     P1vence:             #printa A
     	addi a0, zero, 11
		addi a1, zero, 65
		ecall
        jal exit
     empate:				#printa B
     	addi a0, zero, 11
		addi a1, zero, 69
		ecall
    exit:
