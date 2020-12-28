.section .text
.align 4

.macro ISR_NOERR index
    .global _isr\index
    _isr\index:
        cli
        push $0
        push $\index
        jmp isr_common
.endm

.macro ISR_ERR index
    .global _isr\index
    _isr\index:
        cli
        push $\index
        jmp isr_common
.endm

/* Standard X86 interrupt service routines */
ISR_NOERR 0   /* Divide error */
ISR_NOERR 1   /* Debug exception */
ISR_NOERR 2   /* Non maskable intr */
ISR_NOERR 3   /* BreakPoint instruction */
ISR_NOERR 4   /* Overflow (INTO instr) */
ISR_NOERR 5   /* Bounds check (BOUND instr) */
ISR_NOERR 6   /* Invalid opcode */
ISR_NOERR 7   /* Coprocessor not available */
ISR_ERR   8   /* Double fault */
ISR_NOERR 9   /* Coproc segment overrun
ISR_ERR   10  /* Invalid TSS */
ISR_ERR   11  /* Seg not present */
ISR_ERR   12   /* Stack exception */
ISR_ERR   13  /* General protection  exception */
ISR_ERR   14  /* Page fault */
ISR_NOERR 15  /* Intel rsvd */ 
ISR_NOERR 16  /* Coprocessor error */
ISR_NOERR 17  /*  Intel rsvd */   
ISR_NOERR 18  
ISR_NOERR 19
ISR_NOERR 20
ISR_NOERR 21
ISR_NOERR 22
ISR_NOERR 23
ISR_NOERR 24
ISR_NOERR 25
ISR_NOERR 26
ISR_NOERR 27
ISR_NOERR 28
ISR_NOERR 29
ISR_NOERR 30
ISR_NOERR 31
ISR_NOERR 127

.extern _fault_handler


isr_common:
    /* Push all registers */
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

    /* Call fault handler */
    push %esp
    call _fault_handler
    add $4, %esp

    /* Restore segment registers */
    pop %gs
    pop %fs
    pop %es
    pop %ds

    /* Restore registers */
    popa
    /* Cleanup error code and ISR # */
    add $8, %esp
    /* pop CS, EIP, EFLAGS, SS and ESP */
    iret
