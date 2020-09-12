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

    monitor_write("memory report by GRUB ");
    monitor_write_dec((mboot_ptr->mem_upper + mboot_ptr->mem_lower));
    monitor_write("Kb\n");
    // Start paging.
    initialise_paging(mboot_ptr->mem_upper + mboot_ptr->mem_lower);

    // Start multitasking.
    initialise_tasking();

    // Initialise the initial ramdisk, and set it as the filesystem root.
    fs_root = initialise_initrd(initrd_location);

     int ret = fork();
    
    monitor_write("fork() returned ");
    monitor_write_hex(ret);
    monitor_write(" pid ");
    monitor_write_hex(getpid());
    monitor_write("\n================================================\n");
    
    asm volatile("cli");
 
    int i = 0;
   struct dirent *node = 0;
   while ( (node = readdir_fs(fs_root, i)) != 0)
   {
       monitor_write("Found file ");
       monitor_write(node->name);
       fs_node_t *fsnode = finddir_fs(fs_root, node->name);

       if ((fsnode->flags&0x7) == FS_DIRECTORY)
       {
           monitor_write("\n\t(directory)\n");
       }
       else
       {
           monitor_write("\n\t contents: \"");
           char buf[256];
           uint32_t sz = read_fs(fsnode, 0, 256, buf);
           int j;
           for (j = 0; j < sz; j++)
               monitor_put(buf[j]);

           monitor_write("\"\n");
       }
       i++;
   }
    
   monitor_write("\n");

   asm volatile("sti");

/*
    initialise_syscalls();

    switch_to_user_mode();

    syscall_monitor_write("Hello, user world!\n");
*/
    return 0;
}
