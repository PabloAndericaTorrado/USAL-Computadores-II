 .area PROG (ABS)

        .org 0x100
        .globl programa

        ;; definid en esta zona las variables que querAis usar,
        ;; como en estos ejemplos
var1:   .byte 3  ; una variable de 8 bits con valor inicial 3
var2:   .word 12 ; una variable de 16 bits con valor inicial 12
        ;; fin de la zona de variables

        ;; comienzo del programa
programa:
        ;; escribid aquI las instrucciones del programa


        ;; aNadid estas lIneas para que el programa acabe y empiece
acabar: clra
        sta 0xFF01

        .org 0xFFFE     ; Vector de RESET
        .word programa