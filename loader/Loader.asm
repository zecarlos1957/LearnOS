bits 16
org 0x500

start: jmp load

;***************************************************;
;	Preprocessor directives
;***************************************************;

%include "stdio.inc"    ; basic i/o routines
%include "gdt.inc"		; Gdt routines
%include "a20.inc"		; A20 enabling
%include "fat12.inc"	; FAT12 driver
%include "common.inc"
%include "bootinfo.inc"
%include "memory.inc"

;***************************************************;
;	Data Section
;***************************************************;

LoadingMsg db 0x0D, 0x0A, "Searching for Operating System...", 0x00
msgFailure db 0x0D, 0x0A, "*** FATAL: MISSING OR CURRUPT KRNL.SYS. Press Any Key to Reboot", 0x0D, 0x0A, 0x0A, 0x00

boot_info:
istruc multiboot_info
	at multiboot_info.flags,				dd 0
	at multiboot_info.memoryLo,				dd 0
	at multiboot_info.memoryHi,				dd 0
	at multiboot_info.bootDevice,			dd 0
	at multiboot_info.cmdLine,				dd 0
	at multiboot_info.mods_count,			dd 0
	at multiboot_info.mods_addr,			dd 0
	at multiboot_info.syms0,				dd 0
	at multiboot_info.syms1,				dd 0
	at multiboot_info.syms2,				dd 0
	at multiboot_info.mmap_length,			dd 0
	at multiboot_info.mmap_addr,			dd 0
	at multiboot_info.drives_length,		dd 0
	at multiboot_info.drives_addr,			dd 0
	at multiboot_info.config_table,			dd 0
	at multiboot_info.bootloader_name,		dd 0
	at multiboot_info.apm_table,			dd 0
	at multiboot_info.vbe_control_info,		dd 0
	at multiboot_info.vbe_mode_info,		dw 0
	at multiboot_info.vbe_interface_seg,	dw 0
	at multiboot_info.vbe_interface_off,	dw 0
	at multiboot_info.vbe_interface_len,	dw 0
iend

load:
;---------------------------------------------------;
;   Setup segments and stack
;---------------------------------------------------;
    cli			    ; clear interrupts
    xor	ax, ax		; null segments
    mov	ds, ax
    mov	es, ax
    mov	ax, 0x0000	; stack begins at 0x9000-0xffff
    mov	ss, ax
    mov	sp, 0xFFFF
    sti				; enable interrupts

    mov [boot_info+multiboot_info.bootDevice], dl

    call EnableA20
	call InstallGDT
    sti

    xor eax, eax
	xor ebx, ebx
	call BiosGetMemorySize64MB

	push eax
	mov eax, 64
	mul ebx
	mov ecx, eax
	pop eax
	add eax, ecx
	add eax, 1024

	mov dword [boot_info+multiboot_info.memoryHi], 0
	mov dword [boot_info+multiboot_info.memoryLo], eax

	mov eax, 0x0
	mov ds, ax
	mov di, 0x1000
	call BiosGetMemoryMap

;---------------------------------------------------;
;   Print loading message
;---------------------------------------------------;
    mov	si, LoadingMsg
    call Puts16

	call LoadRoot
    mov	ebx, 0			        ; BX:BP points to buffer to load to
    mov	bp, IMAGE_RMODE_BASE
    mov	si, ImageName		    ; our file to load
    call LoadFile		        ; load our file
    mov	dword [ImageSize], ecx	; save size of kernel
    cmp	ax, 0			        ; Test for success
    je EnterKernel		        ; yep--onto kernel!
    mov	si, msgFailure		    ; Nope--print error
    call Puts16
    mov	ah, 0
	int 0x16
	int 0x19

;---------------------------------------------------;
;   Go into pmode
;---------------------------------------------------;
EnterKernel:
    cli				        ; clear interrupts
    mov	eax, cr0		    ; set bit 0 in cr0--enter pmode
    or eax, 1
    mov	cr0, eax

    jmp	CODE_DESC:Kernel    ; far jump to fix CS. Remember that the code selector is 0x8!

;***************************************************;
;	ENTRY POINT KERNEL 3
;***************************************************;
bits 32

Kernel:
;---------------------------------------------------;
;   Set registers
;---------------------------------------------------;
	mov	ax, DATA_DESC	; set data segments to data selector (0x10)
	mov	ds, ax
	mov	es, ax
	mov ss, ax 
	mov	esp, 0x90000		; stack begins from 90000h

;---------------------------------------------------;
; Copy kernel to 1MB
;---------------------------------------------------;
CopyImage:
    mov	eax, dword [ImageSize]
    movzx ebx, word [bpbBytesPerSector]
    mul	ebx
    mov	ebx, 4
    div	ebx
    cld
    mov esi, IMAGE_RMODE_BASE
    mov	edi, IMAGE_PMODE_BASE
    mov	ecx, eax
    rep	movsd                           ; copy image to its protected mode address

;---------------------------------------------------;
;   Execute Kernel
;---------------------------------------------------;

	cli

	mov eax, 0x2badb002			        ; multiboot specs say eax should be this
	mov ebx, 0
	mov edx, [ImageSize]
	
	push dword boot_info
    jmp IMAGE_PMODE_BASE      ; jump to kernel Note: This assumes Kernel's entry point is at 1 MB
    add esp, 4

;---------------------------------------------------;
;   Stop execution
;---------------------------------------------------;
	cli
	hlt

