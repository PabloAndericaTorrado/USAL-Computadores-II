.module imprimir

finProg     .equ 0xFF01
pantalla    .equ 0xFF00
teclado     .equ 0xFF02

.globl imprime_cadena
.globl imprime_byte
.globl imprime_decimal

tempSalida:       .word 0      
centenas:         .byte 0      
decenas:          .byte 0      

imprime_cadena:
    pshs    A,X
sgte:
    lda     ,X+
    beq     ret_imprime_cadena
    sta     pantalla
    bra     sgte
ret_imprime_cadena:
    puls    A,X,PC

imprime_byte:
    pshs    A,B
    ldu     #0
    tfr     B,A
    ldb     #0
cent_bucle:
    cmpa    #100
    blo     fin_cent
    suba    #100
    incb
    bra     cent_bucle
fin_cent:
    tstb
    beq     pasar_cent
    addb    #'0'
    stb     pantalla
pasar_cent:
    ldb     #0
dec_bucle:
    cmpa    #10
    blo     fin_dec
    suba    #10
    incb
    bra     dec_bucle
fin_dec:
    tstb
    beq     pasar_dec
    addb    #'0'
    stb     pantalla
pasar_dec:
    adda    #'0'
    sta     pantalla
    puls    A,B,PC

imprime_decimal:
    pshs    A,B,X
    std     tempSalida
    clr     centenas
centenas_loop:
    cmpd    #100
    blo     fin_centenas
    subd    #100
    inc     centenas
    bra     centenas_loop
fin_centenas:
    pshs    D
    lda     centenas
    adda    #'0'
    sta     pantalla
    puls    D
    clr     decenas
decenas_loop:
    cmpd    #10
    blo     fin_decenas
    subd    #10
    inc     decenas
    bra     decenas_loop
fin_decenas:
    lda     decenas
    adda    #'0'
    sta     pantalla
    addb    #'0'
    stb     pantalla
    ldd     tempSalida
    puls    A,B,X,PC