
%ifdef STAGE1_5 
%define STAGE_ADDR      0x2000
%else 
%define STAGE_ADDR      0x8000
%endif
%define STAGE1_STACKSEG 0x2000
%define GRUB_INVALID_DRIVE	0xFF

; shared
%define SECTOR_SIZE		0x200
%define SECTOR_BITS		  9
%define BOOTSEC_LISTSIZE		8

%define STAGE2_SIZE 0


; iso9660
%define ISO_SECTOR_BITS    11 
%define ISO_SECTOR_SIZE   0x800 


bits 16

 section .text

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

load_image:
	; Set up boot file sector, size, load address 
	mov eax, [bi_length]
	add eax, ISO_SECTOR_SIZE-1
	shr eax, ISO_SECTOR_BITS    ;  dwords->sectors
	mov bp, ax                  ; boot file sectors
	mov bx, (STAGE_ADDR>>4)
	mov es, bx
	xor bx, bx
	mov eax, [bi_file]
	call getlinsec
	mov ax, ds
	mov es, ax
	
    mov si, notification_done
    call message

bootit:
    ; save the sector number of the second sector in %ebp
    mov si, firstlist - BOOTSEC_LISTSIZE
    mov ebp, [si]
    mov dl, [BootDrive]    ;this makes sure %dl is our "boot" drive 
 ;   jmp 0:STAGE_ADDR+SECTOR_SIZE	;  jump to main() in asm.S 
    
    ; go here when you need to stop the machine hard after an error condition  
stop:	jmp	stop


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
    jmp stop
    
;*****************************************************

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
    pushad
    rol eax, 24
    mov cx, 2
    jmp p10
printhex4:
    pushad
    rol eax, 16
    mov cx, 4
    jmp p10
printhex8:
    pushad
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
    popad
    ret
    
;**************************************************   
    
%ifdef STAGE1_5
notification_string db "Loading stage1.5",0x0    
%else
notification_string db "Loading stage2 ",0x0    
%endif
 
notification_step 	db ".",0x0
notification_done 	db 0x0d,0x0a,0x0
read_error_string	db "Read error 0x",0x0

;
; EBIOS disk address packet
;
	align 8
		 
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
%ifdef STAGE1_5
	dw 0
%else
	dw (STAGE2_SIZE + ISO_SECTOR_SIZE - 1) >> ISO_SECTOR_BITS
%endif
blocklist_default_seg:	    ; this is the segment of the starting address
			                ; to load the data into  
	dw (STAGE_ADDR + SECTOR_SIZE) >> 4

firstlist:	                ; this label has to be after the list data!!!  
 
 