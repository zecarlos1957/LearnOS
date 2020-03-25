section .text

global start
extern _kmain

start:
    pop ebx
;    mov ax, 0x10 
;    mov  ds, ax 
;    mov  es, ax 
;    mov  ss, ax 
;    mov esp, _sys_stack
 
    push ebx              ; multiboot info 
    call _kmain

 
.hang:
    jmp .hang
    
section .bss
   resb 0x1000    
_sys_stack: 