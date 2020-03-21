#include <kernel/panic.h>
#include <stdio.h>
#include <kernel/hal/cpu/idt.h>

#include <kernel/hal/cpu/isr.h>


isr_t interrupt_handlers[256];

static inline int __set_handler(int isrnum, void (*handler)(void))
{
    return idt_set_entry(isrnum, handler, 0x8, IDT_PRESENT | IDT_PRIVILEGE_0 | IDT_GATE_INTERRUPT_32);
}

static inline int __remove_handler(int isrnum)
{
    return idt_set_entry(isrnum, 0, 0, 0);
}
 
int isr_set_handler(int isrnum, void (*handler)(void));
{
    if (handler)
        return __set_handler(isrnum, handler);
    else
        return __remove_handler(isrnum);    
}

        void register_interrupt_handler(u8int n, isr_t handler)
        {
            interrupt_handlers[n] = handler;
        }

// This gets called from our ASM interrupt handler stub.
void isr_handler(registers_t regs)
{
    if (interrupt_handlers[regs.int_no] != 0)
    {
        isr_t handler = interrupt_handlers[regs.int_no];
        handler(regs);
    }
    else
    {
        monitor_write("unhandled interrupt: ");
        monitor_write_dec(regs.int_no);
        monitor_put('\n');
    }
}

// This gets called from our ASM interrupt handler stub.
void irq_handler(registers_t regs)
{
    // Send an EOI (end of interrupt) signal to the PICs.
    // If this interrupt involved the slave.
    if (regs.int_no >= 40)
    {
        // Send reset signal to slave.
        outb(0xA0, 0x20);
    }
    // Send reset signal to master. (As well as slave, if necessary).
    outb(0x20, 0x20);

    if (interrupt_handlers[regs.int_no] != 0)
    {
        isr_t handler = interrupt_handlers[regs.int_no];
        handler(regs);
    }

}



void isr_divide_error(struct isr_params params)
{
    kernel_panic("cpu divide error 0x%x\n", params.cs.eflags);
}

void isr_nonmaskable_interrupt(struct isr_params params)
{
    kernel_panic("cpu non-maskable hardware interrupt 0x%x\n", params.cs.eflags);
}

void isr_bounds_check(struct isr_params params)
{
    kernel_panic("cpu bounds limit exceeded 0x%x\n", params.cs.eflags);
}

void isr_invalid_opcode(struct isr_params params)
{
    kernel_panic("cpu invalid opcode 0x%x\n", params.cs.eflags);
}

void isr_fpu_unavailable(struct isr_params params)
{
    kernel_panic("cpu fpu unavailable 0x%x\n", params.cs.eflags);
}

void isr_double_fault(struct isr_params params)
{
    kernel_panic("cpu double-fault 0x%x\n", params.cs.eflags);
}

void isr_fpu_segment_overrun(struct isr_params params)
{
    kernel_panic("cpu fpu segment overrun 0x%x\n", params.cs.eflags);
}

void isr_invalid_tss(struct isr_params params)
{
    kernel_panic("cpu invalid TSS 0x%x\n", params.cs.eflags);
}

void isr_segment_not_present(struct isr_params params)
{
    kernel_panic("cpu segment not present 0x%x\n", params.cs.eflags);
}

void isr_stack_exception(struct isr_params params)
{
    kernel_panic("cpu stack exception 0x%x\n", params.cs.eflags);
}

void isr_general_protection_fault(struct isr_params params)
{
    kernel_panic("cpu general protection fault 0x%x\n", params.cs.eflags);
}

void isr_page_fault(struct isr_params params)
{
    kernel_panic("cpu page fault 0x%x\n", params.cs.eflags);
}

void isr_fpu_error(struct isr_params params)
{
    kernel_panic("cpu fpu error 0x%x\n", params.cs.eflags);
}
  
