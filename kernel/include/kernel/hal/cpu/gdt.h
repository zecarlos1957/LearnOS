#pragma once

#include <stdint.h>

#define NUM_DESCRIPTORS 8

typedef struct gdt_entry
{
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t  base_middle;
    uint8_t  access;
    uint8_t  granularity;
    uint8_t  base_high;
} __attribute__((packed)) gdt_entry_t;

typedef struct gdt_ptr
{
   // uint16_t limit;
   // uint32_t base;
      uint8_t data[6];
} __attribute__((packed)) gdt_ptr_t;

#ifdef __cplusplus
extern "C" {
#endif

void gdt_flush(uint32_t gdt_ptr);
void gdt_init();
void gdt_set_entry(int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran);

#ifdef __cplusplus
}
#endif
