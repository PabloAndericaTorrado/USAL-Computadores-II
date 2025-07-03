.module carga_mat

	pantalla .equ 0xFF00
	teclado  .equ 0xFF02
	m .equ 0xE000

.globl carga_mat
.globl leeDecimal
.globl imprime_decimal
.globl imprime_cadena
.globl imp_mat
.globl filas, columnas  ; Referenciar variables globales

; Variables usadas en carga_mat e imp_mat
tam:        .word 0
contador:   .word 0
contfilas:  .word 0
contcol:    .word 0
dato:       .asciz "\nDato: "

carga_mat:
    ldy   #m            ; Y ← dirección base de la matriz en RAM
    std   tam           ; tam ← contenido de D (número total de elementos esperado)
    ldd   #0            ; D ← 0
    std   contador      ; contador ← 0  (inicializa el contador de entradas)

; Bucle de carga: repetir hasta leer 'tam' elementos
buclecarga:
    ldx   #dato         ; X ← puntero a la cadena "\nDato: "
    jsr   imprime_cadena; imprime el prompt "\nDato: "
    jsr   leeDecimal    ; lee un número decimal desde teclado → D
    std   ,Y++          ; almacena D en [Y], luego Y ← Y + 2 (post‐incremento)

    ldd   contador      ; D ← contador
    addd  #1            ; D ← D + 1
    std   contador      ; contador ← D

    cmpd  tam           ; compara contador con tam
    bne   buclecarga    ; si contador != tam, repetir carga

    rts                 ; fin de carga_mat, regresar al llamador

imp_mat:
    ldy   #m               ; Y ← dirección base de la matriz en RAM
    sta   filas            ; filas ← A (A trae el número de filas)
    stb   columnas         ; columnas ← B (B trae el número de columnas)
    clra                   ; A ← 0  (prepara A como 0 si se vuelve a usar)
    clrb                   ; B ← 0  (inicializa contadores de fila y columna)

buclefilimp:
    ldb   contfilas        ; B ← contfilas (contador de filas procesadas)
    cmpb  filas            ; compara contfilas con total de filas
    bge   fin_filas        ; si contfilas ≥ filas, saltar a fin_filas
    ldb   #0
    stb   contcol          ; contcol ← 0 (reinicia contador de columnas)

buclecolimp:
    ldb   contcol          ; B ← contcol (columna actual)
    cmpb  columnas         ; compara contcol con total de columnas
    bge   fin_col          ; si contcol ≥ columnas, fin de la fila
    clrb                   ; B ← 0
    ldb   #'\t           ; B ← tabulador
    stb   pantalla         ; imprime tabulador en pantalla
    ldd   ,Y++             ; D ← [Y]; Y ← Y + 2 (carga elemento y avanza)
    jsr   imprime_decimal  ; llama a subrutina para imprimir D

    ldb   contcol          ; B ← contcol
    incb                   ; B ← B + 1 (avanza columna)
    stb   contcol          ; guarda nuevo contcol
    bra   buclecolimp      ; repetir bucle de columnas

	fin_col:
    clra                   ; A ← 0
    ldb   #'\n           ; B ← salto de línea
    stb   pantalla         ; imprime newline en pantalla

    ldb   contfilas        ; B ← contfilas
    incb                   ; B ← B + 1 (avanza fila)
    stb   contfilas        ; guarda nuevo contfilas
    bra   buclefilimp      ; volver a imprimir siguiente fila

	fin_filas:
    clra                   ; A ← 0
    stb   contfilas        ; contfilas ← 0 (reinicia)
    clrb                   ; B ← 0
    stb   contcol          ; contcol ← 0 (reinicia)
rts                    ; retorna al llamador