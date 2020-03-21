%ifndef __PAGING_INC_INCLUDED__
%define __PAGING_INC_INCLUDED__

bits 32

%define PAGE_DIR 0x9C000
%define PAGE_TABLE_0 0x9D000
%define PAGE_TABLE_768 0x9E000
%define PAGE_TABLE_ENTRIES 1024
%define PRIV 3

EnablePaging:
	pusha
	mov eax, PAGE_TABLE_0					; first page table
	mov ebx, 0x0 | PRIV						; starting physical address of page
	mov ecx, PAGE_TABLE_ENTRIES				; for every page in table...
.loop:
	mov dword [eax], ebx					; write the entry
	add eax, 4								; go to next page entry in table (Each entry is 4 bytes)
	add ebx, 4096							; go to next page address (Each page is 4Kb)
	loop .loop								; go to next entry

	mov eax, PAGE_TABLE_0 | PRIV			; 1st table is directory entry 0
	mov dword [PAGE_DIR], eax

	mov eax, PAGE_TABLE_768 | PRIV			; 768th entry in directory table
	mov dword [PAGE_DIR+(768*4)], eax

	mov eax, PAGE_DIR
	mov cr3, eax

	mov eax, cr0
	or eax, 0x80000000
	mov cr0, eax

	mov eax, PAGE_TABLE_768				; first page table
	mov ebx, 0x100000 | PRIV			; starting physical address of page
	mov ecx, PAGE_TABLE_ENTRIES			; for every page in table...
.loop2:
	mov dword [eax], ebx				; write the entry
	add eax, 4							; go to next page entry in table (Each entry is 4 bytes)
	add ebx, 4096						; go to next page address (Each page is 4Kb)
	loop .loop2							; go to next entry

	popa
	ret

%endif
