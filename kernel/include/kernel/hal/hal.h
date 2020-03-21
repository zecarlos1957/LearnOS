#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#define geninterrupt(arg) __asm__ __volatile__ ("int %0\n" : : "N"((arg)) : "cc", "memory")

int hal_init(void);
void hal_enable(void);
void hal_disable(void);

#ifdef __cplusplus
}
#endif