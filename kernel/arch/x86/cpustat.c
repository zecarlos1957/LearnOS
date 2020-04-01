#include <stddef.h>
#include <core/panic.h>

#include <arch/x86/cpustat.h>

int dump_cpustat(char *buffer, int buffer_size, const struct cpustat cs)
{
    
 
    kernel_panic("Unimplemented dump_cpustat %d %d\n",buffer_size,cs.eflags);
    return -1;
}
