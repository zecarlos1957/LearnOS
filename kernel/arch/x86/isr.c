#include <core/panic.h>
#include <stdio.h>
#include "idt.h"

#include "isr.h"

static ISR_DEF_HANDLER(isr_divide_error);
static ISR_DEF_HANDLER(isr_nonmaskable_interrupt);
static ISR_DEF_HANDLER(isr_bounds_check);
static ISR_DEF_HANDLER(isr_invalid_opcode);
static ISR_DEF_HANDLER(isr_fpu_unavailable);
static ISR_DEF_HANDLER(isr_double_fault);
static ISR_DEF_HANDLER(isr_fpu_segment_overrun);
static ISR_DEF_HANDLER(isr_invalid_tss);
static ISR_DEF_HANDLER(isr_segment_not_present);
static ISR_DEF_HANDLER(isr_stack_exception);
static ISR_DEF_HANDLER(isr_general_protection_fault);
static ISR_DEF_HANDLER(isr_page_fault);
static ISR_DEF_HANDLER(isr_fpu_error);
 
static inline int __set_handler(int isrnum, void (*handler)(void))
{
    return idt_set_entry(isrnum, handler, 0x8, IDT_PRESENT | IDT_PRIVILEGE_0 | IDT_GATE_INTERRUPT_32);
}

static inline int __remove_handler(int isrnum)
{
    return idt_set_entry(isrnum, 0, 0, 0);
}

int isr_init(void)
{
    int result = 0;

    result |= __set_handler(0x00, ISR_HANDLER(isr_divide_error));
    result |= __set_handler(0x02, ISR_HANDLER(isr_nonmaskable_interrupt));
    result |= __set_handler(0x05, ISR_HANDLER(isr_bounds_check));
    result |= __set_handler(0x06, ISR_HANDLER(isr_invalid_opcode));
    result |= __set_handler(0x07, ISR_HANDLER(isr_fpu_unavailable));
    result |= __set_handler(0x08, ISR_HANDLER(isr_double_fault));
    result |= __set_handler(0x09, ISR_HANDLER(isr_fpu_segment_overrun));
    result |= __set_handler(0x0a, ISR_HANDLER(isr_invalid_tss));
    result |= __set_handler(0x0b, ISR_HANDLER(isr_segment_not_present));
    result |= __set_handler(0x0c, ISR_HANDLER(isr_stack_exception));
    result |= __set_handler(0x0d, ISR_HANDLER(isr_general_protection_fault));
    result |= __set_handler(0x0e, ISR_HANDLER(isr_page_fault));
    result |= __set_handler(0x10, ISR_HANDLER(isr_fpu_error));

    if (result) {
        printf("isr: failed to register one or more cpu isr handlers\n");
        return 1;
    }

    return 0;
}

int isr_set_handler(int isrnum, void (*handler)(void))
{
    if (handler)
        return __set_handler(isrnum, handler);
    else
        return __remove_handler(isrnum);
}

void isr_divide_error(struct isr_params params)
{
    kernel_panic("cpu divide error\n");
}

void isr_nonmaskable_interrupt(struct isr_params params)
{
    kernel_panic("cpu non-maskable hardware interrupt\n");
}

void isr_bounds_check(struct isr_params params)
{
    kernel_panic("cpu bounds limit exceeded\n");
}

void isr_invalid_opcode(struct isr_params params)
{
    kernel_panic("cpu invalid opcode\n");
}

void isr_fpu_unavailable(struct isr_params params)
{
    kernel_panic("cpu fpu unavailable\n");
}

void isr_double_fault(struct isr_params params)
{
    kernel_panic("cpu double-fault\n");
}

void isr_fpu_segment_overrun(struct isr_params params)
{
    kernel_panic("cpu fpu segment overrun\n");
}

void isr_invalid_tss(struct isr_params params)
{
    kernel_panic("cpu invalid TSS\n");
}

void isr_segment_not_present(struct isr_params params)
{
    kernel_panic("cpu segment not present\n");
}

void isr_stack_exception(struct isr_params params)
{
    kernel_panic("cpu stack exception\n");
}

void isr_general_protection_fault(struct isr_params params)
{
    kernel_panic("cpu general protection fault\n");
}

void isr_page_fault(struct isr_params params)
{
    kernel_panic("cpu page fault\n");
}

void isr_fpu_error(struct isr_params params)
{
    kernel_panic("cpu fpu error\n");
}
