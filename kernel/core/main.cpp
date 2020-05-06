#include <modules/tty.h>
#include <modules/keyboard.h>
#include <core/hal.h>
#include <core/pit.h>
#include <core/panic.h>
#include <core/bootinfo.h>
#include <core/memory.h>
#include <arch/x86/cpustat.h>

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>
 


     
     
static int on_key_event(const struct kb_key *key)
{
    uint8_t keycode = key->keycode;

    // Only process key-presses
    if (key->event == KB_PRESS)
	{
        // If the control key is being held, perform an action
        if (key->modifiers & KB_MOD_CTRL)
		{
            if (keycode == 'l')
			{
                terminal_clear();
            } else if (keycode == 'p') {
                kernel_panic("manual panic (ctrl+p)\n");
            } else {
                // No appropriate command, print the letter preceded by a '^'
                printf("^");
                printf("%c", toupper(keycode));
            }

            return 0;
        }

        // Make sure that this isn't the key-press of a modifier key
        if (key->keycode < 250)
		{
            if ((key->modifiers & KB_MOD_SHIFT) && islower(keycode))
                keycode = toupper(keycode);

            printf("%c", keycode);
        }
    }

    return 0;
}
 
static void init(multiboot_info* bootinfo)
{
    uint32_t kernelSize = 0;
    extern uint32_t kernel_end;
    char cpu_vendor[32];

      __asm__ __volatile__("mov %%dx, %0" : "=m"(kernelSize));

    terminal_initialize();
               
    mm_init((uint32_t)&kernel_end); 

   
     hal_init();
     kb_init();
 
    paging_init();
	
    int bits = sizeof(void*) * 8;
    printf("- %s %i bits RAM free %dKb\n", cpu_vendor_name(cpu_vendor), bits, bootinfo->m_memoryLo);
}

extern "C" void floppy_detect_drives();
 
extern "C" void kmain(multiboot_info* bootinfo)
{
     init(bootinfo);
 	kb_add_listener(on_key_event);

    floppy_detect_drives();

      pit_start_counter(100, I86_PIT_OCW_COUNTER_0, I86_PIT_OCW_MODE_SQUAREWAVEGEN);

    while(pit_get_tick_count() < 50)
    {
  //       printf("%d ", pit_get_tick_count());
    }
 
#define ever ;;
    for(ever);
#undef ever
}
