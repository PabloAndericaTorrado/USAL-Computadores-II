.area PROG (ABS)                            ; Define el área de memoria absoluta llamada PROG

                                            ; definimos una constante
fin     .equ 0xFF01                         ; Define una constante llamada 'fin' con el valor 0xFF01

        .org 0x100                          ; Establece el origen de la memoria en la dirección 0x100
sumando1: .word 0x2190                      ; Define una palabra (2 bytes) en la dirección actual con el valor 0x2190
sumando2: .word 0x7777                      ; Define una palabra (2 bytes) en la dirección actual con el valor 0x7777

suma1:  .word 0                             ; Define una palabra (2 bytes) en la dirección actual con el valor 0 (para almacenar el resultado de la suma)
suma2:  .word 0                             ; Define otra palabra (2 bytes) en la dirección actual con el valor 0 (para almacenar el resultado de la suma)

        .globl programa                     ; Declara 'programa' como una etiqueta global
programa:                                   ; Etiqueta que marca el inicio del programa
                                            ; hagamos, primero, la suma con el registro D
        ldd sumando1                        ; Carga el valor de 'sumando1' (0x2190) en el registro D
        addd sumando2                       ; Suma el valor de 'sumando2' (0x7777) al registro D (D = 0x2190 + 0x7777 = 0x9907)
        std suma1                           ; Almacena el valor del registro D (0x9907) en 'suma1' (suma1 = 0x9907)

                                            ; ahora lo vamos a hacer solamente con el registro A
        lda sumando1+1                      ; Carga el byte alto de 'sumando1' (0x21) en el registro A
        adda sumando2+1                     ; Suma el byte alto de 'sumando2' (0x77) al registro A (A = 0x21 + 0x77 = 0x98)
        sta suma2+1                         ; Almacena el resultado en el byte alto de 'suma2' (suma2+1 = 0x98)
        lda sumando1                        ; Carga el byte bajo de 'sumando1' (0x90) en el registro A
        adca sumando2                       ; Suma el byte bajo de 'sumando2' (0x77) al registro A con acarreo (A = 0x90 + 0x77 + 1 = 0x08, con acarreo)
        sta suma2                           ; Almacena el resultado en el byte bajo de 'suma2' (suma2 = 0x08)

                                            ; el programa acaba
        clra                                ; Limpia el registro A (lo pone a 0)
        sta fin                             ; Almacena el valor 0 en la dirección 'fin'

        .org 0xFFFE                         ; Establece el origen de la memoria en la dirección 0xFFFE (vector de RESET)
        .word programa                      ; Define una palabra con la dirección de inicio del programa (vector de RESET)