section .text

global start
extern _kmain

start:
 
    call _kmain

 
.hang:
    jmp .hang
