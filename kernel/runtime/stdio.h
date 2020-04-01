#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#define EOF (-1)
 
int __attribute__((__cdecl__)) printf(const char* __restrict, ...);
int __attribute__((__cdecl__)) putchar(int);
int __attribute__((__cdecl__)) puts(const char*);
 
#ifdef __cplusplus
}
#endif