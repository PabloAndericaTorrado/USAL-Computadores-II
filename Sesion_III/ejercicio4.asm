.area PROG (ABS)

; Definimos constantes para las direcciones de memoria
fin     .equ 0xFF01
pantalla .equ 0xFF00
.globl programa

; Variable temporal
temp_leer:   .word 0

; Definimos la posición de memoria inicial
.org 0x100

; Variables para los sumandos y resultados
sumando1: .word 0x2190
sumando2: .word 0x1908
suma1:  .word 0
suma2:  .word 0

.globl programa
programa:
        ; Realizamos la suma con el registro D
        ldd sumando1
        addd sumando2
        std suma1

        ; Cargamos el resultado de la suma en el acumulador A
        lda suma1

        ; Imprimimos la primera cifra hexadecimal
        tfr a,b
        lsrb
        lsrb
        lsrb
        lsrb ; En B está la primera cifra, de 0 a 15
        std temp_leer
        clra
        addb #246
        adca #0 ; En A hay un 1 si la primera cifra es mayor o igual que 10
        ldb #'A-'9-1
        mul
        addb temp_leer+1
        addb #'0
        stb pantalla

        ; Imprimimos la segunda cifra hexadecimal
        ldb temp_leer
        lslb
        lslb
        lslb
        lslb
        lsrb
        lsrb
        lsrb
        lsrb ; En B está la segunda cifra, de 0 a 15
        std temp_leer
        clra
        addb #246
        adca #0 ; En A hay un 1 si la segunda cifra es mayor o igual que 10
        ldb #'A-'9-1
        mul
        addb temp_leer+1
        addb #'0
        stb pantalla

        ; Cargamos el byte alto del resultado de la suma en el acumulador A
        lda suma1+1

        ; Imprimimos la primera cifra hexadecimal del byte alto
        tfr a,b
        lsrb
        lsrb
        lsrb
        lsrb ; En B está la primera cifra, de 0 a 15
        std temp_leer
        clra
        addb #246
        adca #0 ; En A hay un 1 si la primera cifra es mayor o igual que 10
        ldb #'A-'9-1
        mul
        addb temp_leer+1
        addb #'0
        stb pantalla

        ; Imprimimos la segunda cifra hexadecimal del byte alto
        ldb temp_leer
        lslb
        lslb
        lslb
        lslb
        lsrb
        lsrb
        lsrb
        lsrb ; En B está la segunda cifra, de 0 a 15
        std temp_leer
        clra
        addb #246
        adca #0 ; En A hay un 1 si la segunda cifra es mayor o igual que 10
        ldb #'A-'9-1
        mul
        addb temp_leer+1
        addb #'0
        stb pantalla

        ; El programa acaba
        clra
        sta fin

; Vector de RESET
.org 0xFFFE
.word programa