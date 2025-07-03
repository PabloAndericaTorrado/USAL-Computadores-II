        .area   CODE (ABS)
        .org    0x1000

        ; Haz global la etiqueta de inicio (a veces el linker
        ; solo "ve" la salida si hay algo público).
        .globl  START

START:
        nop
        rts

        .end
