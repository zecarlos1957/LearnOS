#include <arch/x86/idt.h>
#include <arch/x86/isr.h>
#include <arch/x86/gdt.h>
#include <core/pit.h>
#include <core/irq.h>
#include <modules/ps2.h>
#include <core/panic.h>

#include <core/hal.h>

int hal_init(void)
{
    hal_disable();

     gdt_init();

    if (idt_init() || isr_init())
        kernel_panic("init error: cpu problem\n");

    if (ps2_init() || irq_init())
        kernel_panic("init error: hardware interrupt problem\n");

     pit_initialize();

    hal_enable();

    return 0;
}

void hal_enable(void)
{
    __asm__ __volatile__ ("sti");
}

void hal_disable(void)
{
    __asm__ __volatile__ ("cli");
}
