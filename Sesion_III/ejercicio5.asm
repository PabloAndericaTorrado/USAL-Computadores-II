.area  PROG (ABS)
        .org   0x100
        .globl programa

;-------------------------------------------
; Variables en memoria
;-------------------------------------------
num16:          .word  0x2190      
num8_noSigno:   .byte  1
num8_Signo:     .byte  -1
res_noSigno:    .word  0
res_conSigno:   .word  0

;-------------------------------------------
; Inicio del programa
;-------------------------------------------
programa:
        ldx   num16
        ldb   num8_noSigno 
        abx
        stx   res_noSigno

        ldb   num8_Signo
        sex
        addd  num16
        std   res_conSigno

        clra
        sta   0xFF01

        .org  0xFFFE
        .word programa