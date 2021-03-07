@echo off
echo Build script for Windows
echo.

rem goto mkiso
rem cd ./apps
rem goto Bapp

 if not exist bin   mkdir bin
 cd bin
 if not exist apps mkdir apps
 if not exist kernel mkdir kernel
 if not exist lib mkdir lib
 if not exist libc mkdir libc
 if not exist modules mkdir modules
 cd ../

rem ********************************************************************

echo              Build Boot Loader

del learnos.iso

rem cd ./loader
 rem   call BuildBoot.bat
rem cd ../

rem goto RUN



echo              Build KERNEL


cd ./kernel/cpu 
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/gdt.o gdt.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/idt.o idt.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/irq.o irq.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/isr.o isr.c
    
    if errorlevel 1 goto err_done

cd ../devices
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/cmos.o cmos.c    
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/fpu.o fpu.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/pci.o pci.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/timer.o timer.c
    
    if errorlevel 1 goto err_done

cd ../ds
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/bitset.o bitset.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ringbuffer.o ringbuffer.c
cd ../fs
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/pipe.o pipe.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ramdisk.o ramdisk.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/tty.o tty.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/unixpipe.o unixpipe.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/vfs.o vfs.c
    
    if errorlevel 1 goto err_done

cd ../mem
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/alloc.o alloc.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/mem.o mem.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/shm.o shm.c
    
    if errorlevel 1 goto err_done

cd ../misc
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/args.o args.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/elf.o elf.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/kprintf.o kprintf.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/lgcc.o lgcc.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/logging.o logging.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/multiboot.o multiboot.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/tokenize.o tokenize.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ubsan.o ubsan.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/symbol_table.o symbol_table.c 
    
    if errorlevel 1 goto err_done

cd ../sys
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/module.o module.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/panic.o panic.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/process.o process.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/signal.o signal.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/syscall.o syscall.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/system.o system.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/task.o task.c
    gcc -ffreestanding  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/version.o version.c
    
    if errorlevel 1 goto err_done

cd ../
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/libc.o libc.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/spin.o spin.c
    gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/main.o main.c
    
    if errorlevel 1 goto err_done


    as entry.s -o ../bin/kernel/entry.o 
    as gdt.s -o ../bin/kernel/_gdt.o
    as idt.s -o ../bin/kernel/_idt.o
    as irq.s -o ../bin/kernel/_irq.o
    as isr.s -o ../bin/kernel/_isr.o
    as task.s -o ../bin/kernel/_task.o
    as tss.s -o ../bin/kernel/_tss.o
    as user.s -o ../bin/kernel/_user.o
cd ../lib
 rem   gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/hashmap.o hashmap.c
 rem   gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/tree.o tree.c
 rem   gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/list.o list.c
cd ../util
 rem   gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/lm.o lm.c
 rem   gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/netinit.o netinit.c
 rem   gcc -ffreestanding  -D_KERNEL_ -I../base/usr/include -c -o ../bin/ungz.o ungz.c
    as compiler-rt.s -o ../bin/kernel/compiler.o
   
if errorlevel 1 goto err_done

rem ********************************************************************


 cd ../lib
rem    mingw32-make Makefile clean
    mingw32-make Makefile ../bin/libm.a
 rem   mingw32-make Makefile libtoaru

rem            Build LIBC
rem cd ../libc
rem  call BuildLibC

echo              Build MODULES
    
    
cd ../modules
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/zero.o zero.c 
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/hda.o hda.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/snd.o snd.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/random.o random.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/serial.o serial.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/debug_sh.o debug_sh.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/procfs.o procfs.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/tmpfs.o tmpfs.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ata.o ata.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ext2.o ext2.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/iso9660.o iso9660.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ps2kbd.o ps2kbd.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ps2mouse.o ps2mouse.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/lfbvideo.o lfbvideo.c
rem    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vbox.o vbox.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vgadbg.o vgadbg.c 
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vgalog.o vgalog.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vidset.o vidset.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/packetfs.o packetfs.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/pcspkr.o pcspkr.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/portio.o portio.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/tarfs.o tarfs.c
    gcc -ffreestanding -nostdlib -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/xtest.o xtest.c

if errorlevel 1 goto err_done

    objcopy -O elf32-i386 ../bin/modules/zero.o ../cdboot/mod/zero.ko
    objcopy -O elf32-i386 ../bin/modules/random.o ../cdboot/mod/random.ko
    objcopy -O elf32-i386 ../bin/modules/serial.o ../cdboot/mod/serial.ko
    objcopy -O elf32-i386 ../bin/modules/debug_sh.o ../cdboot/mod/debug_sh.ko
    objcopy -O elf32-i386 ../bin/modules/procfs.o ../cdboot/mod/procfs.ko
    objcopy -O elf32-i386 ../bin/modules/tmpfs.o ../cdboot/mod/tmpfs.ko
    objcopy -O elf32-i386 ../bin/modules/ata.o ../cdboot/mod/ata.ko
    objcopy -O elf32-i386 ../bin/modules/ext2.o ../cdboot/mod/ext2.ko
    objcopy -O elf32-i386 ../bin/modules/iso9660.o ../cdboot/mod/iso9660.ko
    objcopy -O elf32-i386 ../bin/modules/ps2kbd.o ../cdboot/mod/ps2kbd.ko
    objcopy -O elf32-i386 ../bin/modules/ps2mouse.o ../cdboot/mod/ps2mouse.ko
    objcopy -O elf32-i386 ../bin/modules/lfbvideo.o ../cdboot/mod/lfbvideo.ko
    objcopy -O elf32-i386 ../bin/modules/packetfs.o ../cdboot/mod/packetfs.ko
    objcopy -O elf32-i386 ../bin/modules/pcspkr.o ../cdboot/mod/pcspkr.ko
    objcopy -O elf32-i386 ../bin/modules/portio.o ../cdboot/mod/portio.ko
    objcopy -O elf32-i386 ../bin/modules/tarfs.o ../cdboot/mod/tarfs.ko
    objcopy -O elf32-i386 ../bin/modules/vgadbg.o ../cdboot/mod/vgadbg.ko
    objcopy -O elf32-i386 ../bin/modules/vgalog.o ../cdboot/mod/vgalog.ko


if errorlevel 1 goto err_done
    
  cd ../bin
    del krnl32.exe
  cd ./kernel    
     ld  -T../../kernel/link.ld -M -Map ../mapfile.map  -shared -o ../krnl32.exe compiler.o _gdt.o _idt.o _irq.o _isr.o _task.o _tss.o _user.o gdt.o idt.o irq.o isr.o entry.o cmos.o fpu.o pci.o timer.o bitset.o  ringbuffer.o  pipe.o ramdisk.o tty.o unixpipe.o vfs.o alloc.o mem.o shm.o args.o elf.o kprintf.o lgcc.o logging.o multiboot.o tokenize.o ubsan.o symbol_table.o module.o panic.o process.o signal.o syscall.o system.o task.o version.o libc.o spin.o main.o -L../ -lm  -lc

rem ********************************************************************
 
echo              Build APPLICATIONS

cd ../../apps
:Bapp

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/init.o init.c  
    ld   -Tlink.ld   -nostdlib -nostdinc -o ../bin/apps/init.exe  ../bin/apps/init.o  -L../bin/ -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -c  -I../base/usr/include  -o ../bin/apps/hello.o hello.c  
    ld   -Tlink.ld  -nostdlib -nostdinc -o ../bin/apps/hello.exe  ../bin/apps/hello.o  -L../bin/ -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -c  -I../base/usr/include  -o ../bin/apps/getty.o getty.c  
    ld   -Tlink.ld   -nostdlib -nostdinc -o ../bin/apps/getty.exe  ../bin/apps/getty.o  -L../bin/ -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -std=c99 -m32 -Ofast -I../base/usr/include -c -o ../bin/apps/login.o login.c
    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -std=c99 -m32 -Ofast -I../base/usr/include -c -o ../bin/apps/auth.o ../lib/auth.c
    ld   -Tlink.ld -nostdlib -nostdinc -o ../bin/apps/login.exe  ../bin/apps/login.o ../bin/apps/auth.o  -L../bin/ -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../base/usr/include -c  -o ../bin/apps/sh.o sh.c
    ld   -Tlink.ld -nostdlib -nostdinc -o ../bin/apps/sh.exe  ../bin/apps/sh.o  -L../bin  -lm -lc

 rem   mingw32-make Makefile all

if errorlevel 1 goto err_done
rem goto done
rem ***********************************************************************


cd ../bin
 
    objcopy  -O elf32-i386 krnl32.exe ../cdboot/krnl32
    objcopy  -O elf32-i386 apps/init.exe ../cdboot/bin/init
    objcopy  -O elf32-i386 apps/hello.exe ../cdboot/bin/hello
    objcopy  -O elf32-i386 apps/getty.exe ../cdboot/bin/getty
    objcopy  -O elf32-i386 apps/login.exe ../cdboot/bin/login
    objcopy  -O elf32-i386 apps/sh.exe ../cdboot/bin/sh


if errorlevel 1 goto err_done
 
echo              Build Boot ISO CD
cd ../

:mkiso

 rem   mkisofs -R -b boot/isoboot.bin -no-emul-boot  -o learnos.iso  cdboot
    mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table   -o learnos.iso  cdboot


   D:/programas/oracle/virtualbox/vboxmanage startvm LearnOS

goto done

:err_done


echo DoneERR.
goto doneEx
:done
echo DoneOK.

:doneEx
pause
 

echo on

