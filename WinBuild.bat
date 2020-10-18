echo off
echo Build script for Windows
echo.

 if not exist bin   mkdir bin
 cd bin
 if not exist kernel mkdir kernel
 if not exist libc mkdir libc
 if not exist modules mkdir modules
 cd ../

rem ********************************************************************

rem              Build KERNEL


cd ./kernel/cpu 
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/gdt.o gdt.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/idt.o idt.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/irq.o irq.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/isr.o isr.c
cd ../devices
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/cmos.o cmos.c    
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/fpu.o fpu.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/pci.o pci.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/timer.o timer.c
cd ../ds
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/bitset.o bitset.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ringbuffer.o ringbuffer.c
cd ../fs
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/pipe.o pipe.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ramdisk.o ramdisk.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/tty.o tty.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/unixpipe.o unixpipe.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/vfs.o vfs.c
cd ../mem
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/alloc.o alloc.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/mem.o mem.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/shm.o shm.c
cd ../misc
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/args.o args.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/elf.o elf.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/kprintf.o kprintf.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/lgcc.o lgcc.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/logging.o logging.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/multiboot.o multiboot.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/tokenize.o tokenize.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ubsan.o ubsan.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/symbol_table.o symbol_table.c 
cd ../sys
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/module.o module.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/panic.o panic.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/process.o process.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/signal.o signal.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/syscall.o syscall.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/system.o system.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/task.o task.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/version.o version.c
cd ../
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/libc.o libc.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/spin.o spin.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/main.o main.c

    as boot.s -o ../bin/kernel/entry.o 
    as gdt.s -o ../bin/kernel/_gdt.o
    as idt.s -o ../bin/kernel/_idt.o
    as irq.s -o ../bin/kernel/_irq.o
    as isr.s -o ../bin/kernel/_isr.o
    as task.s -o ../bin/kernel/_task.o
    as tss.s -o ../bin/kernel/_tss.o
    as user.s -o ../bin/kernel/_user.o
cd ../lib
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/hashmap.o hashmap.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/tree.o tree.c
    gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/list.o list.c
cd ../util
 rem   gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../base/usr/include -c -o ../bin/lm.o lm.c
 rem   gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../base/usr/include -c -o ../bin/netinit.o netinit.c
 rem   gcc -ffreestanding -pedantic -fno-omit-frame-pointer -D_BUILD_DLL_ -D_KERNEL_ -I../base/usr/include -c -o ../bin/ungz.o ungz.c
    as compiler-rt.s -o ../bin/kernel/compiler.o
   
    
rem ********************************************************************
    
rem            Build MODULES
    
    
cd ../modules
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/zero.o zero.c
 rem   gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ac97.o ac97.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/snd.o snd.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/random.o random.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/serial.o serial.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/debug_sh.o debug_sh.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/procfs.o procfs.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/tmpfs.o tmpfs.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ata.o ata.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ext2.o ext2.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/iso9660.o iso9660.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ps2kbd.o ps2kbd.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ps2mouse.o ps2mouse.c
rem    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/lfbvideo.o lfbvideo.c
rem    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vbox.o vbox.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vgadbg.o vgadbg.c
rem    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vgalog.o vgalog.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vidset.o vidset.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/packetfs.o packetfs.c
 rem   gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/e1000.o e1000.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/pcspkr.o pcspkr.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/portio.o portio.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/tarfs.o tarfs.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/xtest.o xtest.c

 rem    objcopy -O elf32-i386 ../bin/modules/zero.exe ../cdboot/sys/zero.ko
 rem    objcopy -O elf32-i386 ../bin/modules/vgalog.o ../cdboot/sys/vgalog.ko
 rem    objcopy -O elf32-i386 ../bin/modules/ps2kbd.o ../cdboot/sys/ps2kbd.ko
 rem    objcopy -O elf32-i386 ../bin/modules/ps2mouse.o ../cdboot/sys/ps2mouse.ko
 rem   objcopy -O elf32-i386 ../bin/modules/vgadbg.o ../cdboot/sys/vgadbg.ko
  rem   objcopy -O elf32-i386 ../bin/modules/ac97.o ../cdboot/sys/ac97.ko
 rem    objcopy -O elf32-i386 ../bin/modules/serial.o ../cdboot/sys/serial.ko
 rem    objcopy -O elf32-i386 ../bin/modules/snd.o ../cdboot/sys/snd.ko
  rem  objcopy -O elf32-i386 ../bin/modules/debug_sh.o ../cdboot/sys/debug_sh.ko



rem ********************************************************************
  
rem                   Build APPLICATIONS


rem ***********************************************************************



  cd ../bin/kernel    
     ld  -T../../kernel/link.ld -M -Map ../mapfile.map  -shared -o ../krnl32.exe compiler.o _gdt.o _idt.o _irq.o _isr.o _task.o _tss.o _user.o gdt.o idt.o irq.o isr.o entry.o cmos.o fpu.o pci.o timer.o bitset.o hashmap.o list.o ringbuffer.o tree.o pipe.o ramdisk.o tty.o unixpipe.o vfs.o alloc.o mem.o shm.o args.o elf.o kprintf.o lgcc.o logging.o multiboot.o tokenize.o ubsan.o symbol_table.o module.o panic.o process.o signal.o syscall.o system.o task.o version.o libc.o spin.o main.o

 
     ar rcs ../libliba.a tree.o hashmap.o list.o
 cd ../
     objcopy  -O elf32-i386 krnl32.exe ../cdboot/sys/krnl32.elf

 

cd ../
    mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table   -o learnos.iso  cdboot


   D:/programas/oracle/virtualbox/vboxmanage startvm LearnOS

:done
echo DoneOK.

pause


echo on
