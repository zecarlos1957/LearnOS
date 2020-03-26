section .text

global start
extern _kmain

start:
    pop ebx
    mov esp, _sys_stack
 
    push ebx              ; multiboot info 
    call _kmain

 
.hang:
    jmp .hang
    
section .bss
   resb 0x1000    
_sys_stack: 