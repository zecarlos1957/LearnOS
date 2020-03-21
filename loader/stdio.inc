%ifndef __STDIO_INC_INCLUDED__
%define __STDIO_INC_INCLUDED__
 
bits 16

Puts16:
    pusha           ; save registers
.loop:
    lodsb           ; load next byte from string from SI to AL
    or al, al       ; Does AL=0?
    jz .done        ; Yep, null terminator found-bail out
    mov	ah, 0x0E    ; Nope-Print the character
    int	0x10        ; invoke BIOS
    jmp	.loop       ; Repeat until null terminator found
.done:
    popa            ; restore registers
    ret             ; we are done, so return

bits 32

%define VIDMEM 0xB8000
%define	COLS 80
%define	LINES 25
%define	CHAR_ATTRIB 0x0F  ;(White on black)

_CurX db 0  ; Current x location
_CurY db 0  ; Current y location

Putch32:
    pusha				    ; save registers
    mov	edi, VIDMEM		    ; get pointer to video memory

;---------------------------------------------------;
;   Get current position
;---------------------------------------------------;
    xor	eax, eax		    ; clear eax

    mov	ecx, COLS * 2	    ; Mode 7 has 2 bytes per char, so its COLS*2 bytes per line
    mov	al, byte [_CurY]    ; get y pos
    mul	ecx	                ; multiply y*COLS
    push eax			    ; save eax--the multiplication

    mov	al, byte [_CurX]    ; multiply _CurX by 2 because it is 2 bytes per char
    mov	cl, 2
    mul	cl
    pop	ecx			        ; pop y*COLS result
    add	eax, ecx

    xor	ecx, ecx
    add	edi, eax		    ; add it to the base address

;---------------------------------------------------;
;   Watch for new line
;---------------------------------------------------;
    cmp	bl, 0x0A		    ; is it a newline character?
    je	.row			    ; yep--go to next row

;---------------------------------------------------;
;   Print a character
;---------------------------------------------------;
    mov	dl, bl			    ; Get character
    mov	dh, CHAR_ATTRIB	    ; the character attribute
    mov	word [edi], dx	    ; write to video display

;---------------------------------------------------;
;   Update next position
;---------------------------------------------------;
    inc	byte [_CurX]	    ; go to next character
	cmp	byte [_CurX], COLS	; are we at the end of the line?
	je	.row			    ; yep-go to next row
    jmp	.done			    ; nope, bail out

;---------------------------------------------------;
;   Go to next row
;---------------------------------------------------;
.row:
    mov	byte [_CurX], 0		; go back to col 0
    inc	byte [_CurY]		; go to next row

;---------------------------------------------------;
;   Restore registers & return
;---------------------------------------------------;
.done:
    popa				    ; restore registers and return
    ret

Puts32:
;---------------------------------------------------;
;   Store registers
;---------------------------------------------------;
    pusha				; save registers
    push ebx			; copy the string address
    pop edi

.loop:
;---------------------------------------------------;
;   Get character
;---------------------------------------------------;
    mov	bl, byte [edi]	; get next character
    cmp	bl, 0			; is it 0 (Null terminator)?
    je .done			; yep-bail out

;---------------------------------------------------;
;   Print the character
;---------------------------------------------------;
    call Putch32		; Nope-print it out

;---------------------------------------------------;
;   Go to next character
;---------------------------------------------------;
    inc	edi			    ; go to next character
    jmp	.loop

.done:
;---------------------------------------------------;
;   Update hardware cursor
;---------------------------------------------------;
    mov	bh, byte [_CurY]	; get current position
    mov	bl, byte [_CurX]
    call	MovCur			; update cursor

    popa				    ; restore registers, and return
    ret

MovCur:
    pusha				; save registers

;---------------------------------------------------;
;   Get current position
;---------------------------------------------------;
    xor	eax, eax
    mov	ecx, COLS
    mov	al, bh      ; get y pos
    mul	ecx         ; multiply y*COLS
    add	al, bl      ; Now add x
    mov	ebx, eax

;---------------------------------------------------;
;   Set low byte index to VGA register
;---------------------------------------------------;
    mov	al, 0x0f
    mov	dx, 0x03D4
    out	dx, al

    mov	al, bl
    mov	dx, 0x03D5
    out	dx, al		; low byte

;---------------------------------------------------;
;   Set high byte index to VGA register
;---------------------------------------------------;
    xor	eax, eax

    mov	al, 0x0e
    mov	dx, 0x03D4
    out	dx, al

    mov	al, bh
    mov	dx, 0x03D5
    out	dx, al      ; high byte

    popa
    ret

ClrScr32:
    pusha
    cld
    mov	edi, VIDMEM
    mov	cx, 2000
    mov	ah, CHAR_ATTRIB
    mov	al, ' '	
    rep	stosw

    mov	byte [_CurX], 0
    mov	byte [_CurY], 0
    popa
    ret

GotoXY:
	pusha
	mov	[_CurX], al		; just set the current position
	mov	[_CurY], ah
	popa
	ret

%endif