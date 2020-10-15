
#include <kernel/symbol_table.h>
#include <kernel/elf.h>
#include <kernel/logging.h>

typedef struct
{
    bool present;
    uint32_t num_symbols;
    Elf32_Sym * symbols;
    char * strtab_addr;
}symbol_table_descriptor_t;

symbol_table_descriptor_t SymTabDesc;

char * address_to_symbol_name(uint32_t address);

void printSection(Elf32_Shdr* target,char* label)
{
     debug_print(INFO, "%s\nnm    %d          typ    %d\nflag  0x%x addr   0x%x\noff   0x%x size   %d\nlink  0x%x inf    0x%x\nalign 0x%x esize  0x%x", 
                 label, target->sh_name, target->sh_type, target->sh_flags, target->sh_addr, target->sh_offset,
                 target->sh_size, target->sh_link, target->sh_info, target->sh_addralign, target->sh_entsize);
                 
                  
}


bool load_symbol_table(Elf32_Shdr* symtab, Elf32_Shdr* strtab)
{
    if (symtab == 0)
    {
        SymTabDesc.present = false;
        return false;
    } 
    else 
    {
        SymTabDesc.present = true;
        SymTabDesc.num_symbols = symtab->sh_size / symtab->sh_entsize;
        SymTabDesc.symbols = (Elf32_Sym *) symtab->sh_addr;
        SymTabDesc.strtab_addr = (char*) strtab->sh_addr;
    
    /*
        for(int i = 0; i < SymTabDesc.num_symbols; i++)
        {
            Elf32_Sym * symbol = SymTabDesc.symbols + i;
            
            if (ELF32_ST_TYPE(symbol->st_info) == STT_FUNC)
            {
                char * name = (char*)(SymTabDesc.strtab_addr + symbol->st_name);
                debug_print(INFO,"0x%x %s", symbol->st_value, name);
            }
        }
        */
        return true;
    }
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

bool init_edata(Elf_hdr* info)
{
    Elf32_Shdr* Shdr = get_elf_section(info, ".edata");
    printSection(Shdr,"edata");
   // debug_print(INFO, "0x%x %d %d",Shdr->sh_type, Shdr->sh_size,Shdr->sh_entsize);
    while(1);
}

