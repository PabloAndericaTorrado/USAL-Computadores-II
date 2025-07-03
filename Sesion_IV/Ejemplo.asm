.area PROG (ABS)

        ; definimos una constante
fin     .equ 0xFF01
pantalla .equ 0xFF00

	.org 0x100

	.globl programa
programa:
        lda #137 ; un nUmero como cualquier otro, para probar    hay que usar D y hay que aplicar el metodo de la segunda cifra

        ; primera cifra
        ldb #'0
        cmpa #100
        blo Menor100
        suba #100
        incb
        cmpa #100
        blo Menor200
        incb
        suba #100
Menor100:
Menor200:
        stb pantalla

        ; segunda cifra.  En A quedan las dos Ultimas cifras
        clrb
        cmpa #80
        blo Menor80
        incb
        suba #80
Menor80:lslb
        cmpa #40
        blo Menor40
        incb
        suba #40
Menor40:lslb
        cmpa #20
        blo Menor20
        incb
        suba #20
Menor20:lslb
        cmpa #10
        blo Menor10
        incb
        suba #10
Menor10:addb #'0
        stb pantalla
        adda #'0
        sta pantalla

        ; imprimimos un salto de lInea
        ldb #'\n
        stb pantalla

        ; el programa acaba
        clra
	sta fin

	.org 0xFFFE	; vector de RESET
	.word programa