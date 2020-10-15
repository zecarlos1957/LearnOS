.section .text
.align 4

.global _tss_flush


_tss_flush:
    mov $0x2B, %ax
    ltr %ax
    ret
