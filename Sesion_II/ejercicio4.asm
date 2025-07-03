.area PROG (ABS)                            ; Define el área de memoria absoluta llamada PROG

                                            ; Definimos una constante
fin     .equ 0xFF01                         ; Define una constante llamada 'fin' con el valor 0xFF01

        .org 0x100                          ; Establece el origen de la memoria en la dirección 0x100
valor1: .word 0x2190                        ; Define una palabra (2 bytes) en la dirección actual con el valor 0x2190
valor2: .word 0x1070                        ; Define una palabra (2 bytes) en la dirección actual con el valor 0x1070

resultado1:  .word 0                        ; Define una palabra (2 bytes) en la dirección actual con el valor 0 (para almacenar el resultado de la resta)
resultado2:  .word 0                        ; Define otra palabra (2 bytes) en la dirección actual con el valor 0 (para almacenar el resultado de la resta)

        .globl programa                     ; Declara 'programa' como una etiqueta global
programa:                                   ; Etiqueta que marca el inicio del programa
                                            ; Hagamos, primero, la resta con el registro D
        ldd valor1                          ; Carga el valor de 'valor1' (0x2190) en el registro D
        subd valor2                         ; Resta el valor de 'valor2' (0x1070) del registro D (D = 0x2190 - 0x1070 = 0x1120)
        std resultado1                      ; Almacena el valor del registro D (0x1120) en 'resultado1' (resultado1 = 0x1120)

                                            ; Ahora lo vamos a hacer solamente con el registro A
        lda valor1+1                        ; Carga el byte alto de 'valor1' (0x21) en el registro A
        suba valor2+1                       ; Resta el byte alto de 'valor2' (0x10) del registro A (A = 0x21 - 0x10 = 0x11)
        sta valor2+1                        ; Almacena el resultado en el byte alto de 'valor2' (valor2+1 = 0x11)
        lda valor1                          ; Carga el byte bajo de 'valor1' (0x90) en el registro A
        suba valor2                         ; Resta el byte bajo de 'valor2' (0x70) del registro A (A = 0x90 - 0x70 = 0x20)
        sta valor2                          ; Almacena el resultado en el byte bajo de 'valor2' (valor2 = 0x20)

                                            ; El programa acaba
        clra                                ; Limpia el registro A (lo pone a 0)
        sta fin                             ; Almacena el valor 0 en la dirección 'fin'

        .org 0xFFFE                         ; Establece el origen de la memoria en la dirección 0xFFFE (vector de RESET)
        .word programa                      ; Define una palabra con la dirección de inicio del programa (vector de RESET)

