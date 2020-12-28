.section .text
.align 4

.macro IRQ ident byte
    .global _irq\ident

    _irq\ident:
        cli
        push $0x00
        push $\byte
        jmp irq_common
.endm

/* Interrupt Requests */
IRQ 0, 32     /* TIMER    */
IRQ 1, 33     /* KEYBOARD */
IRQ 2, 34     /* BRIDGE PIC2 */
IRQ 3, 35     /* COM2 */
IRQ 4, 36     /* COM1  */
IRQ 5, 37     /* LPT2   */
IRQ 6, 38     /* FLOPPY */
IRQ 7, 39     /* LPT1   */
IRQ 8, 40     /* CMOS RTC */
IRQ 9, 41     
IRQ 10, 42
IRQ 11, 43
IRQ 12, 44    /* PS/2 MOUSE  */
IRQ 13, 45    /* num Coprocessor */
IRQ 14, 46    /* hd IDE0  */
IRQ 15, 47     /* hd IDE1  */

.extern _irq_handler


irq_common:
    /* Save all registers */
    pusha

    /* Save segment registers */
    push %ds
    push %es
    push %fs
    push %gs
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    cld

    /* Call interrupt handler */
    push %esp
    call _irq_handler
    add $4, %esp

    /* Restore segment registers */
    pop %gs
    pop %fs
    pop %es
    pop %ds

    /* Restore all registers */
    popa
    /* Cleanup error code and IRQ # */
    add $8, %esp
    /* pop CS, EIP, EFLAGS, SS and ESP */
    iret
