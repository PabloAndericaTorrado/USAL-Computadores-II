.area PROG (ABS)

// Definición de constantes
fin        .equ 0xFF01
pantalla   .equ 0xFF00
teclado    .equ 0xFF02

// Definición de variables
nota:       .word 0
impar_actual: .word 0

// Mensajes
msg_si:    .ascii "SI"
           .byte 0x0A, 0x00
msg_no:    .ascii "NO"
           .byte 0x0A, 0x00

// Inicio del programa en la dirección 0x100
.org 0x100
.globl programa

programa:
    // Leer valor del teclado y convertirlo a número
    lda  teclado
    suba #'0'
    
    // Multiplicar el valor por 50 y luego por 200, almacenar en 'nota'
    ldb  #50
    mul
    lda  #200
    mul
    std  nota

    // Leer valor del teclado y convertirlo a número
    lda  teclado
    suba #'0'
    
    // Multiplicar el valor por 20 y luego por 50, sumar a 'nota'
    ldb  #20
    mul
    lda  #50
    mul
    addd nota
    std  nota

    // Leer valor del teclado y convertirlo a número
    lda  teclado
    suba #'0'
    
    // Multiplicar el valor por 100, sumar a 'nota'
    ldb  #100
    mul
    addd nota
    std  nota

    // Leer valor del teclado y convertirlo a número
    lda  teclado
    suba #'0'
    
    // Multiplicar el valor por 10, sumar a 'nota'
    ldb  #10
    mul
    addd nota
    std  nota

    // Leer valor del teclado y convertirlo a número
    ldb  teclado
    subb #'0'
    clra
    
    // Sumar el valor a 'nota'
    addd nota
    std  nota

    // Cargar el valor de 'nota' y verificar si es cero
    ldd nota
    beq encontrado
    
    // Inicializar impar_actual a 1
    ldx #1
    stx impar_actual

comparar:
    // Restar impar_actual de 'nota'
    subd impar_actual
    beq encontrado
    blt no_encontrado
    
    // Incrementar impar_actual en 2
    ldx impar_actual
    leax 2,x
    stx impar_actual
    bra comparar

no_encontrado:
    // Imprimir mensaje "NO" en pantalla
    lda #0x0A
    sta pantalla
    ldx #msg_no
    bra imprimir

encontrado:
    // Imprimir mensaje "SI" en pantalla
    lda #0x0A
    sta pantalla
    ldx #msg_si
    bra imprimir

imprimir:
    // Imprimir caracteres del mensaje en pantalla
    lda ,x+
    beq final
    sta pantalla
    bra imprimir

final:
    // Finalizar el programa
    clra
    sta fin

// Dirección de inicio del programa
.org 0xFFFE
.word programa