#pragma once

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif
 
__attribute__((__noreturn__))
void __attribute__((__cdecl__)) abort(void);

char* __attribute__((__cdecl__)) itoa(int value, char* str, int base);

void* __attribute__((__cdecl__)) calloc(int num, int size);
void* __attribute__((__cdecl__)) malloc(int size);
void __attribute__((__cdecl__)) free(void* ptr);

#ifdef __cplusplus
}
#endif