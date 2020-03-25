#include <kernel/hal/cpu/gdt.h>

#define KERNEL_DATA_SEGMENT 0x10

static gdt_entry_t gdt_entries[NUM_DESCRIPTORS];
static gdt_ptr_t gdt_ptr;

void gdt_init()
{
  // gdt_ptr.limit = sizeof(gdt_entries) - 1;
  // gdt_ptr.base = (uint32_t)gdt_entries;
    *(uint16_t*)&gdt_ptr.data[0] = sizeof(gdt_entries) - 1;
    *(uint32_t*)&gdt_ptr.data[2] = (uint32_t)gdt_entries;

    gdt_set_entry(0, 0, 0, 0, 0);
    gdt_set_entry(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);
    gdt_set_entry(2, 0, 0xFFFFFFFF, 0x92, 0xCF);
    gdt_set_entry(3, 0, 0xFFFFFFFF, 0xFA, 0xCF);
    gdt_set_entry(4, 0, 0xFFFFFFFF, 0xF2, 0xCF);

    gdt_flush((uint32_t)(&gdt_ptr));
}

void gdt_set_entry(int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran)
{
    gdt_entry_t* this = &gdt_entries[index];

    this->base_low = base & 0xFFFF;
    this->base_middle = (base >> 16) & 0xFF;
    this->base_high = (base >> 24 & 0xFF);

    this->limit_low = limit & 0xFFFF;
    this->granularity = (limit >> 16) & 0x0F;

    this->access = access;

    this->granularity = this->granularity | (gran & 0xF0);
}