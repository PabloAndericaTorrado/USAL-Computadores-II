        .area PROG (ABS)

        .org 0x100
        .globl programa

        ;; Definición de variables
char1:  .byte 0  ; Almacenará el primer carácter
char2:  .byte 0  ; Almacenará el segundo carácter

        ;; Comienzo del programa
programa:
        ;; Leer el primer carácter del teclado
        lda 0xFF02       ; Cargar el primer carácter desde el teclado
        sta char1        ; Almacenar el primer carácter en char1

        ;; Leer el segundo carácter del teclado
        lda 0xFF02       ; Cargar el segundo carácter desde el teclado
        sta char2        ; Almacenar el segundo carácter en char2

        ;; Mostrar los caracteres en orden inverso
        lda char2        ; Cargar el segundo carácter
        sta 0xFF01       ; Mostrar el segundo carácter en la pantalla

        lda char1        ; Cargar el primer carácter
        sta 0xFF01       ; Mostrar el primer carácter en la pantalla

        ;; Mostrar un salto de línea
        lda #0x0A        ; Cargar el código ASCII del salto de línea (LF)
        sta 0xFF01       ; Mostrar el salto de línea en la pantalla

        ;; Devolver el código ASCII del primer carácter a la shell
        lda char1        ; Cargar el primer carácter
        clrb             ; Limpiar el registro B
        tfr a,b          ; Copiar el valor de A (primer carácter) a B
        lda #0x00        ; Limpiar el registro A
        sta 0xFF01       ; Devolver el código ASCII del primer carácter a la shell

        ;; Finalizar el programa
acabar: clra
        sta 0xFF01       ; Limpiar la salida
        swi              ; Terminar el programa (instrucción de interrupción de software)
        .org 0xFFFE     ; Vector de RESET
        .word programa