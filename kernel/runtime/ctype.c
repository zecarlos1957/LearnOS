#include <ctype.h>

int __attribute__((__cdecl__)) isalnum(int c)
{
    return (c >= 0x30 && c <= 0x39) || (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A);
}

int __attribute__((__cdecl__)) isalpha(int c)
{
    return (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A);
}

int __attribute__((__cdecl__)) isblank(int c)
{
    return (c == 0x9) || (c == 0x20);
}

int __attribute__((__cdecl__)) iscntrl(int c)
{
    return (c >= 0x0 && c <= 0x1F) || (c == 0x7F);
}

int __attribute__((__cdecl__)) isdigit(int c)
{
    return (c >= 0x30 && c <= 0x39);
}

int __attribute__((__cdecl__)) isgraph(int c)
{
    return (c >= 0x21 && c <= 0x7E);
}

int __attribute__((__cdecl__)) islower(int c)
{
    return (c >= 0x61 && c <= 0x7A);
}

int __attribute__((__cdecl__)) isprint(int c)
{
    return (c >= 0x20 && c <= 0x7E);
}

int __attribute__((__cdecl__)) ispunct(int c)
{
    return (c >= 0x30 && c <= 0x39) || (c >= 0x3A && c <= 0x40) || (c >= 0x5B && c <= 0x60) || (c >= 0x7B && c <= 0x7E);
}

int __attribute__((__cdecl__)) isspace(int c)
{
    return (c >= 0x09 && c <= 0x0D) || (c == 0x20);
}

int __attribute__((__cdecl__)) isupper(int c)
{
    return (c >= 0x41 && c <= 0x5A);
}

int __attribute__((__cdecl__)) isxdigit(int c)
{
    return (c >= 0x30 && c <= 0x39) || (c >= 0x41 && c <= 0x46) || (c >= 0x61 && c <= 0x66);
}

int __attribute__((__cdecl__)) tolower(int c)
{
    if(isupper(c))
        return c + 0x20;
    else
        return c;
}

int __attribute__((__cdecl__)) toupper(int c)
{
    if(islower(c))
        return c - 0x20;
    else
        return c;
}