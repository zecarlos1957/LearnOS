; @ File : idt.s
; @ Desc : Defines the idt_flush() function which sets up the IDT
;

section .text

[GLOBAL] _idt_flush

_idt_flush:
  mov eax , [esp+4]     ; Get the pointer to the idt struct
  lidt [eax]            ; Loads the IDT
  ret                   ; return
