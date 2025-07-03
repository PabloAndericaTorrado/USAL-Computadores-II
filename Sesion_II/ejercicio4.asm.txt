	.area PROG (ABS)

        ; definimos una constante
fin     .equ 0xFF01

        .org 0x100
minuendo: .word 0x2190
sustraendo: .word 0x1070

resta1:  .word 0
resta2:  .word 0

        .globl programa
programa:
        ; hagamos, primero, la suma con el registro D
        ldd minuendo
        subd sustraendo
        std resta1

        ; ahora lo vamos a hacer solamente con el registro A
        lda minuendo+1
        suba sustraendo+1
        sta sustraendo+1
        lda minuendo
        suba sustraendo
        sta sustraendo

        ; el programa acaba
        clra
        sta fin

        .org 0xFFFE     ; vector de RESET
        .word programa

