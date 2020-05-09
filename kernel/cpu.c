#include "common.h"
#include "isr.h"

registers_t cpu_cpuid(int code)
{
	registers_t r;
	asm volatile("cpuid":"=a"(r.eax),"=b"(r.ebx),
                 "=c"(r.ecx),"=d"(r.edx):"0"(code));
	return r;
}


uint32_t cpu_vendor(char *name)
{
	registers_t r = cpu_cpuid(0x00);
		
	memcpy(name, (char *) &r.ebx, 4);
	memcpy(name+4, (char *) &r.edx, 4);
	memcpy(name+8, (char *) &r.ecx, 4);
    name[12] = '\0';  
    return r.eax;
}