.module main

fin         .equ    0xFF01
pantalla    .equ    0xFF00
teclado     .equ    0xFF02

.globl programa
.globl imprime_cadena
.globl imprime_byte
.globl imprime_decimal
.globl leeByte
.globl leeDecimal

mensajeTitulo:          .asciz  "Programa ejemplo del funcionamiento de mis subrutinas\n"
mensajeEntradaByte:     .asciz  "Introduce un numero (max 255): "
mensajeResultadoByte:   .asciz  "El numero es "
mensajeEntradaDecimal:  .asciz  "\nIntroduce un numero (max 999): "
mensajeResultadoDecimal:.asciz  "El numero es "
saltoLinea:             .asciz  "\n"

programa:

    lds     #0xF000
    
    ldx     #mensajeTitulo
    jsr     imprime_cadena
    
    ldx     #mensajeEntradaByte
    jsr     imprime_cadena
    jsr     leeByte    

    lda     #0x0A          ; Cargar el carácter de nueva línea (LF)
    sta     pantalla       ; Imprimir nueva línea    
    ldx     #mensajeResultadoByte
    jsr     imprime_cadena
    jsr     imprime_byte
    
    ldx     #saltoLinea
    jsr     imprime_cadena
    
    ldx     #mensajeEntradaDecimal
    jsr     imprime_cadena
    jsr     leeDecimal

    ldx     #saltoLinea
    jsr     imprime_cadena
    ldx     #mensajeResultadoDecimal
    jsr     imprime_cadena
    jsr     imprime_decimal
    
    ldx     #saltoLinea
    jsr     imprime_cadena
    
    clra
    sta     fin

.area FIJA (ABS)
.org 0xFFFE
.word programa