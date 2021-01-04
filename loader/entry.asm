

bits 32

section .bss
align 16
stack_bottom:
 resb 32768 
stack_top:

section .text

  
global start
global _mmap_ent
global _lower_mem

extern __main
 
start:

    mov esp, stack_top
    mov ebp, esp

    call  __main
    
done:
    hlt
    jmp done


section .data

_mmap_ent:
    dw 6   ; 0x77fc
_lower_mem:
    dw 0x1000   ; 0x77fe
