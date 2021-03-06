.section .text
.align 4

/* Disable paging mask */
.set dp, 0x7FFFFFFF
/* Enable paging mask */
.set ep, 0x80000000

.global _copy_page_physical


_copy_page_physical:
    /* Preserve contents of EBX */
    push %ebx

    /* Preserve contents of EFLAGS */
    pushf
    cli

    /* Load source and destination addresses */
    mov 12(%esp), %ebx
    mov 16(%esp), %ecx

    /* Get control register and disable paging*/
    mov %cr0, %edx
    and $dp, %edx
    mov %edx, %cr0

    /* Copy 4096 bytes */
    mov $0x400, %edx
.page_loop:
    /* Get word at source address */
    mov (%ebx), %eax

    /* Store it at destination address */
    mov %eax, (%ecx)

    /* Increment source and destination addresses to next word */
    add $4, %ebx
    add $4, %ecx

    /* One less word to copy */
    dec %edx
    jnz .page_loop

    /* Get control register again and enable paging */
    mov %cr0, %edx
    or  $ep, %edx
    mov %edx, %cr0

    /* Restore EFLAGS */
    popf

    /* Restore EBX */
    pop %ebx
    ret

/* Read EIP */
.global _read_eip


_read_eip:
    mov (%esp), %eax
    ret
    
/* void perform_task_switch(uintptr_t eip, uintptr_t physAddr, uintptr_t ebp, uintptr_t esp); */
.global _perform_task_switch
_perform_task_switch:
    cli
    mov 4(%esp), %ebx    /* EIP */
    mov 8(%esp), %eax    /* physical address */
    mov 12(%esp), %ebp    /* EBP */
    mov 16(%esp), %esp    /* ESP */
    mov %eax, %cr3        /* set page directory */
    mov $0x10000, %eax    /* magic number */
    sti
    jmp *%ebx
    ret
    
