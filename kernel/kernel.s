section .text

global start
extern _kmain

start:
    mov ax, 0x10 
    mov  ds, ax 
    mov  es, ax 
    mov  ss, ax 
 
    call _kmain

 
.hang:
    jmp .hang
