#include <errno.h>

static int errno_val = 0;

int* __attribute__((__cdecl__)) _errno(void)
{
    return &errno_val;
}

int __attribute__((__cdecl__)) _set_errno(int value)
{
    errno_val = value;
    return 0;
}

int __attribute__((__cdecl__)) _get_errno(int* value)
{
    *value = errno_val;
    return 0;
}