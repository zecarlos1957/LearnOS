/*
  * @ File : GDT.h
  * @ Description : This initialises the GDT or the Global Descriptor Table for us
*/

#ifndef GDT_H_INCLUDED
#define GDT_H_INCLUDED

#include <system.h>

/*
  * @ Desc : Contains a single descriptor table entry
  * __attribute__((packed)); : Stops the compiler from adding additional padding
*/
struct gdt_entry_struct
{
  u16int limit_low;           // The lower 16 bits of the limit.
  u16int base_low;            // The lower 16 bits of the base.
  u8int  base_middle;         // The next 8 bits of the base.
  u8int  access;              // Access flags, determine what ring this segment can be used in.
  u8int  granularity;
  u8int  base_high;           // The last 8 bits of the base.
} __attribute__((packed));
typedef struct gdt_entry_struct gdt_entry_t;

// @ Desc : Define the pointer which is used to tell the processor where to find our GDT
struct gdt_ptr_struct
{
  u16int limit;               // The upper 16 bits of all selector limits.
  u32int base;                // The address of the first gdt_entry_t struct.
}
__attribute__((packed));
typedef struct gdt_ptr_struct gdt_ptr_t;

// @ Functions
// @ Task : Loads our GDT , defined in the assembly code
extern "C" void gdt_flush(u32int);

// @ Task : Initialise the GDT
void init_gdt();

// @ Task : Set the GDT values
void gdt_set_gate(s32int,u32int,u32int,u8int,u8int);

#endif
