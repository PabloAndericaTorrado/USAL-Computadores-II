; Programa de ejemplo: hola.asm

        .area PROG (ABS)  ; Va a estar almacenado en memoria en direccion absoluta a partir de 0x100 hexadecimal

        .org 0x100 
cadena: .ascii "Hola, mundo."
        .byte   10      ; 10 es CTRL-J: salto de lInea
        .byte   0       ; 0 es CTRL-@: fin de cadena

        .globl programa  ; Direccion de memoria donde empieza la primera linea que va a empezar a ejecutarse
programa:
        ldx #cadena  ;2 bytes o 16bits
bucle:  lda ,x+  ;carga en el registro el contenido de lo que apunta x
        beq acabar  ;salto con condicion y salta a "acabar", cuando en la cadena haya un 0 que es el ultimo caracter se va a acabar
        sta 0xFF00      ; salida por pantalla, esa direccion es la que saca por terminal
        bra bucle
acabar: clra
        sta 0xFF01 ;Direccion reservada para se muestra por pantalla el codigo ascii y se acaba el programa

        .org 0xFFFE     ; Vector de RESET, otra direccion de memoria reservada, direccion de la primera instruccion del programa
        .word programa
