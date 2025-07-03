        .area PROG (ABS)

        ; Definimos constantes para las direcciones de memoria
fin     .equ 0xFF01
pantalla .equ 0xFF00
teclado .equ 0xFF02

        ; Definimos la posición de memoria inicial
        .org 0x100

        ; Variables para almacenar los números ingresados
num1:   .byte 0
num2:   .byte 0
num3:   .byte 0
num4:   .byte 0
resultado: .byte 0
acarreo: .byte 0

        .globl programa
programa:
        ; Leer la primera cifra
        lda teclado
        suba #'0
        sta num1

        ; Leer la segunda cifra
        lda teclado
        suba #'0
        sta num2

        ; Imprimir un espacio
        lda #' 
        sta pantalla

        ; Leer la tercera cifra
        lda teclado
        suba #'0
        sta num3

        ; Leer la cuarta cifra
        lda teclado
        suba #'0
        sta num4

           ; Imprimir un salto de línea
        lda #'\n
        sta pantalla

         ; Imprimir el primer número (num1 y num2)
        lda num1
        adda #'0
        sta pantalla
        lda num2
        adda #'0
        sta pantalla

        ; Imprimir el signo '+'
        lda #'+
        sta pantalla

        ; Imprimir el segundo número (num3 y num4)
        lda num3
        adda #'0
        sta pantalla
        lda num4
        adda #'0
        sta pantalla

        ; Imprimir el signo '='
        lda #'=
        sta pantalla

        ; Sumar las unidades (num2 + num4)
        lda num2
        adda num4
        daa             ; Ajustar a BCD
        sta resultado   ; Guardar el resultado de las unidades
        anda #0xF0     ; Verificar si hay acarreo
        beq sin_acarreo ; Si no hay acarreo, saltar
        lda #1          ; Si hay acarreo, guardar 1 en la variable acarreo
        sta acarreo
sin_acarreo:

        ; Sumar las decenas (num1 + num3 + acarreo)
        lda num1
        adda num3
        adda acarreo    ; Sumar el acarreo de las unidades
        daa             ; Ajustar a BCD
        sta num1        ; Guardar el resultado de las decenas


        ; Imprimir el resultado (num1 y resultado)
        lda num1
        adda #'0
        sta pantalla
        lda resultado
        anda #0x0F      ; Tomar solo las unidades del resultado
        adda #'0
        sta pantalla

        ; Imprimir un salto de línea
        lda #'\n
        sta pantalla

        ; El programa acaba
        clra
        sta fin

        ; Vector de RESET
        .org 0xFFFE
        .word programa

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; daa                                                              ;
;     simula la instrucciOn daa del ensamblador                    ;
;     se debe usar detAs de la instrucciOn adda para sumas BCD     ;
;                                                                  ;
;   Entrada: A-resultado de la suma    CC-flags de la suma         ;
;   Salida:  A-resultado ajustado BCD  CC-flags ajustados BCD      ;
;   Registros afectados: ninguno                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

daa:
        pshs a,cc
        lda ,s             ; A=CC
        clr ,-s            ; S-> 00 CC A
        anda #0x20         ; bit H de CC
        bne daa_ajusteBajo ; si H=1, hay que ajustar la cifra baja
        lda 2,s            ; si H=0 y la cifra baja>9, ajustarla
        anda #0xF
        cmpa #0xA
        blo daa_sinAjusteBajo
daa_ajusteBajo:
        lda #6
        sta ,s
daa_sinAjusteBajo:

        lda #1
        anda 1,s
        bne daa_ajusteAlto    ; si flag C=1, hay que ajustar la alta
        lda 2,s               ; o si C=0 y resultado>0x9A
        cmpa #0x9A
        blo daa_sinAjusteAlto
daa_ajusteAlto:
        lda ,s
        ora #0x60
        sta ,s
daa_sinAjusteAlto:

        lda  ,s+   ; aNadimos el ajuste a A
        adda 1,s
        sta  1,s
        tfr cc,a   ; el flag C es el or del C original y el de la suma
        ora ,s
        sta ,s
        puls cc,a
        tsta       ; ajustamos los flags Z y N del resultado
        rts