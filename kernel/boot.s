;
; boot.s -- Kernel start location. Also defines multiboot header.
;           Based on Bran's kernel development tutorial file start.asm
;

MBOOT_PAGE_ALIGN    equ 1<<0    ; Load kernel and modules on a page boundary
MBOOT_MEM_INFO      equ 1<<1    ; Provide your kernel with memory info
MBOOT_HEADER_MAGIC  equ 0x1BADB002 ; Multiboot Magic value
; NOTE: We do not use MBOOT_AOUT_KLUDGE. It means that GRUB does not
; pass us a symbol table.
MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)


[BITS 32]                       ; All instructions should be 32-bit.

section .text

; Publics in this file
global mboot               
global _CpuEnableFpu
global _CpuEnableGpe
global start   
                
extern _kmain                   ; This is the entry point of our C code
extern code                   ; Start of the '.text' section.
extern bss                    ; Start of the .bss section.
extern end                    ; End of the last loadable section.

mboot:
    dd  MBOOT_HEADER_MAGIC      ; GRUB will search for this value on each
                                ; 4-byte boundary in your kernel file
    dd  MBOOT_HEADER_FLAGS      ; How GRUB should load your file / settings
    dd  MBOOT_CHECKSUM          ; To ensure that the above values are correct
    
    dd  mboot                   ; Location of this descriptor
    dd  code                    ; Start of kernel '.text' (code) section.
    dd  bss                     ; End of kernel '.data' section.
    dd  end                     ; End of kernel.
    dd  start                   ; Kernel entry point (initial EIP).


start:
    ; Load multiboot information:
    push esp
    push ebx

    ; Execute the kernel:
    cli                         ; Disable interrupts.
    call _kmain                   ; call our main() function.

    jmp $                       ; Enter an infinite loop, to stop the processor
                                ; executing whatever rubbish is in the memory
                                ; after our kernel!


 
; Assembly routine to enable fpu support
_CpuEnableFpu:
	mov eax, cr0
	bts eax, 1		; Set Monitor co-processor (Bit 1)
	btr eax, 2		; Clear Emulation (Bit 2)
	bts eax, 5		; Set Native Exception (Bit 5)
	btr eax, 3		; Clear TS
	mov cr0, eax

	finit           ;  Initialize Floating-Point Unit
	ret

; Assembly routine to enable global page support
_CpuEnableGpe:
	mov eax, cr4
	bts eax, 7		; Set Operating System Support for Page Global Enable (Bit 7)
	mov cr4, eax
	ret
