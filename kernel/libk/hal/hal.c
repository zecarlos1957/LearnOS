#include <kernel/hal/cpu/idt.h>
#include <kernel/hal/cpu/isr.h>
#include <kernel/hal/cpu/gdt.h>
#include <kernel/hal/pit.h>
#include <kernel/hal/irq.h>
#include <kernel/io/ps2.h>
#include <kernel/panic.h>

#include <kernel/hal/hal.h>

int hal_init(void)
{
 	char cpu_name[256];
	cpu_vendor_name(cpu_name);
    printf("%s\n",cpu_name);

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
