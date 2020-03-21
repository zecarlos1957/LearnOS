#include <assert.h>
#include <stdio.h>

static char* vidmem = (char*)0xB8000;

void __attribute__((__cdecl__)) _assert(const char* message, const char* file, unsigned int line)
{

    vidmem[0] = 'A';
    vidmem[1] = 0x05;
   printf("ASSERT %s %s %d\n", message, file, line);
}