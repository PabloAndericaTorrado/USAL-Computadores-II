.area PROG (ABS)

        ; definimos una constante
fin     .equ 0xFF01
pantalla .equ 0xFF00

	.org 0x100
	.globl programa

temp_leer:   .word 0 ; una variable temporal

programa:
	lda #28 ; pongamos este nUmero como prueba

        ; imprimamos 0x
        ldb #'0
        stb pantalla
        ldb #'x
        stb pantalla

        ; primero imprimamos la primera cifra hexadecimal
        tfr a,b
        lsrb
        lsrb
        lsrb
        lsrb ; en B estA la primera cifra, de 0 a 15
        std temp_leer
        clra
        addb #246
        adca #0 ; en A hay un 1 si la primera cifra es mayor o igual que 10
        ldb #'A-'9-1
	mul
	addb temp_leer+1
        addb #'0
        stb pantalla

        ; ahora imprimimos la segunda cifra hexadecimal
        ldb temp_leer
        lslb
        lslb
        lslb
        lslb
        lsrb
        lsrb
        lsrb
        lsrb ; en B estA la segunda cifra, de 0 a 15
        std temp_leer
        clra
        addb #246
        adca #0 ; en A hay un 1 si la segunda cifra es mayor o igual que 10
        ldb #'A-'9-1
	mul
	addb temp_leer+1
        addb #'0
        stb pantalla

        ; imprimamos un salto de lInea al final
        ldb #'\n
        stb pantalla

        ; el programa acaba
        clra
	sta fin

	.org 0xFFFE	; vector de RESET
	.word programa
