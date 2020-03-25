#include <stdint.h>
#include <string.h>

#include <kernel/hal/cpu/idt.h>

struct idt_entry
{
    uint16_t handler_offset_low_word;   // Low word of handler offset within the
                                        // given GDT segment.
    uint16_t gdt_handler_selector;      // GDT selector for the GDT segment
                                        // containing the given handler.
    uint8_t reserved;
    uint8_t flags;                      // Flags for this IDT entry.
    uint16_t handler_offset_high_word;  // High word of handler offset.
} __attribute__((__packed__));

#pragma pack(push, 2)

struct idt_descriptor
{
     uint16_t size;                      // Number of entries in the IDT.
     struct idt_entry *base;             // Address of the first entry of the IDT.
} __attribute__((__packed__));

#pragma pack(pop)

static struct idt_entry s_idt[IDT_MAX];

static int initialsie_entry(struct idt_entry *entry, void *handler_offset, int gdt_selector, int flags)
{
    if (!entry)
        return 1;

    memset(entry, 0, sizeof(struct idt_entry));

    entry->handler_offset_low_word = (uint16_t) (((int) handler_offset) & 0xffff);
    entry->handler_offset_high_word = (uint16_t) (((int) handler_offset) >> 16);
    entry->gdt_handler_selector = (uint16_t) gdt_selector;
    entry->flags = (uint8_t) flags;

    return 0;
}

static void load_descriptor(int size, void *base)
{
    struct idt_descriptor descriptor;
    descriptor.size = size;
    descriptor.base = base;
 
     __asm__ __volatile__ ("lidt (%0)" : : "r"(&descriptor));
}

int idt_init(void)
{
    memset(s_idt, 0, sizeof(s_idt));

    load_descriptor((int) sizeof(s_idt), s_idt);

    return 0;
}

static inline bool _is_valid_index(int index)
{
    return ((index >= 0) && (index <= IDT_MAX));
}

bool idt_is_valid_index(int index)
{
    return _is_valid_index(index);
}

bool idt_has_entry(int index)
{
    if (!_is_valid_index(index))
        return false;

    struct idt_entry entry = s_idt[index];

    return ((bool) (entry.flags & IDT_PRESENT));
}

int idt_set_entry(int index, void (*handler)(void), int selector, int flags)
{
    if (!_is_valid_index(index))
        return 1;

    struct idt_entry *entry_ptr = &(s_idt[index]);

    if (initialsie_entry(entry_ptr, (void *) handler, selector, flags))
        return 1;

    return 0;
}

