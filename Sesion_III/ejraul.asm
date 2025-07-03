.area PROG (ABS)
pantalla  .equ 0xFF00  ; Dirección de salida a pantalla
teclado   .equ 0xFF02  ; Dirección de entrada desde teclado
fin       .equ 0xFF01  ; Dirección para finalizar el programa
	.org 0x0100
	.globl programa
	
num1:   .byte 0  ; Primer número BCD
num2:   .byte 0  ; Segundo número BCD
resultado: .byte 0  ; Resultado en un byte BCD
programa:
	; Leer primer dígito
	lda teclado       ; Lee del teclado el primer carácter
	suba #48          ; Convierte ASCII a valor numérico (0-9)
	lsla              ; Desplaza 4 bits a la izquierda
	lsla              ; para colocarlo en la posición alta
	lsla
	lsla
	sta num1          ; Guarda en num1
	
	; Leer segundo dígito
	lda teclado       ; Lee del teclado el segundo carácter
	suba #48          ; Convierte ASCII a valor numérico (0-9)
	anda #0x0F        ; Asegura que solo los 4 bits bajos tengan valor
	adda num1         ; Combina usando suma en vez de OR
	sta num1          ; Guarda el número BCD completo
	
	; Imprimir espacio
	lda #32           ; Espacio ASCII
	sta pantalla
	
	; Leer tercer dígito
	lda teclado       ; Lee del teclado el tercer carácter
	suba #48          ; Convierte ASCII a valor numérico (0-9)
	lsla              ; Desplaza 4 bits a la izquierda
	lsla              ; para colocarlo en la posición alta
	lsla
	lsla
	sta num2          ; Guarda en num2
	
	; Leer cuarto dígito
	lda teclado       ; Lee del teclado el cuarto carácter
	suba #48          ; Convierte ASCII a valor numérico (0-9)
	anda #0x0F        ; Asegura que solo los 4 bits bajos tengan valor
	adda num2         ; Combina usando suma en vez de OR
	sta num2          ; Guarda el número BCD completo
	
	; Salto de línea
	lda #10           ; Nueva línea en ASCII
	sta pantalla
	
	; A partir de aquí mostramos los números para la línea de resumen
	; Mostrar primer número (dígitos 1 y 2)
	lda num1
	lsra              ; Desplaza 4 bits a la derecha para obtener
	lsra              ; el primer dígito de la posición alta
	lsra
	lsra
	adda #48          ; Convierte de nuevo a ASCII
	sta pantalla      ; Muestra el primer dígito
	
	lda num1
	anda #0x0F        ; Máscara para obtener el segundo dígito
	adda #48          ; Convierte a ASCII
	sta pantalla      ; Muestra el segundo dígito
	
	; Imprimir '+'
	lda #43           ; ASCII '+'
	sta pantalla
	
	; Mostrar segundo número (dígitos 3 y 4)
	lda num2
	lsra              ; Obtiene el tercer dígito
	lsra
	lsra
	lsra
	adda #48          ; Convierte a ASCII
	sta pantalla      ; Muestra el tercer dígito
	
	lda num2
	anda #0x0F        ; Obtiene el cuarto dígito
	adda #48          ; Convierte a ASCII
	sta pantalla      ; Muestra el cuarto dígito
	
	; Imprimir '='
	lda #61           ; ASCII '='
	sta pantalla
	
	; Sumar los dos números BCD
	lda num1
	adda num2
	daa               ; Ajuste decimal para BCD
	sta resultado
	
	; Mostrar el resultado
	lda resultado
	lsra              ; Obtiene las decenas del resultado
	lsra
	lsra
	lsra
	adda #48          ; Convierte a ASCII
	sta pantalla      ; Muestra el primer dígito del resultado
	
	lda resultado
	anda #0x0F        ; Obtiene las unidades del resultado
	adda #48          ; Convierte a ASCII
	sta pantalla      ; Muestra el segundo dígito del resultado
	
	; Nueva línea final
	lda #10
	sta pantalla
	
	; Finalizar programa
	clra
	sta fin
	
	.org 0xFFFE       ; Vector de RESET
	.word programa
