

COBJS = entry_asm.o \
	gdt_asm.o \
	idt_asm.o \
	irq_asm.o \
	isr_asm.o \
	task_asm.o \
	tss_asm.o \
	user_asm.o \
	cpu/gdt.o \
	cpu/idt.o \
	cpu/irq.o \
	cpu/isr.o \
	devices/cmos.o \
	devices/fpu.o \
	devices/pci.o \
	devices/timer.o \
	ds/bitset.o \
	ds/ringbuf.o \
	fs/pipe.o \
	fs/ramdisk.o \
	fs/tty.o \
	fs/unixpipe.o \
	fs/vfs.o \
	mem/alloc.o \
	mem/mem.o \
	mem/shm.o \
	misc/args.o \
	misc/elf.o \
	misc/kprintf.o \
	misc/lgcc.o \
	misc/logging.o \
	misc/multiboot.o \
	misc/symbol_table.o \
	misc/tokenize.o \
	misc/ubsan.o \
	sys/module.o \ 
	sys/panic.o \
	sys/process.o \
	sys/signal.o \
	sys/syscall.o \
	sys/system.o \
	sys/task.o \
	sys/version.o \
	libc.o \
	spin.o \
	main.o 


CC = ccache gcc
LD = ccache ld
AR = ccache ar
AS = ccache as
OC = objcopy

WARNINGS = -Wall 
CFLAGS = $(WARNINGS) -nostdlib -nostdinc -fno-builtin  -D_KERNEL_  -m32  -I../base/usr/include   -Ofast

 

../cdboot/kernel.so: ../bin/kernel.dll
	@$(OC) -O elf32-i386  $< $@


../bin/kernel.dll:  $(COBJS)
	$(CC) -nodefaultlibs -o $@ $(CFLAGS) -shared  $^  
 

%.o: %.c
	@$(CC) -c $(CFLAGS) $< -o $@


%_asm.o: %S
	@$(AS)   $< -o $@

clean:
	@rm *.o
	@rm ./*/*.o
	@rm ../bin/kernel.dll
