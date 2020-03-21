#pragma once

#include <kernel/hal/cpu/cpustat.h>

#ifdef __cplusplus
extern "C" {
#endif

struct isr_params
{
    struct cpustat cs;
};

#define ISR_HANDLER(ISRFUNC) __handle_##ISRFUNC
#define ISR_HANDLER_ATTR 

#define __ISR_HOOK_HANDLER_BASE(ISRFUNC, ISRBODY)       \
    void ISR_HANDLER_ATTR ISRFUNC(void)                 \
    {                                                   \
        __asm__ __volatile__ (                          \
            "pusha"                                     \
        );                                              \
        {                                               \
             ISRBODY                            \
        }                                               \
        __asm__ __volatile__ (                          \
            "popa   \n\t"                               \
            "leave  \n\t"                               \
            "iret   \n\t"                               \
        );                                              \
    }

#define ISR_DEF_HANDLER(ISRFUNC)                        \
    __ISR_HOOK_HANDLER_BASE(ISR_HANDLER(ISRFUNC),       \
    {                                                   \
         extern void ISRFUNC(struct isr_params params);  \
        struct isr_params params;                       \
        params.cs = collect_cpustat();                  \
        ISRFUNC(params);                                 \
    });

#define ISR_DEF_HANDLER_NOPARAMS(ISRFUNC)               \
    __ISR_HOOK_HANDLER_BASE(ISR_HANDLER(ISRFUNC),       \
    {                                                   \
         extern void ISRFUNC(void);                      \
        ISRFUNC();                                       \
    });

int isr_init(void);

int isr_set_handler(int isrnum, void (*handler)(void));

#ifdef __cplusplus
}
#endif