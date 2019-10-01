.data
    a: .word 5
    b: .word 4
    m: .word 12
    
.text
    lw a1, a # pega valor de a e poe no a1
    la t1, m # coloca endereco de m no t1
    sw a1, 0(t1) # m = a
    lw a2, b # pega valor de b e poe no a2
    lw a3, 0(t1) # pega valor de m e poe no a3
    
    beq a2, a3, loop1 # if b == m
    bne a2, a3, loop2 # if b != m
    
loop1: 
    sub a3, a2, a1 # subtrai b de a
    sw a3, 0(t1) # coloca no m o valor de a3
    beq x0, x0, exit # pra sair do prog
    
loop2: 
    sub a3, a1, a2 #subtrai a de b
    sw a3, 0(t1) # coloca no m o valor de a3
    beq x0, x0, exit # pra sair do prog
    
exit: # encerra o programa
