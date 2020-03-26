#pragma once

#include <stdint.h>
#include <stddef.h>

typedef struct 
{
    uint32_t edi;
    uint32_t esi;
    uint32_t ebp;
    uint32_t esp;
    uint32_t ebx;
    uint32_t edx;
    uint32_t ecx;
    uint32_t eax;
}register_set;

typedef struct
{
	register_set dregs;
	uint32_t ds, es, fs, gs;
	uint32_t which_int, err_code;
	uint32_t eip, cs, eflags, user_esp, user_ss;
} __attribute__((packed)) regs_t;

#ifdef __cplusplus
extern "C" {
#endif




static inline __attribute__((__always_inline__)) register_set get_registers(void)
{
    register_set regset;
    __asm__ __volatile__ (
        "pusha;"
         "mov  %%esp, %0;"
        "add  %1, %%esp;":
         "=g"(regset):
        "Z"(sizeof(register_set))
    ); 
    return regset;
}

static inline __attribute__((__always_inline__)) uint32_t get_eflags(void)
{
    uint32_t result;
    __asm__ __volatile__ (
        "pushf  \n\t"
        "pop %0 \n\t":
        "=g"(result)
    ); 
    return result;
}

struct cpustat
{
     register_set regset;
    uint32_t eflags;
};

static inline __attribute__((__always_inline__)) struct cpustat collect_cpustat(void)
{
    struct cpustat cs;
    cs.regset = get_registers();
    cs.eflags = get_eflags();
    return cs;
}

int dump_cpustat(char *buffer, size_t buffer_size, const struct cpustat cs);
uint32_t cpu_vendor_name(char *name);

#ifdef __cplusplus
}
#endif