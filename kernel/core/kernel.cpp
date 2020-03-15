
#include <os.h>
#include <boot.h>

Io 				io;			/* Input/Output interface */
Architecture 	arch;		/*	Cpu and architecture interface */

static const char* init_argv[2]={"init","-i"};

 
extern "C" void kmain(multiboot_info* mbi){
	io.clear();
	io.print("%s - %s -- %s %s \n",	KERNEL_NAME,
									KERNEL_VERSION,
									KERNEL_DATE,
									KERNEL_TIME);
	
	io.print("%s \n",KERNEL_LICENCE);
 	arch.init();
/* 	
	io.print("Loading Virtual Memory Management \n");
	vmm.init(mbi->high_mem);
  	
	io.print("Loading FileSystem Management \n");
	fsm.init();
	
	io.print("Loading syscalls interface \n");
	syscall.init();
	
	io.print("Loading system \n");
	sys.init();
	
	io.print("Loading modules \n");
	modm.init();
	modm.initLink();


	modm.install("hda0","module.dospartition",0,"/dev/hda");
	modm.install("hda1","module.dospartition",1,"/dev/hda");
	modm.install("hda2","module.dospartition",2,"/dev/hda");
	modm.install("hda3","module.dospartition",3,"/dev/hda");
	modm.mount("/dev/hda0","boot","module.ext2",NO_FLAG);

	arch.initProc();
	
	io.print("Loading binary modules \n");
	load_modules(mbi);
	
	fsm.link("/mnt/boot/bin/","/bin/");

*/	
	io.print("\n");
	io.print("  ==== System is ready (%s - %s) ==== \n",KERNEL_DATE,KERNEL_TIME);
	arch.enable_interrupt();
 	for (;;);
	arch.shutdown();
 
}

