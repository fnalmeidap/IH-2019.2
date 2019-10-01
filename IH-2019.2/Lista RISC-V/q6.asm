#guardar quantidade de vezes em a0

#OBS: Duas inicializações são feitas(linha 12-15 e 19-21) para que caso str seja completa, possa se retornar ao início do
#ciclo para mais uma contagem
.data
str: .asciiz "riscv"
msg:.asciiz "somethingsomethingriscvriscvsomething" 
.text
xor a0, a0, a0 #a questão pede pra que esse seja o contador, inicio ele com 0
    addi a0, a0, -1 #coloco ele pra -1, para que quando .num_string inicie ele volte a ser 0
addi a3, a3, '*'
   
     
    .num_string:
    addi a0, a0, 1 #aumentando o contador de str's que podem ser feitas com msg
    la t1, str #coloca o endereço do início da string em t0
        la t2, msg #coloca o endereço do início da mensage em t1
        lb a1, 0(t1)
    lb a2, 0(t2)
        .loop_string:
        beq a1, a2, .igual #se for igual coloca '*' no lugar em msg
            addi t2, t2, 1 #passa pro próximo byte de msg
            lb a2, 0(t2)
            beq a2, zero, .exit #se a msg chegou no fim, acaba o programa
            beq zero, zero, .loop_string #continua o loop

    .igual:
    sb a3, 0(t2) #coloca '*' na posição de t2
        addi t1, t1, 1 #incrementa para próximo byte na str
la t2, msg #volta a mensagem pro inico
        lb a1, 0(t1) #coloca os bytes nos registradores
        lb a2, 0(t2)
beq a1, zero, .num_string #se a string chegou no final, reinicia o processo com a str restante
        # - Note que quando voltamos para .num_string, o contador(a0) soma +1 e o lugar que antes era igual, agora é '*'
        beq zero, zero, .loop_string #continua a comparação normalmente
   
    .exit:

