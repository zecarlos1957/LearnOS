bits 16
org	0

start: jmp boot

;***************************************************;
;	BIOS Parameter Block
;***************************************************;
bpbOEM                  db "BonsOS  "
bpbBytesPerSector:      DW 512
bpbSectorsPerCluster:   DB 1
bpbReservedSectors:     DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 224
bpbTotalSectors: 	    DW 2880
bpbMedia:               DB 0xf8
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 		        DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "BONS FLOPPY"
bsFileSystem: 	        DB "FAT12   "

;***************************************************;
;	Prints a string
;	DS=>SI: 0 terminated string
;***************************************************;
Print:
    lodsb			; load next byte from string from SI to AL
    or al, al		; Does AL=0?
    jz .done		; Yep, null terminator found-bail out
    mov	ah, 0x0E    ; Nope-Print the character
    int	0x10        ; Bios call: print al
    jmp	Print		; Repeat until null terminator found
.done:
    ret				; we are done, so return

;***************************************************;
; Reads a series of sectors
; CX=>Number of sectors to read
; AX=>Starting sector
; ES:BX=>Buffer to read to
;***************************************************;
ReadSectors:
.start:
    mov di, 0x0005                  ; five retries for error
.sectorloop:
    push ax
    push bx
    push cx
    call LBACHS                     ; convert starting sector to CHS
    mov ah, 0x02                    ; BIOS read sector
    mov al, 0x01                    ; read one sector
    mov ch, BYTE [absoluteTrack]    ; track
    mov cl, BYTE [absoluteSector]   ; sector
    mov dh, BYTE [absoluteHead]     ; head
    mov dl, BYTE [bsDriveNumber]    ; drive
    int 0x13                        ; invoke BIOS
    jnc .success                    ; test for read error
    xor ax, ax                      ; BIOS reset disk
    int 0x13                        ; invoke BIOS
    dec di                          ; decrement error counter
    pop cx
    pop bx
    pop ax
    jnz .sectorloop                 ; attempt to read again
    int 0x18
.success:
    mov si, msgProgress
    call Print
    pop cx
    pop bx
    pop ax
    add bx, WORD [bpbBytesPerSector]; queue next buffer
    inc ax                          ; queue next sector
    loop .start                     ; read next sector
    ret

;***************************************************;
; Convert CHS to LBA
; LBA = (cluster - 2) * sectors per cluster
;***************************************************;
ClusterLBA:
    sub ax, 0x0002                      ; zero base cluster number
    xor cx, cx
    mov cl, BYTE [bpbSectorsPerCluster] ; convert byte to word
    mul cx
    add ax, WORD [datasector]           ; base data sector
    ret
     
;***************************************************;
; Convert LBA to CHS
; AX=>LBA Address to convert
;
; absolute sector = (logical sector / sectors per track) + 1
; absolute head   = (logical sector / sectors per track) MOD number of heads
; absolute track  = logical sector / (sectors per track * number of heads)
;
;***************************************************;
LBACHS:
    xor dx, dx                      ; prepare dx:ax for operation
    div WORD [bpbSectorsPerTrack]   ; calculate
    inc dl                          ; adjust for sector 0
    mov BYTE [absoluteSector], dl
    xor dx, dx                      ; prepare dx:ax for operation
    div WORD [bpbHeadsPerCylinder]  ; calculate
    mov BYTE [absoluteHead], dl
    mov BYTE [absoluteTrack], al
    ret

;***************************************************;
;	Bootloader Entry Point
;***************************************************;
boot:

;---------------------------------------------------;
; code located at 0000:7C00, adjust segment registers
;---------------------------------------------------;
    cli             ; disable interrupts
    mov ax, 0x07C0  ; setup registers to point to our segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

;---------------------------------------------------;
; create stack
;---------------------------------------------------;
    mov ax, 0x0000  ; set the stack
    mov ss, ax
    mov sp, 0xFFFF
    sti				; restore interrupts

;---------------------------------------------------;
; Display loading message
;---------------------------------------------------;
    mov si, msgLoading
    call Print
          
;---------------------------------------------------;
; Load root directory table
;---------------------------------------------------;
load_root:

; compute size of root directory and store in "cx"
    xor cx, cx
    xor dx, dx
    mov ax, 0x0020              ; 32 byte directory entry
    mul WORD [bpbRootEntries]   ; total size of directory
    div WORD [bpbBytesPerSector]; sectors used by directory
    xchg ax, cx
          
; compute location of root directory and store in "ax"
    mov al, BYTE [bpbNumberOfFATs]      ; number of FATs
    mul WORD [bpbSectorsPerFAT]         ; sectors used by FATs
    add ax, WORD [bpbReservedSectors]   ; adjust for bootsector
    mov WORD [datasector], ax           ; base of root directory
    add WORD [datasector], cx
          
; read root directory into memory (7C00:0200)
    mov bx, 0x0200      ; copy root dir above bootcode
    call ReadSectors

;---------------------------------------------------;
; Find loader
;---------------------------------------------------;
; browse root directory for binary image
    mov cx, WORD [bpbRootEntries]   ; load loop counter
    mov di, 0x0200                  ; locate first root entry
.loop:
    push cx
    mov cx, 0x000B                  ; eleven character name
    mov si, ImageName               ; image name to find
    push di
    rep cmpsb                       ; test for entry match
    pop di
    je load_fat
    pop cx
    add di, 0x0020                  ; queue next directory entry
    loop .loop
    jmp failure

;---------------------------------------------------;
; Load FAT
;---------------------------------------------------;
load_fat:
     
; save starting cluster of boot image
    mov si, msgCRLF
    call Print
    mov dx, WORD [di + 0x001A]
    mov WORD [cluster], dx      ; file's first cluster
          
; compute size of FAT and store in "cx"
    xor ax, ax
    mov al, BYTE [bpbNumberOfFATs]  ; number of FATs
    mul WORD [bpbSectorsPerFAT]     ; sectors used by FATs
    mov cx, ax

; compute location of FAT and store in "ax"
    mov ax, WORD [bpbReservedSectors]   ; adjust for bootsector
          
; read FAT into memory (7C00:0200)
    mov bx, 0x0200      ; copy FAT above bootcode
    call ReadSectors

; read image file into memory (0050:0000)
    mov si, msgCRLF
    call Print
    mov ax, 0x0050
    mov es, ax      ; destination for image
    mov bx, 0x0000  ; destination for image
    push bx

;---------------------------------------------------;
; Load loader
;---------------------------------------------------;
load_image:

    mov ax, WORD [cluster]              ; cluster to read
    pop bx                              ; buffer to read into
    call ClusterLBA                     ; convert cluster to LBA
    xor cx, cx
    mov cl, BYTE [bpbSectorsPerCluster] ; sectors to read
    call ReadSectors
    push bx
          
; compute next cluster
    mov ax, WORD [cluster]  ; identify current cluster
    mov cx, ax              ; copy current cluster
    mov dx, ax              ; copy current cluster
    shr dx, 0x0001          ; divide by two
    add cx, dx              ; sum for (3/2)
    mov bx, 0x0200          ; location of FAT in memory
    add bx, cx              ; index into FAT
    mov dx, WORD [bx]       ; read two bytes from FAT
    test ax, 0x0001
    jnz .odd_cluster
          
.even_cluster:  
    and dx, 0000111111111111b   ; take low twelve bits
    jmp .done
         
.odd_cluster:
    shr dx, 0x0004  ; take high twelve bits
          
.done: 
    mov WORD [cluster], dx  ; store new cluster
    cmp dx, 0x0FF0          ; test for end of file
    jb load_image
          
done:
    mov si, msgCRLF
    call Print
    push WORD 0x0050
    push WORD 0x0000
    retf
          
failure:
    mov si, msgFailure
    call Print
    mov ah, 0x00
    int 0x16            ; await keypress
    int 0x19            ; warm boot computer

;***************************************************;
;	Data Section
;***************************************************;   
absoluteSector db 0x00
absoluteHead   db 0x00
absoluteTrack  db 0x00

datasector  dw 0x0000
cluster     dw 0x0000
ImageName   db "KRNLDR  SYS"
msgLoading  db 0x0D, 0x0A, "Loading Boot Image ", 0x0D, 0x0A, 0x00
msgCRLF     db 0x0D, 0x0A, 0x00
msgProgress db ".", 0x00
msgFailure  db 0x0D, 0x0A, "ERROR : Press Any Key to Reboot", 0x0A, 0x00

;***************************************************;
;	Magic constant
;***************************************************;      
TIMES 510-($-$$) DB 0
DW 0xAA55