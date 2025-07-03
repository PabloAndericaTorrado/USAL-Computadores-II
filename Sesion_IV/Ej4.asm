        .area PROG (ABS)

        ; Definimos constantes para las direcciones de memoria
fin     .equ 0xFF01
pantalla .equ 0xFF00

        ; Definimos la posición de memoria inicial
        .org 0x100

        .globl programa
programa:
        ; Inicializamos el registro B con 9
        ldb #9

bucle:
        ; Convertimos el valor de B a ASCII sumando '0'
        tfr b,a
        adda #'0

        ; Imprimimos el carácter en pantalla
        sta pantalla

        ; Decrementamos B
        decb

        ; Comprobamos si B es menor que 0 (es decir, si B == -1)
        cmpb #-1
        bne bucle  ; Si B no es -1, repetimos el bucle

        ; Imprimimos un salto de línea al final
        lda #'\n
        sta pantalla

        ; El programa acaba
        clra
        sta fin

        ; Vector de RESET
        .org 0xFFFE
        .word programa