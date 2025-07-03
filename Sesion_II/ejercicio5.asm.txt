.area PROG (ABS)

        ; definimos una constante
fin     .equ 0xFF01

        .org 0x100
        
suma1: .word 0x1234
suma2: .byte 2
suma3: .byte -1

        .globl programa
programa:
        ; sumamos una variable de dos bytes (16) con una de otro de 8 bits sin signo
        ldx suma1 ; cargamos en x suma1
        ldb suma2 ; cargamos en b suma2
        abx ; instruccion especial para sumar 16 bits con 8 bits

	; sumamos una variable de dos bytes (16) con una de otro de 8 bits con signo
	ldb suma3 ; cargamos el negativo en b
	sex ; para extender el signo
	addd suma1
	
        ; el programa acaba
        clra
        sta fin

        .org 0xFFFE     ; vector de RESET
        .word programa
