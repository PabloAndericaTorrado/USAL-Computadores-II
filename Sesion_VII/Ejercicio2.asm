.area PROG (ABS)

; Definición de constantes
fin     .equ 0xFF01       ; Dirección para finalizar el programa.
pantalla .equ 0xFF00      ; Dirección para escribir en pantalla.
teclado .equ 0xFF02       ; Dirección para leer del teclado.
menor   .equ 0xF100       ; Dirección para almacenar el menor valor encontrado.

.org 0x100                ; Inicio del programa en la dirección 0x100.

.globl programa           ; Declaración global del punto de entrada del programa.

programa:
    ldx #0xE000           ; Inicializamos el registro X con la dirección 0xE000, que se usará como buffer para almacenar datos.
leer:
    lda teclado           ; Leemos un carácter del teclado y lo cargamos en el registro A.
    sta ,x+               ; Almacenamos el carácter en la dirección apuntada por X y luego incrementamos X.
    cmpa #'\n             ; Comparamos el carácter leído con el salto de línea ('\n').
    beq buscarMenor       ; Si es un salto de línea, pasamos a buscar el menor valor.
    bra leer              ; Si no, continuamos leyendo caracteres.

buscarMenor:
    ldx #0xE000           ; Reiniciamos X para apuntar al inicio del buffer.
    lda #255              ; Cargamos el valor 255 (máximo posible) en A.
    sta menor             ; Inicializamos la variable `menor` con 255.

bucleMenor:
    lda ,x+               ; Cargamos el siguiente carácter del buffer en A.
    cmpa #'\n             ; Comparamos el carácter con el salto de línea ('\n').
    beq mostrarmenor      ; Si es un salto de línea, pasamos a mostrar el menor valor.
    bita #0x80            ; Probamos si el bit más significativo está activo (valor marcado).
    bne bucleMenor        ; Si está activo, ignoramos este valor y seguimos al siguiente.
    cmpa menor            ; Comparamos el valor actual con el menor encontrado hasta ahora.
    bhs bucleMenor        ; Si el valor actual es mayor o igual, seguimos al siguiente.
    sta menor             ; Si el valor actual es menor, lo guardamos como el nuevo menor.
    bra bucleMenor        ; Repetimos el bucle para procesar el siguiente valor.

mostrarmenor:
    lda menor             ; Cargamos el menor valor encontrado en A.
    cmpa #255             ; Comparamos el menor valor con 255 (valor inicial).
    beq acabar            ; Si no se encontró un valor menor, terminamos el programa.
    sta pantalla          ; Mostramos el menor valor en pantalla.

    ldx #0xE000           ; Reiniciamos X para apuntar al inicio del buffer.

marcarmenor:
    lda ,x+               ; Cargamos el siguiente carácter del buffer en A.
    cmpa #'\n             ; Comparamos el carácter con el salto de línea ('\n').
    beq buscarMenor       ; Si es un salto de línea, volvemos a buscar el menor valor.
    cmpa menor            ; Comparamos el carácter con el menor valor encontrado.
    bne marcarmenor       ; Si no coincide, seguimos al siguiente carácter.
    ora #0x80             ; Marcamos el valor añadiendo 1 al bit más significativo.
    sta -1,x              ; Guardamos el valor marcado en la posición anterior de X.
    bra marcarmenor       ; Repetimos el bucle para procesar el siguiente valor.

acabar:
    lda ,x+               ; Cargamos el siguiente carácter del buffer en A.
    cmpa #'\n             ; Comparamos el carácter con el salto de línea ('\n').
    lda #0x0A             ; Cargamos el carácter de nueva línea (LF) en A.
    sta pantalla          ; Mostramos la nueva línea en pantalla.

    clra                  ; Limpiamos el registro A.
    sta fin               ; Escribimos en la dirección `fin` para finalizar el programa.

.org 0xFFFE               ; Vector de RESET.
.word programa            ; Dirección de inicio del programa.