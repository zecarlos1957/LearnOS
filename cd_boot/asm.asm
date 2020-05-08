
%define COMPAT_VERSION_MAJOR  0
%define COMPAT_VERSION_MINOR  97



extern bss
extern end
extern _kmain

;  shared.h

%define STAGE2_VER_MAJ_OFFS	0x6
%define STAGE2_INSTALLPART	0x8
%define STAGE2_SAVED_ENTRYNO	0xc
%define STAGE2_STAGE2_ID	0x10
%define STAGE2_FORCE_LBA	0x11
%define STAGE2_VER_STR_OFFS	0x12

; Stage 2 identifiers  
%define STAGE2_ID_STAGE2		0
%define STAGE2_ID_FFS_STAGE1_5		1
%define STAGE2_ID_E2FS_STAGE1_5		2
%define STAGE2_ID_FAT_STAGE1_5		3
%define STAGE2_ID_MINIX_STAGE1_5	4
%define STAGE2_ID_REISERFS_STAGE1_5	5
%define STAGE2_ID_VSTAFS_STAGE1_5	6
%define STAGE2_ID_JFS_STAGE1_5		7
%define STAGE2_ID_XFS_STAGE1_5		8
%define STAGE2_ID_ISO9660_STAGE1_5	9
%define STAGE2_ID_UFS2_STAGE1_5		10


%ifndef STAGE1_5
%define STAGE2_ID	STAGE2_ID_STAGE2
%else
%if defined(FSYS_FFS)
%define STAGE2_ID	STAGE2_ID_FFS_STAGE1_5
%elif defined(FSYS_EXT2FS)
%define STAGE2_ID	STAGE2_ID_E2FS_STAGE1_5
%elif defined(FSYS_FAT)
%define STAGE2_ID	STAGE2_ID_FAT_STAGE1_5
%elif defined(FSYS_MINIX)
%define STAGE2_ID	STAGE2_ID_MINIX_STAGE1_5
%elif defined(FSYS_REISERFS)
%define STAGE2_ID	STAGE2_ID_REISERFS_STAGE1_5
%elif defined(FSYS_VSTAFS)
%define STAGE2_ID	STAGE2_ID_VSTAFS_STAGE1_5
%elif defined(FSYS_JFS)
%define STAGE2_ID	STAGE2_ID_JFS_STAGE1_5
%elif defined(FSYS_XFS)
%define STAGE2_ID	STAGE2_ID_XFS_STAGE1_5
%elif defined(FSYS_ISO9660)
%define STAGE2_ID	STAGE2_ID_ISO9660_STAGE1_5
%elif defined(FSYS_UFS2)
%define STAGE2_ID	STAGE2_ID_UFS2_STAGE1_5
%else
%error "unknown Stage 2"
%endif
%endif

;
;  This is the filesystem (not raw device) buffer.
;  It is 32K in size, do not overrun!
;

%define FSYS_BUFLEN  0x8000
%define FSYS_BUF     0x68000 
;
;  defines for use when switching between real and protected mode
;

%define CR0_PE_ON	0x1
%define CR0_PE_OFF	0xfffffffe
%define PROT_MODE_CSEG	0x8
%define PROT_MODE_DSEG  0x10
%define PSEUDO_RM_CSEG	0x18
%define PSEUDO_RM_DSEG	0x20
%define STACKOFF	(0x2000 - 0x10)
%define PROTSTACKINIT   (FSYS_BUF - 0x10)


%ifndef STAGE1_5
	; 
	; In stage2, do not link start.S with the rest of the source
	; files directly, so define the start symbols here just to
	; force ld quiet. These are not referred anyway.
	;
	section .text
	
	global  _start
 
_start:
%endif ; ! STAGE1_5 */

	;
	;  Guarantee that "main" is loaded at 0x0:0x8200 in stage2 and
	;  at 0x0:0x2200 in stage1.5.
	;
	jmp 0:codestart 

	;
	;  Compatibility version number
	;
	;  These MUST be at byte offset 6 and 7 of the executable
	;  DO NOT MOVE !!!
	 ;
	;. = EXT_C(main) + 0x6
	db	COMPAT_VERSION_MAJOR, COMPAT_VERSION_MINOR
  
  ;  align 8
    
    global _version_string
    
    
install_partition dd 0xFFFFFF
saved_entryno dd 0
stage2_id db STAGE2_ID
force_lba db 	0
_version_string db "0.97",0
 
%ifndef STAGE1_5
config_file db "/boot/grub/menu.lst", 0
%else   ; STAGE1_5 
config_file	dd 0xffffffff
	db "/boot/grub/stage2", 0
%endif  ; STAGE1_5  

	;
	;  Leave some breathing room for the config file name.
	;
    dd 0,0,0,0,0,0,0,0
;	. = EXT_C(main) + 0x70
; the real mode code continues...  
align 4
codestart:
	cli		; we're not safe here!  
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov es, ax

%ifndef SUPPORT_DISKLESS
	;
	; Save the sector number of the second sector (i.e. this sector)
	; in INSTALL_SECOND_SECTOR. See also "stage2/start.S".
	;
	mov  [install_second_sector], ebp
%endif

	mov ebp, STACKOFF
	mov esp, ebp
	sti

%ifndef SUPPORT_DISKLESS
	; save boot drive reference  
	mov  [boot_drive], dl

	; reset disk system (%ah = 0) 
	int	0x13
%endif

	; transition to protected mode  
	call real_to_prot 

	; The ".code32" directive takes GAS out of 16-bit mode.  
bits 32

	; clean out the bss  

	mov edi, bss
	mov ecx, end 
	sub	ecx, edi 
	xor	 al, al
	cld
	rep stosb
	
	;
	;  Call the start of main body of C code, which does some
	;  of it's own initialization before transferring to "cmain".
	;
	call  _kmain 

;
;  This call is special...  it never returns...  in fact it should simply
;  hang at this point!
;
hang:
    hlt
    jmp hang

;
;  These next two routines, "real_to_prot" and "prot_to_real" are structured
;  in a very specific way.  Be very careful when changing them.
;
;  NOTE:  Use of either one messes up %eax and %ebp.
;

real_to_prot:

	cli

	; load the GDT register */
	lgdt	[gdtdesc]

	; turn on protected mode */
	mov	eax, cr0 
	or eax, CR0_PE_ON
	mov	 cr0, eax

	; jump to relocation, flush prefetch queue, and reload %cs */
	jmp	 PROT_MODE_CSEG:protcseg

	;
	;  The ".code32" directive only works in GAS, the GNU assembler!
	;  This gets out of "16-bit" mode.
	;
bits 32

protcseg:
	; reload other segment registers  
	mov	ax, PROT_MODE_DSEG 
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax

	; put the return address in a known safe location  
	mov	eax, esp 
	mov	[STACKOFF], eax

	; get protected mode stack  
	mov	eax, [protstack] 
	mov	esp, eax
	mov	ebp, eax

	; get return address onto the right stack  
	mov	eax, STACKOFF 
	mov	esp, eax 

	; zero %eax */
	xor 	eax, eax

	; return on the old (or initialized) stack!  
	ret
	
	
;********************************************

	align	4	; force 4-byte alignment  

protstack dd	PROTSTACKINIT
 
%ifdef SUPPORT_DISKLESS
boot_drive	dd	NETWORK_DRIVE
%else
boot_drive	dd	0
%endif

install_second_sector dd	0
	
	; an address can only be long-jumped to if it is in memory, this
	;   is used by multiple routines */
_offset dd	0x8000
_segment dw	0

apm_bios_info:
	dw	0	; version  
	dw	0	; cseg  
	dd	0	; offset  
	dw	0	; cseg_16  
	dw	0	; dseg_16  
	dw	0	; cseg_len  
	dw	0	; cseg_16_len   
	dw	0	; dseg_16_len  
	
;
;  This is the Global Descriptor Table
; 
;  An entry, a "Segment Descriptor", looks like this:
;
; 31          24         19   16                 7           0
; ------------------------------------------------------------
; |             | |B| |A|       | |   |1|0|E|W|A|            |
; | BASE 31..24 |G|/|0|V| LIMIT |P|DPL|  TYPE   | BASE 23:16 |
; |             | |D| |L| 19..16| |   |1|1|C|R|A|            |
; ------------------------------------------------------------
; |                             |                            |
; |        BASE 15..0           |       LIMIT 15..0          |
; |                             |                            |
; ------------------------------------------------------------
;
;  Note the ordering of the data items is reversed from the above
;  description.
;

	 align	4	; force 4-byte alignment  
gdt:
	dw	0, 0
	db	0, 0, 0, 0

	; code segment  
	dw	0xFFFF, 0
	db	0, 0x9A, 0xCF, 0

	; data segment  
	dw	0xFFFF, 0
	db	0, 0x92, 0xCF, 0

	; 16 bit real mode CS  
	dw	0xFFFF, 0
	db	0, 0x9E, 0, 0

	; 16 bit real mode DS  
	dw	0xFFFF, 0
	db	0, 0x92, 0, 0


; this is the GDT descriptor  
gdtdesc:
	dw	0x27		; limit  
	dd	gdt			; addr  

global _mmap_ent
_mmap_ent:
	dw 0
 

global _lower_mem
_lower_mem:
	dw 0
 
