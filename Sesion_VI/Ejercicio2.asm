        .area PROG (ABS)

fin     .equ 0xFF01
pantalla .equ 0xFF00
teclado .equ 0xFF02
pila    .equ 0xF000

        .org 0x100
        .globl programa

programa:
        lds #pila          

leer:   
        lda teclado        
        cmpa #10            
        beq bucle        

        cmpa #32            
        blo leer            

        pshu a              
        bra leer            

bucle:  
        cmpx, u             
        beq fin_programa    

        pulu a              
        sta pantalla        
        bra bucle           

fin_programa:
        lda #0x0A          ; Cargar el carácter de nueva línea (LF)
        sta pantalla       ; Imprimir nueva línea
        clra
        sta fin             ; Terminar programa

        .org 0xFFFE         ; Vector de RESET
        .word programa

