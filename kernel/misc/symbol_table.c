
#include <kernel/symbol_table.h>
#include <kernel/elf.h>
#include <kernel/logging.h>
#include <kernel/module.h>

extern uint32_t SymTabSize;
extern char kernel_symbols_start[];
extern char kernel_symbols_end[];


void printSection(Elf32_Shdr* target,char* label)
{
     debug_print(INFO, "%s\nnm    %d          typ    %d\nflag  0x%x addr   0x%x\noff   0x%x size   %d\nlink  0x%x inf    0x%x\nalign 0x%x esize  0x%x", 
                 label, target->sh_name, target->sh_type, target->sh_flags, target->sh_addr, target->sh_offset,
                 target->sh_size, target->sh_link, target->sh_info, target->sh_addralign, target->sh_entsize);
                 
                  
}


bool build_symbol_table(Elf32_Shdr* symtab, Elf32_Shdr* strtab)
{
    if(symtab->sh_type != SHT_SYMTAB ||
       strtab->sh_type != SHT_STRTAB)
    {
        return false;
    }
    
    int num = symtab->sh_size / symtab->sh_entsize;
    Elf32_Sym *symbol = (Elf32_Sym *) symtab->sh_addr;
    char* strtab_addr = (char*) strtab->sh_addr;
    int n = 0;

    kernel_symbol_t *k = (kernel_symbol_t*)&kernel_symbols_start;

    for(int i = 0; i < num; i++)
    {
        char * name = (char*)(strtab_addr + symbol->st_name);

        if (ELF32_ST_BIND(symbol->st_info) == STB_GLOBAL)
        {
            k->addr = symbol->st_value;
            strcpy(k->name, name);
            k = (kernel_symbol_t *)((uintptr_t)k + sizeof(uintptr_t) + strlen(k->name) + 1);
        }
        symbol++;
    }
    SymTabSize = (uint32_t)k - (uint32_t)&kernel_symbols_start;

    return true;

}


Elf32_Shdr * get_elf_section(Elf_hdr* info, char* section_name)
{

    Elf32_Shdr* Shdr = (Elf32_Shdr*) info->addr;
    uint32_t strtab = Shdr[info->shndx].sh_addr;

    for (uint32_t i = 0; i < info->num; i++)
    {
        uint32_t sh_name = Shdr[i].sh_name;
        if (sh_name)
        {
            char* name = (char*) (strtab + sh_name);

            if (strcmp(name, section_name) == 0)
                return Shdr + i;
        }
    }

    return 0;
}

