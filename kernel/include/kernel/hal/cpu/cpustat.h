#pragma once

#include <stdint.h>
#include <stddef.h>

struct register_set
{
    uint32_t di;
    uint32_t si;
    uint32_t bp;
    uint32_t sp;
    uint32_t b;
    uint32_t d;
    uint32_t c;
    uint32_t a;
};

#ifdef __cplusplus
extern "C" {
#endif

static struct register_set regs;


static inline __attribute__((__always_inline__)) struct register_set get_registers(void)
{
    struct register_set *regset = &regs;
    __asm__ __volatile__ (
        "pusha;"
         "mov  %%esp, %0;"
        "add  %1, %%esp;":
         "=g"( *regset):
        "Z"(sizeof(struct register_set))
    ); 
    return *regset;
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
    struct register_set regset;
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

#ifdef __cplusplus
}
#endif