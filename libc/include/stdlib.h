#pragma once

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif
 
__attribute__((__noreturn__))
void __attribute__((__cdecl__)) abort(void);

char* __attribute__((__cdecl__)) itoa(int value, char* str, int base);

void* __attribute__((__cdecl__)) calloc(size_t num, size_t size);
void* __attribute__((__cdecl__)) malloc(size_t size);
void __attribute__((__cdecl__)) free(void* ptr);

#ifdef __cplusplus
}
#endif