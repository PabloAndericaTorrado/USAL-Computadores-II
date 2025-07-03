.module leer

fin         .equ    0xFF01
pantalla    .equ    0xFF00
teclado     .equ    0xFF02

.globl leeByte
.globl leeDecimal

temporal:   .word   0

leeByte:
    pshs    A, X
    ldx     #0
    stx     temporal

    lda     teclado
    suba    #'0'
    ldb     #100
    MUL
    std     temporal

    lda     teclado
    suba    #'0'
    ldb     #10
    MUL
    addd    temporal
    std     temporal

    lda     teclado
    cmpa    #'\n'
    beq     fin_leeByte

    suba    #'0'
    tfr     A, B
    clra
    addd    temporal
    std     temporal

    cmpd    #255
    bls     fin_leeByte
    ldd     #255
    std     temporal

fin_leeByte:
    ldd     temporal
    ldb     temporal+1
    puls    A, X, PC

leeDecimal:
    pshs    X
    ldx     #0
    stx     temporal

    lda     teclado
    suba    #'0'
    ldb     #100
    MUL
    std     temporal

    lda     teclado
    suba    #'0'
    ldb     #10
    MUL
    addd    temporal
    std     temporal

    lda     teclado
    suba    #'0'
    tfr     A, B
    clra
    addd    temporal
    std     temporal

    cmpd    #999
    bls     fin_leeDecimal
    ldd     #999

fin_leeDecimal:
    puls    X, PC