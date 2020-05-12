// main.c -- Defines the C-code kernel entry point, calls initialisation routines.
//           Made for JamesM's tutorials <www.jamesmolloy.co.uk>

#include <kernel/monitor.h>
#include <kernel/descriptor_tables.h>
#include <kernel/timer.h>
#include <kernel/paging.h>
#include <kernel/multiboot.h>
#include <kernel/fs.h>
#include <kernel/initrd.h>
#include <kernel/task.h>
#include <syscall.h>
#include <kernel/common.h>


extern uint32_t placement_address;
uint32_t initial_esp;

int kmain(struct multiboot *mboot_ptr, uint32_t initial_stack)
{
    monitor_clear();
    initial_esp = initial_stack;
 
    init_cpu();
   // Initialise all the ISRs and segmentation
    init_descriptor_tables();
    // Initialise the screen (by clearing it)

    // Initialise the PIT to 100Hz
    asm volatile("sti");
    init_timer(50);

    // Find the location of our initial ramdisk.
    ASSERT(mboot_ptr->mods_count > 0);
    uint32_t initrd_location = *((uint32_t*)mboot_ptr->mods_addr);
    uint32_t initrd_end = *(uint32_t*)(mboot_ptr->mods_addr+4);
    // Don't trample our module with placement accesses, please!
    placement_address = initrd_end;

    // Start paging.
    initialise_paging(mboot_ptr->mem_upper + mboot_ptr->mem_lower);

    // Start multitasking.
    initialise_tasking();

    // Initialise the initial ramdisk, and set it as the filesystem root.
    fs_root = initialise_initrd(initrd_location);

    initialise_syscalls();

    switch_to_user_mode();

    syscall_monitor_write("Hello, user world!\n");

    return 0;
}
