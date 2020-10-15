.section .text
.align 4

.global _idt_load


_idt_load:
    mov 4(%esp), %eax
    lidt (%eax)
    ret
