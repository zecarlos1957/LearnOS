#include <stddef.h>
#include <kernel/panic.h>

#include <kernel/hal/cpu/cpustat.h>

int dump_cpustat(char *buffer, size_t buffer_size, const struct cpustat cs)
{
    
 
    kernel_panic("Unimplemented dump_cpustat %d %d\n",buffer_size,cs.eflags);
    return -1;
}