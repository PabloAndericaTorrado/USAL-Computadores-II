        .area PROG (ABS)

        ; definimos una constante
fin     .equ 0xFF01
pantalla .equ 0xFF00

        .org 0x100
        
sumando1: .word 0x2190
sumando2: .word 0x1908

temp: .word 0

suma1:  .word 0
suma2:  .word 0

        .globl programa
programa:
        ; hagamos, primero, la suma con el registro D
        ldd sumando1
        addd sumando2
        std suma1
        
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
        std temp
        clra
        addb #246
        adca #0 ; en A hay un 1 si la primera cifra es mayor o igual que 10
        ldb #'A-'9-1
	mul
	addb temp+1
        addb #'0
        stb pantalla
        
        ; ahora imprimimos la segunda cifra hexadecimal
        ldb temp
        lslb
        lslb
        lslb
        lslb
        lsrb
        lsrb
        lsrb
        lsrb ; en B estA la segunda cifra, de 0 a 15
        std temp
        clra
        addb #246
        adca #0 ; en A hay un 1 si la segunda cifra es mayor o igual que 10
        ldb #'A-'9-1
	mul
	addb temp+1
        addb #'0
        stb pantalla
        
	; primero imprimamos la primera cifra hexadecimal
        lda suma1+1
        tfr a,b
        lsrb
        lsrb
        lsrb
        lsrb ; en B estA la primera cifra, de 0 a 15
        std temp
        clra
        addb #246
        adca #0 ; en A hay un 1 si la primera cifra es mayor o igual que 10
        ldb #'A-'9-1
	mul
	addb temp+1
        addb #'0
        stb pantalla
        
        ; ahora imprimimos la segunda cifra hexadecimal
        ldb temp
        lslb
        lslb
        lslb
        lslb
        lsrb
        lsrb
        lsrb
        lsrb ; en B estA la segunda cifra, de 0 a 15
        std temp
        clra
        addb #246
        adca #0 ; en A hay un 1 si la segunda cifra es mayor o igual que 10
        ldb #'A-'9-1
	mul
	addb temp+1
        addb #'0
        stb pantalla

        ; el programa acaba
        clra
        sta fin

        .org 0xFFFE     ; vector de RESET
        .word programa

