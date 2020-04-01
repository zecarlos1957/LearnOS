#pragma once

#ifdef __cplusplus
extern "C" {
#endif

void __attribute__((__cdecl__)) _assert(const char* message, const char* file, unsigned int line);

#define assert(expression) (void)((!!(expression)) || (_assert(#expression, __FILE__, __LINE__), 0))

#ifdef __cplusplus
}
#endif