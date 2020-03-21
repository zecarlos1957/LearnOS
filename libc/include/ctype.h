#pragma once

#ifdef __cplusplus
extern "C" {
#endif

int __attribute__((__cdecl__)) isalnum(int c);
int __attribute__((__cdecl__)) isalpha(int c);
int __attribute__((__cdecl__)) isblank(int c);
int __attribute__((__cdecl__)) iscntrl(int c);
int __attribute__((__cdecl__)) isdigit(int c);
int __attribute__((__cdecl__)) isgraph(int c);
int __attribute__((__cdecl__)) islower(int c);
int __attribute__((__cdecl__)) isprint(int c);
int __attribute__((__cdecl__)) ispunct(int c);
int __attribute__((__cdecl__)) isspace(int c);
int __attribute__((__cdecl__)) isupper(int c);
int __attribute__((__cdecl__)) isxdigit(int c);

int __attribute__((__cdecl__)) tolower(int c);
int __attribute__((__cdecl__)) toupper(int c);

#ifdef __cplusplus
}
#endif