#include "gdt.h"
#include <runtime/string.h>

#define KERNEL_DATA_SEGMENT 0x10


/* In the future we may need to put a lock on the access of this */
static struct {
    gdt_entry_t entries[NUM_DESCRIPTORS];
    gdt_ptr_t pointer;
    tss_entry_t tss;
} gdt __attribute__((used));

extern void tss_flush();
extern void gdt_flush(uintptr_t);
static void write_tss(int32_t num, uint16_t ss0, uint32_t esp0);

void gdt_init()
{
    gdt.pointer.limit = sizeof(gdt.entries) - 1;
    gdt.pointer.base = (uint32_t)gdt.entries; 

    gdt_set_entry(0, 0, 0, 0, 0);
    gdt_set_entry(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);
    gdt_set_entry(2, 0, 0xFFFFFFFF, 0x92, 0xCF);
    gdt_set_entry(3, 0, 0xFFFFFFFF, 0xFA, 0xCF);
    gdt_set_entry(4, 0, 0xFFFFFFFF, 0xF2, 0xCF);

	write_tss(5, 0x10, 0x0);

    gdt_flush((uint32_t)(&gdt.pointer));
	tss_flush();
}

void gdt_set_entry(int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran)
{
    gdt_entry_t* this = &gdt.entries[index];

    this->base_low = base & 0xFFFF;
    this->base_middle = (base >> 16) & 0xFF;
    this->base_high = (base >> 24 & 0xFF);

    this->limit_low = limit & 0xFFFF;
    this->granularity = (limit >> 16) & 0x0F;

    this->access = access;

    this->granularity = this->granularity | (gran & 0xF0);
}

static void write_tss(int32_t num, uint16_t ss0, uint32_t esp0) 
{
	tss_entry_t * tss = &gdt.tss;
	uintptr_t base = (uintptr_t)tss;
	uintptr_t limit = base + sizeof *tss;

	/* Add the TSS descriptor to the GDT */
	gdt_set_entry(num, base, limit, 0xE9, 0x00);

	memset(tss, 0x0, sizeof *tss);

	tss->ss0 = ss0;
	tss->esp0 = esp0;
	tss->cs = 0x0b;
	tss->ss = 0x13;
	tss->ds = 0x13;
	tss->es = 0x13;
	tss->fs = 0x13;
	tss->gs = 0x13;

	tss->iomap_base = sizeof *tss;
}

void set_kernel_stack(uintptr_t stack) {
	/* Set the kernel stack */
	gdt.tss.esp0 = stack;
}
