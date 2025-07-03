 .area PROG (ABS)

        .org 0x100
        .globl programa

programa:
        ; leer teclado
        lda 0xFF02
        ldb 0xFF02
        ; mostrar por pantalla
        stb 0xFF00
        sta 0xFF00
        ; salto de linea
        ldb #'\n   ; Cargamos B con el cOdigo de salto de lInea (CTRL+J): 10
        stb 0xFF00



acabar: ;clra
        sta 0xFF01

        .org 0xFFFE     ; Vector de RESET
        .word programa