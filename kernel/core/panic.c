#include <stdarg.h>
#include <stdio.h>

#include <core/panic.h>

void kernel_panic(const char* fmt, ...)
{
    va_list	args;
    va_start(args, fmt);

    printf(fmt, args);
    va_end(args);

    for(;;);
}
