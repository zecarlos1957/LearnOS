#pragma once

#ifdef __cplusplus
extern "C" {
#endif

int* __attribute__((__cdecl__)) _errno(void);
#define errno (*_errno())

int __attribute__((__cdecl__)) _set_errno(int value);
int __attribute__((__cdecl__)) _get_errno(int* value);

#define EOVERFLOW   75      /* Value too large for defined data type */

#ifdef __cplusplus
}
#endif