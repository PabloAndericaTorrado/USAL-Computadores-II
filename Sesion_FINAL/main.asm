.module main

.globl imprime_cadena
.globl leeByte
.globl carga_mat
.globl leeDecimal
.globl imprime_decimal
.globl imp_mat
.globl mostrar_columna_maxima
.globl mostrar_diagonal_menor
.globl diagonal_dominante




; Constantes
fin         .equ    0xFF01
pantalla    .equ    0xFF00
teclado     .equ    0xFF02
pila        .equ    0xF000
m           .equ    0xE000

; Variables
.globl     columnas
columnas:   .byte   0
.globl     filas
filas:      .byte   0

elementos:  .word   0

; Mensajes
dimensiones:
    .asciz "Ingrese dimensiones (filas x columnas):\n"
mensajeFilas:
    .asciz "Ingrese el numero de filas y Columnas: "
mensajeColumnas:
    .asciz "\nIngrese el numero de columnas:"
msgCargaElementos:
    .asciz "\nIngrese los elementos de la matriz:"
msgMatrizCargada:
    .asciz "\nLa matriz ha sido cargada con exito\n"

msgColumnaMax:
    .asciz "\nLa columna con elemento Maximo: \n" 
msgDiagonalMenor:    
    .asciz "\nElementos de la diagonal de menor suma:\n"  
msgDiagonalDominante:    
    .asciz "\nComprobando diagonal dominante... Presiona Enter"   
    ; En la sección de mensajes:
mensaje_pausa:
    .asciz "\nPresiona Enter para salir..."       

programa:
    lds     #pila           ; Cargar la pila en dirección segura

    ; Leer número de filas
    ldx     #mensajeFilas
    jsr     imprime_cadena
    jsr     leeByte
    stb     filas
    stb     columnas

    ; Calcular cantidad de elementos (filas * columnas)
    lda     filas
    ldb     columnas
    mul
    std     elementos

    ; Cargar la matriz
    ldx     #msgCargaElementos
    jsr     imprime_cadena
    jsr     carga_mat

    ; Confirmar carga de la matriz
    ldx     #msgMatrizCargada
    jsr     imprime_cadena

    ; Imprimir la matriz (suponiendo que imp_mat usa filas y columnas)
    lda     filas
    ldb     columnas
    jsr     imp_mat
    ldx     #msgColumnaMax
    jsr     imprime_cadena
    jsr     mostrar_columna_maxima
    ldx     #msgDiagonalMenor
    jsr     imprime_cadena
    jsr     mostrar_diagonal_menor
    ldx     #msgDiagonalDominante
    jsr     imprime_cadena
    jsr     diagonal_dominante
    ldx     #mensaje_pausa
    jsr     imprime_cadena
    jsr     leeByte          ; Espera a que el usuario presione una tecla
    lda     #'\n
    sta     pantalla
    clra
    sta     fin

.area FIJA (ABS)
.org 0xFFFE
.word programa