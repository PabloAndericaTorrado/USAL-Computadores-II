.module diagonal_dominante
.globl diagonal_dominante
.globl filas, columnas, imprime_cadena, imprime_decimal

.globl m, pantalla

; Constantes
pantalla    .equ 0xFF00
m           .equ 0xE000

; Variables temporales

fila_actual:    .byte 0
suma_fila:      .word 0
elemento_diag:  .word 0
es_dominante:   .byte 1  ; 1 = verdadero, 0 = falso
msgSuma:     .asciz "\nSuma: "
msgDiagonal: .asciz " | Diagonal: "

diagonal_dominante:
    pshs X,Y,D
    lda #1
    sta es_dominante      ; Inicializar en verdadero
    clr fila_actual       ; Reiniciar contador

bucle_filas:
    ; --- Paso 1: calcular inicio de la fila i ---
    lda fila_actual        ; A ← fila_actual (i)
    ldb columnas           ; B ← número de columnas
    mul                    ; D ← A*B = i*columnas
    lslb                   ; desplazar D_low << 1 → D_low = D_low*2
    rola                   ; desplazar D_high con carry → D = D*2
    ldx #m                 ; X ← base de la matriz (0xE000)
    leax D,X               ; X ← X + D = dirección del primer elemento de la fila i
    
    

; --- Obtener elemento diagonal (i,i) ---
    lda   fila_actual       ; A = i
    ldb   #2                ; B = tamaño elemento (2 bytes)
    mul                     ; D = i*2
    leay  D,X               ; Y = X + D = &matriz[i][i]
    ldd   ,Y                ; D = matriz[i][i]
    std   elemento_diag

; Calcular suma de la fila (excluyendo diagonal)
    ldd #0
    std suma_fila
    ldb #0              ; Contador de columna

; ================================================
; Bucle para recorrer cada columna de la fila actual
; y calcular la suma de los elementos (excluyendo la diagonal)
; ================================================
bucle_columnas:
    cmpb columnas          ; ¿Se procesaron todas las columnas?, si columnas es 3 sale del bucle columnas == b
    beq fin_fila           ; Si sí, salir del bucle

    cmpb fila_actual       ; ¿Es la columna actual la diagonal?
    beq saltar_diag        ; Si sí, saltar el elemento

    ; ---- Sumar elemento no diagonal ----
    ldd suma_fila         ; D = valor acumulado de suma_fila
    addd ,X               ; Sumar el elemento actual (D = D + [X])
    std suma_fila         ; Actualizar suma_fila

avanzar:
    leax 2,X               ; Avanzar X al siguiente elemento (2 bytes por elemento)
    incb                   ; Incrementar contador de columnas (B)
    bra bucle_columnas     ; Repetir bucle

; ---- Saltar elemento diagonal ----
saltar_diag:
    leax 2,X               ; Avanzar X sin sumar el valor 2 bytes
    incb
    bra bucle_columnas

fin_fila:
    ; ---- Comparar elemento diagonal con la suma de la fila ----
    ldd elemento_diag      ; Cargar elemento diagonal
    cmpd suma_fila         ; ¿Elemento diagonal >= suma de los demás elementos?
    bge sigue_ok           ; Si sí, continuar con la siguiente fila
    
    ; ---- Marcar matriz como no dominante ----
    clr es_dominante       ; es_dominante = 0 (falso)
    bra fin_comprobacion   ; Salir del bucle principal

sigue_ok:
    inc fila_actual        ; Incrementar número de fila
    lda fila_actual        
    cmpa filas             ; ¿Se procesaron todas las filas?
    blo bucle_filas        ; Si no, repetir bucle
    bra fin_comprobacion   ; Si sí, salir

fin_comprobacion:
    ldx #msgEsDominante    ; Cargar mensaje "ES dominante"
    tst es_dominante       ; Verificar flag es_dominante
    beq imprimir_resultado ; Si es 0, cargar mensaje "NO es dominante"
    ldx #msgNOEsDominante

imprimir_resultado:
    jsr imprime_cadena     ; Llamar a función de impresión
    lda #'\n               ; Salto de línea
    sta pantalla           ; Enviar a pantalla

    puls X,Y,D,PC          ; Restaurar registros y retornar

msgNOEsDominante:    
    .asciz "\nLa matriz NO diagonal dominante."
msgEsDominante:    
    .asciz "\nLa matriz ES es diagonal dominante."