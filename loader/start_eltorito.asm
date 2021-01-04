
%ifdef STAGE1_5 
%define STAGE_ADDR         0x2000
%else 
%define STAGE_ADDR         0x8000
%define STAGE_PE_HEADER    0x0800
%endif
%define STAGE1_STACKSEG    0x2000
%define GRUB_INVALID_DRIVE 0xFF

; shared
%define SECTOR_SIZE        0x200
%define SECTOR_BITS          9
%define BOOTSEC_LISTSIZE     8

%define STAGE2_SIZE 0

; Section table
%define IMAGE_SCN_CNT_CODE        0x00000020
%define IMAGE_INITIALIZED_DATA    0x00000040
%define IMAGE_UNINITIALIZED_DATA  0x00000080
%define IMAGE_SCN_LNK_INFO        0x00000800

; iso9660
%define ISO_SECTOR_BITS    11 
%define ISO_SECTOR_SIZE   0x800 


bits 16

; section .text
  org 0x7c00
  
global start
 
;
; Primary entry point.	 Because BIOSes are buggy, we only load the first
; CD-ROM sector (2K) of the file, so the number one priority is actually
; loading the rest.
;


start:
    cli
    jmp real_start
    
    align 8
    
bi_pvd:		 dd 0xDEADBEEF	    ; LBA of primary volume descript 
bi_file:	 dd 0xDEADBEEF	    ; LBA of boot file  
bi_length:	 dd 0xDEADBEEF	    ; Length of boot file  
bi_csum:	 dd 0xDEADBEEF	    ; Checksum of boot file  
bi_reserved: dd 0,0,0,0,0,0,0,0,0,0	; Reserved  

real_start:
    xor ax, ax
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, STAGE1_STACKSEG
    
    sti
    cld
    mov [BootDrive], dl
    mov si, notification_string
    call message

    ; read 2º sector
    mov eax, 1 ; sectores to read
    mov bp, ax
    mov bx, STAGE_PE_HEADER>>4 ; dest addr
    mov es, bx
    xor ebx, ebx
    mov eax, [bi_file]  ; source addr
    add eax, 1          ; 2º sector
    call getlinsec
    
    ; Validate PE file
    mov ebx, 0x3c 
    mov eax, [es:ebx]
    mov ebx, [es:eax]
    cmp ebx, 0x00004550
    jz pass1
    mov si, pe_err
    call message
    jmp halt
    
    ; Parse optional header
pass1:
    add eax, 24          ;x898 set pointer to optional header
    mov bx, [es:eax]
    cmp bx, 0x010b
    jnz halt
    add eax, 16
    mov ebx, [es:eax] ; entry point
    mov [JumpAddr], ebx
    add eax, 76
    mov ecx, [es:eax] ; Number of DATA_DIRECTORY entries
    xor ebx, ebx
    mov bx, es
    add eax, 8+4       ; ???
    shl ebx, 4         ; lodsb get data from ds:si
    add ebx,eax        ; we need set correct offset in si
    mov si, bx         ; from ds=0 to print msg correct
    xor eax, eax
    mov es, ax
    xor ebx, ebx
.nxt:
    mov eax, [ds:si+36] ; Characteristics
    and eax, IMAGE_SCN_CNT_CODE
    jz .nxt_sect
 ;       mov ebx, [ds:si+12] ; Virtual addr
    
 ;       mov eax, [ds:si+16] ; Size raw data
 ;       mov bp, ax

        push word 16  ; base
        push word 4   ; width
        push ax       ; value
        call itoa
        add sp, 6

        pusha         ; backup context
        mov si,notification_done
        call message
        popa         ; restore context

.nxt_sect:
    add si, 40
    dec cx
    cmp cx, 0
    jnz .nxt 

load_text:
    
jmp $
	; Set up boot file sector, size, load address 
	mov eax, [bi_length]
	add eax, ISO_SECTOR_SIZE-1
	shr eax, ISO_SECTOR_BITS    ;  dwords->sectors
	add eax, 6 ; for now adjust manualy the correct size of NTLDR.exe
	mov bp, ax                  ; boot file sectors
	mov bx, (STAGE_ADDR>>4)
	mov es, bx
	xor bx, bx
	mov eax, [bi_file]
	add eax, 1
	call getlinsec

    mov si, notification_done
    call message

    clc
    int 0x12
    mov [_lower_mem], ax
    
    xor di, di
    mov ax, 0x500
    mov es, ax
    call do_e820
halt:
    jc halt
    jmp Real_to_Prot
     
do_e820:
    xor ebx, ebx
    xor bp, bp
    mov edx, 0x534d4150
    mov eax, 0xe820
    mov [es:di+20],byte 1
    mov ecx, 24
    int 0x15
    jb .failed
    mov edx, 0x534d4150
    cmp eax, edx
    jne .failed
    jmp .jmpin
.e820p:
    mov eax, 0xe820
    mov [es:di+20],byte 1
    mov ecx, 24
    int 0x15
    jb .e820f
    mov edx, 0x534d4150
.jmpin:
    jcxz .skipent
    cmp cl, 20
    jbe .notext
    test [es:di+20],byte 1
    je .skipent
.notext:
    mov ecx, [es:di+8]
    or ecx, [es:di+12]
    jz .skipent
    inc bp
    add di, 24
.skipent:
    test ebx, ebx
    jne .e820p
.e820f:
    mov [_mmap_ent], bp
    clc
    ret
.failed:
    stc
    ret
    
;****************************************************

;
; Get linear sectors - EBIOS LBA addressing, 2048-byte sectors.
;
; Note that we can't always do this as a single request, because at least
; Phoenix BIOSes has a 127-sector limit.  To be on the safe side, stick
; to 16 sectors (32K) per request.
;
; Input:
;	 EAX	 - Linear sector number
;	 ES:BX	 - Target buffer
;	 BP	 - Sector count
;

getlinsec:
	mov	si, dapa 		   ; Load up the DAPA  
	mov	[si+4], bx
	mov	bx, es
	mov	[si+6], bx
	mov	[si+8], eax
.p1:
	push	bp
	push	si
	cmp bp, [MaxTransfer] 
	jbe	.p2
	mov	bp,[MaxTransfer] 
.p2:
	mov [si+2], bp
	mov	dl, [BootDrive]  
	mov	ah, 0x42 		    ; Extended Read  
	call	xint13
	pop	si
	pop	bp
	movzx eax, word[si+2]  	; Sectors we read  
	add [si+8], eax		; Advance sector pointer  
	sub	bp, ax		    ; Sectors left  
	shl	ax, ISO_SECTOR_BITS-4     ; 2048-byte sectors -> segment  
	add	[si+6], ax		    ; Advance buffer pointer  

	pushad 
	mov si, notification_step
	call message
	popad
	cmp	bp, 0
	ja	.p1
	mov	 eax, [si+8]		; Return next sector  
	ret

 
xint13:
    mov byte[RetryCount], 6
    pushad
.try:
    int 0x13
    jc .p1
    add sp, 32
    ret
.p1:
    mov dl, ah
    dec byte[RetryCount]
    jz .real_error
    mov al, [RetryCount]
    mov ah, [dapa+2]
    cmp al, 2
    ja .p2
    mov ah, 1
    jmp .setmaxtr
.p2:
    cmp al, 3
    ja .p3
    shr ah, 1
    adc ah, 0
.setmaxtr:
    mov [MaxTransfer], ah
    mov [dapa+2], ah
.p3:
    popad
    jmp .try
    
.real_error:
    mov si, read_error_string
    call message
;    mov al, dl
;    call printhex2
    popad
    jmp halt
    
;*****************************************************



; itoa(dword number, byte width, byte radix)
; Format number as string of width in radix. Returns pointer to string.

itoa:
    pusha
    mov ebp, esp

    ; Start at end of output string and work backwards.
    lea edi, [output + 32]
    std

    ; Load number and radix for division and iteration.
    mov ax, [bp + 18] ; number

    movzx ebx, word [bp + 22] ; radix

    ; Loop width times.
    movzx ecx, word[bp + 20] ; width

   .loop:
        ; Clear remainder / upper bits of dividend.
        xor edx, edx
    
        ; Divide number by radix.
        div bx

        ; Use remainder to set digit in output string.
        lea esi, [digits + edx]
        movsb

    loop .loop

  ; The last movsb brought us too far back.
    lea eax, [edi + 1]

    cld
    mov si, ax
    call message
    mov esp, ebp
    popa
    ret
  
  
print:
    mov bx, 1
    mov ah, 0x0e
    int 0x10
message:
    lodsb
    or al, al
    jne print
    ret

printhex2:
    pusha
    rol eax, 24
    mov cx, 2
    jmp p10
printhex4:
    pusha
    rol eax, 16
    mov cx, 4
    jmp p10
printhex8:
    pusha
    mov cx, 8
p10:    
    rol eax, 4
    push eax
    and al, 0x0f
    cmp al, 10
    jae high
low:
    add al, '0'
    jmp p20
high:
    add al, 'A'-10
p20:
    mov bx, 0x1
    mov ah, 0x0e
    int 0x10
    pop eax
    loop p10
    popa
    ret
    
;**************************************************   
Real_to_Prot:
    cli
    
    in al, 0x92
    or al, 2
    out 0x92, al
    
    xor eax, eax
    mov ax, ds
    shl eax, 4
    add eax, gdtr_base
    mov [gdtr+2], eax
    mov eax, gdtr_end
    sub eax, gdtr_base
    mov [gdtr], ax
    lgdt [gdtr]
    
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x08:protect
    
protect:
 bits 32
 
    mov eax, STAGE_ADDR
    add eax, 0x400  ; PE header size
    call eax
    
endloop:
    hlt
    jmp endloop

;*************************************************


notification_string db "Loading stage2 ",0x0    

 
notification_spc 	db " ",0x0
notification_step 	db ".",0x0
notification_done 	db 0x0d,0x0a,0x0
read_error_string	db "Read error 0x",0x0
pe_err db "not a pe file", 0
pe_ok db "PE ok",0

	align 8
gdtr:
    dw 0
    dd 0

gdtr_base:
     ; NULL segment
    dd 0, 0   
    dw 0xffff, 0  
    ; code segment
    db 0, 0x9a, 0xcf, 0
    ; data segment
    dw 0xffff, 0
    db 0, 0x92, 0xcf, 0
    ; 16 bit real mode CS
 ;   dw 0xffff, 0
 ;   db 0,0x9e, 0, 0
    ; 16 bit real mode DS
 ;   dw 0xffff, 0
 ;   db 0,0x92, 0, 0

gdtr_end:


;
; EBIOS disk address packet
;

		 
dapa:	db 16		    ; Packet size  
		db 0			; reserved  
		dw 0			; +2 Block count  
		dw 0			; +4 Offset of buffer  
		dw 0			; +6 Segment of buffer  
		dd 0			; +8 LBA (LSW) * 
		dd 0			; +C LBA (MSW) 
   
BootDrive db 0xff    

MaxTransfer dw 16		 ; Max sectors per transfer (32Kb)  
RetryCount  db 0
JumpAddr: dd 0


_mmap_ent:
    dw 0
_lower_mem:
    dw 0


digits db '0123456789ABCDEF'

; Maximum length, 32 bits formatted as binary and a null-terminator.
output db '00000000000000000000000000000000', 0


;
;  This area is an empty space between the main body of code below which
;  grows up (fixed after compilation, but between releases it may change
;  in size easily), and the lists of sectors to read, which grows down
;  from a fixed top location.
;

	dw 0
	dw 0

;	. = start + SECTOR_SIZE - BOOTSEC_LISTSIZE
   dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	; fill the first data listing with the default  
blocklist_default_start:    ; this is the sector start parameter, in logical
			                ; sectors from the start of the disk, sector 0  
	dd 0

blocklist_default_len:	    ; this is the number of sectors to read  

	dw (STAGE2_SIZE + ISO_SECTOR_SIZE - 1) >> ISO_SECTOR_BITS

blocklist_default_seg:	    ; this is the segment of the starting address
			                ; to load the data into  
	dw (STAGE_ADDR + SECTOR_SIZE) >> 4

firstlist:	                ; this label has to be after the list data!!!  
