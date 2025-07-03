.module leer

fin         .equ    0xFF01
pantalla    .equ    0xFF00
teclado     .equ    0xFF02

.globl leeByte
.globl leeDecimal

temporal:   .word   0

num1: .byte 0
num2: .byte 0

leeByte: ; convierte 2 dígitos ASCII → 0–99
    lda  teclado      ; Lee un byte
    suba #48          ; Resta 48 decimal (‘0’ en ASCII) → convierte ASCII en número
    sta  num1         ; Almacena ese valor 

    lda  teclado      
    suba #48          
    sta  num2         

    ldb  #10          ; Carga en B el valor 10 
    lda  num1         ; Carga en A num1
    mul               ; Lo multiplica para que sea decena
    addb num2         ; Suma num2

    rts               ; return con el resultado en D


leeDecimal: ; convierte 3 dígitos ASCII → 0–999
    pshs    X               ; Guarda X en pila
    ldx     #0              ; Inicializa X=0 
    stx     temporal        ; Guarda 0

    lda     teclado         ; Lee primer dígito ASCII 
    suba    #'0             ; Lo mismo que suba #48 pero de otra manera
    ldb     #100            ; Carga en B el valor 100
    mul                     ; Lo multiplica para que sea centena
    std     temporal        ; Guarda resultado

    lda     teclado         
    suba    #'0             
    ldb     #10             
    mul                     
    addd    temporal
    std     temporal

    lda     teclado         
    suba    #'0'           
    tfr     A, B            ; Copia el contenido de A en B
    clra                    ; Limpia A para tener el nº en 16 bits
                            ;A = 0000 B = Nº
    addd    temporal         
    std     temporal        

    cmpd    #999            
    bls     fin_leeDecimal  ; 22) Si ≤999 salta a fin 
    ldd     #999            ; 23) Si >999, fuerza D=999

fin_leeDecimal:
    puls    X, PC