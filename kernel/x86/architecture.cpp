#include <os.h>
#include <x86.h>

/* Stack pointer */
extern uint32_t *		stack_ptr;

/* Current cpu name */
static char cpu_name[512] = "x86-noname";


/* Detect the type of processor */
char* Architecture::detect(){
	cpu_vendor_name(cpu_name);
	return cpu_name;
}

/* Start and initialize the architecture */
void Architecture::init(){
	 io.print("Architecture x86, cpu=%s \n", detect());
	
 	 io.print("Loading GDT \n");
		 init_gdt();
/*		 asm("	movw $0x18, %%ax \n \
			movw %%ax, %%ss \n \
			movl %0, %%esp"::"i" (KERN_STACK));
 */		
	 io.print("Loading IDT \n");
		 init_idt();
		
		
	 io.print("Configure PIC \n");
		 init_pic();
	  
	 io.print("Loading Task Register \n");
///		 asm("	movw $0x38, %ax; ltr %ax");	 
}

/* Reboot the computer */
void Architecture::reboot(){
    uint8_t good = 0x02;
    while ((good & 0x02) != 0)
        good = io.inb(0x64);
    io.outb(0x64, 0xFE);
}

/* Shutdown the computer */
void Architecture::shutdown(){
	// todo
}

/* Install a interruption handler */
void Architecture::install_irq(int_handler h){
	// todo
}


/* Enable the interruption */
void Architecture::enable_interrupt(){
	asm volatile ("sti");
}

/* Disable the interruption */
void Architecture::disable_interrupt(){
	asm volatile("cli");
}
