#ifndef INCLUDE_SYMBOL_TABLE_H
#define INCLUDE_SYMBOL_TABLE_H

#include <kernel/multiboot.h>
#include <kernel/elf.h>


bool init_edata(Elf_hdr* info);

bool load_symbol_table(Elf32_Shdr * symbol_table_section, Elf32_Shdr * string_table_section);

Elf32_Shdr * get_elf_section(Elf_hdr* info, char * section_name);

#endif /* INCLUDE_SYMBOL_TABLE_H */
