.area PROG (ABS)

// Definición de constantes
fin        .equ 0xFF01
pantalla   .equ 0xFF00
teclado    .equ 0xFF02

// Definición de variables
numero:    .word 0  

// Inicio del programa en la dirección 0x100
.org 0x100
.globl programa

programa:
    // Leer valor del teclado y convertirlo a número
    lda teclado
    suba #48
    
    // Multiplicar el valor por 50 y luego por 200, almacenar en 'numero'
    ldb #50
    mul
    lda #200
    mul
    std numero

    // Leer valor del teclado y convertirlo a número
    lda teclado
    suba #48
    
    // Multiplicar el valor por 20 y luego por 50, sumar a 'numero'
    ldb #20
    mul
    lda #50
    mul
    addd numero
    std numero

    // Leer valor del teclado y convertirlo a número
    lda teclado
    suba #48
    
    // Multiplicar el valor por 100, sumar a 'numero'
    ldb #100
    mul
    addd numero
    std numero

    // Leer valor del teclado y convertirlo a número
    lda teclado
    suba #'0'
    
    // Multiplicar el valor por 10, sumar a 'numero'
    ldb #10
    mul
    addd numero
    std numero

    // Leer valor del teclado y convertirlo a número
    ldb teclado
    subb #48
    clra
    
    // Sumar el valor a 'numero'
    addd numero
    std numero

    // Verificar si el número es par o impar
    lda numero+1       
    anda #0x02
    beq verificar       
    bra no             

verificar:
    // Inicializar registros A y B a 0
    clra
    clrb

bucle:
    // Transferir el valor de D a X y multiplicar
    tfr d,x
    mul
    
    // Comparar el resultado con 'numero'
    cmpd numero
    beq si
    bhi no
    
    // Incrementar A y B y repetir el bucle
    tfr x,d
    inca
    incb
    bra bucle

no:
    // Imprimir mensaje "NO" en pantalla
    lda #0x0A          ; Cargar el carácter de nueva línea (LF)
    sta pantalla       ; Imprimir nueva línea
    lda #78            ; 'N'
    sta pantalla
    lda #79            ; 'O'
    sta pantalla
    lda #10            ; Nueva línea
    sta pantalla
    bra acabar

si:
    // Imprimir mensaje "SI" en pantalla
    lda #0x0A          ; Cargar el carácter de nueva línea (LF)
    sta pantalla       ; Imprimir nueva línea
    lda #83            ; 'S'
    sta pantalla
    lda #73            ; 'I'
    sta pantalla
    lda #10            ; Nueva línea
    sta pantalla
    bra acabar

acabar:
    // Finalizar el programa
    clra
    sta fin

// Dirección de inicio del programa
.org 0xFFFE
.word programa