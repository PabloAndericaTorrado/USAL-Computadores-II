.module imp_columna_max                             
.globl mostrar_columna_maxima                       
.globl filas, columnas, imprime_decimal             

pantalla    .equ 0xFF00                             
m           .equ 0xE000                             ; Dirección de matriz en RAM

max_val:        .word 0                             ; Variable: valor máximo encontrado
max_col:        .byte 0                             ; Variable: índice de columna del primer máximo
col_actual:    .byte 0                              ; Variable: índice de columna en iteración
fil_actual:    .byte 0                              ; Variable: índice de fila en iteración

min_suma:        .word 0                            ; Variable: suma mínima entre columnas candidatas
sum_col:        .word 0                             ; Variable: suma acumulada de la columna actual
tiene_maximo:  .byte 0                              ; 1 si la columna actual tiene al menos un máximo
salto_fila:    .word 0                              ; Desplazamiento (bytes) para avanzar de fila en misma columna

mostrar_columna_maxima:
    pshs  A,B,X                                    ; Guarda A, B y X en pila
    ldd   #0                                       ; D = 0
    std   max_val                                  ; Inicializa max_val = 0
    clr   max_col                                  ; max_col = 0
    ldy   #m                                       ; Y apunta al inicio de la matriz
    clr   col_actual                               ; col_actual = 0
    clr   fil_actual                               ; fil_actual = 0

busca_max:
    ldd   ,Y                                       ; D = [Y] (elemento actual)
    cmpd  max_val                                  ; Compara D con max_val
    bls   continuar                                ; Si D ≤ max_val salta a continuar
    std   max_val                                  ; Sino, max_val = D
    lda   col_actual                               ; A = índice de columna actual
    sta   max_col                                  ; max_col = A

continuar:
    leay  2,Y                                      ; Y += 2 (siguiente palabra)
    inc   col_actual                               ; col_actual++
    lda   col_actual                               ; A = col_actual
    cmpa  columnas                                 ; Compara con total de columnas
    blo   columna_valida                           ; Si < columnas sigue en misma fila
    clr   col_actual                               ; Sino, col_actual = 0
    inc   fil_actual                               ; fil_actual++

; Asegura que busca_max procese todas las filas y columnas y prepara las sumas de columnas
columna_valida: 
    lda   fil_actual       ; Carga el índice de fila actual en A
    cmpa  filas            ; Compara con el número total de filas
    blo   busca_max        ; Si fil_actual < filas → continúa el bucle busca_max

    lda   columnas                                 ; A = número de columnas
    lsla                                           ; A = A*2 (tamaño fila en bytes)
    tfr   A,B              ; B = A (parte baja del desplazamiento)
    clra                   ; A = 0 (parte alta del desplazamiento)
    std   salto_fila       ; salto_fila = columnas * 2 (bytes por fila)

    ldd   #0xFFFF                                  ; D = $FFFF
    std   min_suma                                 ; min_suma = 0xFFFF
    clr   col_actual                               ; col_actual = 0

bucle_col:
    ldd   #0                                       ; D = 0
    std   sum_col                                  ; sum_col = 0
    clr   tiene_maximo                             ; tiene_maximo = 0
    clr   fil_actual                               ; fil_actual = 0
    ; (m + col_actual * 2) se apunta al primer elemento de col_actual !!!!!
    ldb   col_actual                               ; B = col_actual
    lslb                                          ; B = B*2 (offset columna en bytes)
    ldx   #m                                       ; X = base matriz
    abx                                           ; X += B → apunta fila 0, col_actual

suma_filas: ;suma la columna actual
    ldd   ,X                                      ; D = elemento [X]
    cmpd  max_val                                  ; Compara con el máximo global si ese no es maximo salta
    bne   no_max                                   ; Si ≠ salto a no_max
    lda   #1                                       ; A = 1
    sta   tiene_maximo                             ; tiene_maximo = 1

no_max:
    addd  sum_col                                  ; sum_col += D
    std   sum_col                                  ; Guarda sum_col
    ldd   salto_fila                               ; D = salto_fila
    leax  D,X                                      ; X += D → siguiente fila misma columna
    inc   fil_actual                               ; fil_actual++
    lda   fil_actual                               ; A = fil_actual
    cmpa  filas                                    ; Compara con total de filas
    blo   suma_filas                               ; Si < filas repite

    lda   tiene_maximo                             ; A = flag
    beq   sig_col                                  ; Si 0 salta sig_col

    ldd   sum_col                                  ; D = sum_col
    cmpd  min_suma                                 ; Compara con min_suma
    bhs   sig_col                                  ; Si ≥ no actualiza
    std   min_suma                                 ; Sino, min_suma = sum_col
    lda   col_actual                               ; A = col_actual
    sta   max_col                                  ; max_col = A

sig_col:
    inc   col_actual                               ; col_actual++
    lda   col_actual                               ; A = col_actual
    cmpa  columnas                                 ; Compara con total de columnas
    blo   bucle_col                                ; Si < salta a bucle_col

    lda   #'\n                                    ; A = LF
    sta   pantalla                                 ; Imprime salto de línea

    ldb   max_col                                  ; B = columna seleccionada
    lslb                                          ; B = B*2
    ldx   #m                                       ; X = base matriz
    abx                                           ; X += B → inicio columna seleccionada

    ldb   filas                                    ; B = filas
    pshs  B                                        ; Push contador de filas

imprime_col:
    ldd   ,X                                      ; D = elemento [X]
    jsr   imprime_decimal                         ; Llama a subrutina de impresión decimal
    lda   #'\t                                    ; A = tabulador
    sta   pantalla                                 ; Imprime tabulador
    ldd   salto_fila                               ; D = salto_fila
    leax  D,X                                      ; X += D → siguiente fila misma columna
    dec   ,S                                       ; Decrementa contador de filas de la pila
    bne   imprime_col                              ; Si ≠ 0 repite

    puls  B                                        ; Recupera B
    puls  A,B,X,PC                                 ; Recupera A,B,X y retorna al llamador