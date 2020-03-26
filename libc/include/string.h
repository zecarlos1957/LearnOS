#pragma once
 
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

int __attribute__((__cdecl__)) memcmp(const void*, const void*, size_t);
void* __attribute__((__cdecl__)) memcpy(void* __restrict, const void* __restrict, size_t);
void* __attribute__((__cdecl__)) memmove(void*, const void*, size_t);
void* __attribute__((__cdecl__)) memset(void*, int, size_t);
size_t __attribute__((__cdecl__)) strlen(const char*);
char* __attribute__((__cdecl__)) strrev(char *str);
char* __attribute__((__cdecl__)) strcpy(char *dst,const char *src);
char* __attribute__((__cdecl__)) strcat(char *s2,const char *s1);

#ifdef __cplusplus
}
#endif