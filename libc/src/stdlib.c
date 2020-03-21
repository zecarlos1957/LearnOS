#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <kernel/panic.h>
#include <kernel/memory/memory.h>

#include <stdlib.h>

__attribute__((__noreturn__))
void __attribute__((__cdecl__)) abort(void)
{
#ifdef KRNL_BUILD
    kernel_panic("Abort was called");
#else
// TODO: Abnormally terminate the process as if by SIGABRT.
	printf("abort()\n");
#endif
	while (1);
}

char* __attribute__((__cdecl__)) itoa(int value, char* str, int base)
{
	int i = 0; 
    bool isNegative = false; 
  
    if (value == 0) 
    { 
        str[i++] = '0'; 
        str[i] = '\0'; 
        return str; 
    } 

    if (value < 0 && base == 10) 
    { 
        isNegative = true; 
        value = -value; 
    } 

    while (value != 0) 
    { 
        int rem = value % base; 
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0'; 
        value = value / base; 
    } 
  
    if (isNegative) 
        str[i++] = '-'; 
  
    str[i] = '\0';
  
    strrev(str); 
    return str; 
}

void* __attribute__((__cdecl__)) calloc(size_t num, size_t size)
{
    void* mem = (void*)m_alloc(size * num);
    memset(mem, 0, size);
    return mem;
}

void* __attribute__((__cdecl__)) malloc(size_t size)
{
    return (void*)m_alloc(size);
}

void __attribute__((__cdecl__)) free(void* ptr)
{
    m_free(ptr);
}