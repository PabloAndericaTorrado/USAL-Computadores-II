.module imp_diagonal
.globl mostrar_diagonal_menor
.globl filas, columnas, imprime_decimal

pantalla    .equ 0xFF00
m           .equ 0xE000                         ; Dirección matriz en RAM

.area BSS
suma_principal:    .word 0
suma_secundaria:   .word 0
contador_diagonal: .byte 0                      ; Índice de elemento actual en la diagonal


; ------------------------- CÓDIGO OPTIMIZADO -------------------------
mostrar_diagonal_menor:
    pshs  X,Y,D                                 ;carga en la pila
    ldx   #m                                    ; X = inicio matriz
    clr   contador_diagonal                     ; Contador = 0

bucle_suma_principal:
    ldd   ,X                                    ; Carga el dato en D de la direccion de X
    addd  suma_principal
    std   suma_principal                        ; Actualiza suma

    lda   columnas                              ; Offset = (columnas+1)*2
    inca
    lsla                                        ; *2 (elementos de 2 bytes)
    leax  A,X                                   ; le suma el avanze a X, X = X+A

    inc   contador_diagonal
    lda   contador_diagonal
    cmpa  filas                                 ; Usamos FILAS directamente
    blo   bucle_suma_principal                  

    ; ========== SUMA DIAGONAL SECUNDARIA ==========
    ldx   #m                                    ; Reinicia X
    lda   columnas
    deca                                        ; Offset inicial = (cols-1)*2
    lsla
    leax  A,X                                   ; X = [0][cols-1]
    clr   contador_diagonal                     ; Contador = 0

bucle_suma_secundaria:
    ldd   ,X                                    ; Carga elemento [i][cols-1-i]
    addd  suma_secundaria
    std   suma_secundaria                       ; Actualiza suma

    lda   columnas                              ; Offset = (cols-1)*2
    deca
    lsla
    leax  A,X                                   ; X += offset

    inc   contador_diagonal
    lda   contador_diagonal
    cmpa  filas                                 ; Compara con FILAS
    blo   bucle_suma_secundaria

    ; ========== DECISIÓN E IMPRESIÓN ==========
    ldd   suma_principal
    cmpd  suma_secundaria
    blo   imprimir_principal
    bra   imprimir_secundaria

imprimir_secundaria:
    ldx   #m
    lda   columnas
    deca                                        ;hacemos el mismo offset que antes (col-1)*2
    lsla
    leax  A,X                                   ; X = [0][cols-1]
    clr   contador_diagonal
    lda   #'\n
    sta   pantalla

bucle_imprimir_secundaria:
    ldd   ,X
    jsr   imprime_decimal
    lda   #'\t
    sta   pantalla

    lda   columnas
    deca                                        ;(col-1)*2
    lsla
    leax  A,X                                   ; Siguiente elemento
    inc   contador_diagonal
    lda   contador_diagonal
    cmpa  filas                                 ; Solo compara con FILAS
    blo   bucle_imprimir_secundaria
    bra   fin_impresion

imprimir_principal:
    ldx   #m                                    ; X = [0][0]
    clr   contador_diagonal
    lda   #'\n
    sta   pantalla

imprimir_bucle_principal:
    ldd   ,X
    jsr   imprime_decimal
    lda   #'\t
    sta   pantalla

    lda   columnas                              ; Offset = (cols+1)*2
    inca
    lsla
    leax  A,X                                   ; Siguiente elemento
    inc   contador_diagonal
    lda   contador_diagonal
    cmpa  filas
    blo   imprimir_bucle_principal

fin_impresion:
    puls  X,Y,D,PC