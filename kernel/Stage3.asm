
;*******************************************************
;
;	Stage3.asm
;		A basic 32 bit binary kernel running
;
;	OS Development Series
;*******************************************************

[GLOBAL mboot]  
[global start]
                ; Make 'mboot' accessible from C.
[EXTERN code]                   ; Start of the '.text' section.
[EXTERN bss]                    ; Start of the .bss section.
[EXTERN end]  
[extern _kmain]

                  ; End of the last loadable section.




MBOOT_PAGE_ALIGN    equ 1<<0    ; Load kernel and modules on a page boundary
MBOOT_MEM_INFO      equ 1<<1    ; Provide your kernel with memory info
MBOOT_HEADER_MAGIC  equ 0x1BADB002 ; Multiboot Magic value
; NOTE: We do not use MBOOT_AOUT_KLUDGE. It means that GRUB does not
; pass us a symbol table.
MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)




bits	32				; 32 bit code

SECTION .mulboot    align 4

mboot:
    dd  MBOOT_HEADER_MAGIC      ; GRUB will search for this value on each
                                ; 4-byte boundary in your kernel file
    dd  MBOOT_HEADER_FLAGS      ; How GRUB should load your file / settings
    dd  MBOOT_CHECKSUM          ; To ensure that the above values are correct   
    dd  mboot                   ; Location of this descriptor
    dd  code                    ; Start of kernel '.text' (code) section.
    dd  bss                     ; End of kernel.
    dd  end                     ; End of kernel '.data' section.
    dd  start                   ; Kernel entry point (initial EIP).


section .text  align 4


start:

    push ebx

    cmp eax, 0x2BADB002
    jz .bootok
    mov ebx, msg_error
    call Puts32
    jmp .Done 
.bootok:
	call	ClrScr32
	mov	ebx, msg
	call	Puts32

  
    call _kmain

	;---------------------------------------;
	;   Stop execution			;
	;---------------------------------------;
.Done:
    add esp, 4
	cli
	hlt
    jmp $





%include "stdio.inc"

SECTION .data

msg db  0x0A, 0x0A, "                       - OS Development Series -"
    db  0x0A, 0x0A, "                     MOS 32 Bit Kernel Executing", 0x0A, 0
msg_error db "error! no multiboot", 0x0A, 0

