/*
  * @ File : IDT.h
  * @ Description : This initialises the IDT
*/

#ifndef IDT_H_INCLUDED
#define IDT_H_INCLUDED

#include <system.h>

// @ Defines
#define PIC_MASTER_COMMAND 0x20
#define PIC_MASTER_DATA 0x21
#define PIC_SLAVE_COMMAND 0xA0
#define PIC_SLAVE_DATA 0xA1

// @ Define : The Interrupt Gate
struct idt_entry_struct
{
  u16int base_lo;             // The lower 16 bits of the address to jump to when this interrupt fires.
  u16int sel;                 // Kernel segment selector.
  u8int  always0;             // This must always be zero.
  u8int  flags;               // More flags. See documentation.
  u16int base_hi;             // The upper 16 bits of the address to jump to.
} __attribute((packed));
typedef idt_entry_struct idt_entry_t;

// @ Define : The Pointer to the Interrupt Gate
struct idt_ptr_struct
{
  u16int limit;
  u32int base;
} __attribute((packed));
typedef idt_ptr_struct idt_ptr_t;

// @ Functions
// @ Task : Load the IDT , Defined in IDT.s
extern "C" void idt_flush(u32int);

void init_idt();
void idt_set_gate(u8int,u32int,u16int,u8int);

// @ Task : Set up the IDT from the Assembly
extern "C" {
  extern int isr0();
  extern int isr1();
  extern int isr2();
  extern int isr3();
  extern int isr4();
  extern int isr5();
  extern int isr6();
  extern int isr7();
  extern int isr8();
  extern int isr9();
  extern int isr10();
  extern int isr11();
  extern int isr12();
  extern int isr13();
  extern int isr14();
  extern int isr15();
  extern int isr16();
  extern int isr17();
  extern int isr18();
  extern int isr19();
  extern int isr20();
  extern int isr21();
  extern int isr22();
  extern int isr23();
  extern int isr24();
  extern int isr25();
  extern int isr26();
  extern int isr27();
  extern int isr28();
  extern int isr29();
  extern int isr30();
  extern int isr31();
}

// The IRQ Handlers
extern "C" {
  extern int irq0();
  extern int irq1();
  extern int irq2();
  extern int irq3();
  extern int irq4();
  extern int irq5();
  extern int irq6();
  extern int irq7();
  extern int irq8();
  extern int irq9();
  extern int irq10();
  extern int irq11();
  extern int irq12();
  extern int irq13();
  extern int irq14();
  extern int irq15();

}

#endif
