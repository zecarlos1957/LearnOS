%define KERNEL_DATA_SEGMENT 0x10
%define KERNEL_CODE_SEGMENT 0x08

section .text

[GLOBAL _gdt_flush]
_gdt_flush:
    mov eax, [esp + 4]
    lgdt [eax]

    mov ax, KERNEL_DATA_SEGMENT
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    jmp KERNEL_CODE_SEGMENT:flush 
flush:
    ret

[global _tss_flush] 

_tss_flush:
    mov ax, 0x28 ; (0x28 for 6� entry)  0x2B 
    ltr ax
    ret
