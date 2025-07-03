.area PROG (ABS)

fin     .equ 0xFF01
pantalla .equ 0xFF00
temp_leer    .byte 0     

        ; Definimos la posición de memoria inicial
        .org 0x100

        .globl programa
programa:
        ; Cargamos el número 987 en el registro D
        ldd #987

        ;=== Extracción de centenas ===

        ; Primera cifra (centenas)
        cmpd #800      ; Compara D (987) con 800
        blo Menor800   ; Si D < 800, salta a Menor800 (no salta)
        inc temp_leer       ; Incrementa temp (temp = 1)
        subd #800      ; Resta 800 de D (D = 187)
        
Menor800:
        lsl temp_leer       ; Desplaza temp a la izquierda (temp = 2)
        cmpd #400      ; Compara D (187) con 400
        blo Menor400   ; Si D < 400, salta a Menor400 (salta)
        
Menor400:
        lsl temp_leer       ; Desplaza temp a la izquierda (temp = 4)
        cmpd #200      ; Compara D (187) con 200
        blo Menor200   ; Si D < 200, salta a Menor200 (salta)
        
Menor200:
        lsl temp_leer       ; Desplaza temp a la izquierda (temp = 8)
        cmpd #100      ; Compara D (187) con 100
        blo Menor100   ; Si D < 100, salta a Menor100 (no salta)
        inc temp_leer       ; Incrementa temp (temp = 9)
        subd #100      ; Resta 100 de D (D = 87)
        
Menor100:
        ; Guardamos la primera cifra (centenas) en pantalla
        tfr b,a        ; Transfiere el valor de B a A (A = 7)
        ldb temp_leer       ; Carga temp en B (B = 9)
        addb #'0'      ; Convierte el valor a ASCII (B = '9')
        stb pantalla   ; Almacena el valor en pantalla (pantalla = '9')

        ;=== Extracción de decenas ===

        ; Segunda cifra (decenas)
        clrb           ; Limpia el registro B (B = 0)
        cmpa #80       ; Compara A (87) con 80
        blo Menor80    ; Si A < 80, salta a Menor80 (no salta)
        incb           ; Incrementa B (B = 1)
        suba #80       ; Resta 80 de A (A = 7)
        
Menor80:
        lslb           ; Desplaza B a la izquierda (B = 2)
        cmpa #40       ; Compara A (7) con 40
        blo Menor40    ; Si A < 40, salta a Menor40 (salta)
        
Menor40:
        lslb           ; Desplaza B a la izquierda (B = 4)
        cmpa #20       ; Compara A (7) con 20
        blo Menor20    ; Si A < 20, salta a Menor20 (salta)
        
Menor20:
        lslb           ; Desplaza B a la izquierda (B = 8)
        cmpa #10       ; Compara A (7) con 10
        blo Menor10    ; Si A < 10, salta a Menor10 (salta)
        
Menor10:
        addb #'0'      ; Convierte el valor a ASCII (B = '8')
        stb pantalla   ; Almacena el valor en pantalla (pantalla = '8')

        ;=== Extracción de unidades ===

        ; Tercera cifra (unidades)
        adda #'0'      ; Convierte el valor a ASCII (A = '7')
        sta pantalla   ; Almacena el valor en pantalla (pantalla = '7')

        ; Imprimimos un salto de línea
        lda #'\n'
        sta pantalla

        ; El programa acaba
        clra
        sta fin

        ; Vector de RESET
        .org 0xFFFE
        .word programa