#include <stddef.h>
#include <core/panic.h>
#include <runtime/string.h>

#include <arch/x86/cpustat.h>

register_t cpu_cpuid(int code)
{
	register_t r;
	asm volatile("cpuid":"=a"(r.eax),"=b"(r.ebx),
                 "=c"(r.ecx),"=d"(r.edx):"0"(code));
	return r;
}

char *cpu_vendor_name(char *name)
{
	register_t r = cpu_cpuid(0x00);
		
    memcpy(name, (char*)&r.ebx, 4);
    memcpy(name+4, (char*)&r.edx, 4);
    memcpy(name+8, (char*)&r.ecx, 4);
    *(name+0x0d) = '\0';
	return name;
/// { asm volatile ("cpuid" : "=a"(a),"=b"(b),"=c"(c),"=d"(d) : "a"(in)); } while(0)
}

int dump_cpustat(char *buffer, int buffer_size, const struct cpustat cs)
{
    
 
    kernel_panic("Unimplemented dump_cpustat %d %d\n",buffer_size,cs.eflags);
    return -1;
}
