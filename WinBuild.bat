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
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/gdt.o gdt.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/idt.o idt.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/irq.o irq.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/isr.o isr.c
    
    if errorlevel 1 goto err_done

cd ../devices
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/cmos.o cmos.c    
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/fpu.o fpu.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/pci.o pci.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/timer.o timer.c
    
    if errorlevel 1 goto err_done

cd ../ds
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/bitset.o bitset.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ringbuffer.o ringbuffer.c
cd ../fs
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/pipe.o pipe.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ramdisk.o ramdisk.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/tty.o tty.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/unixpipe.o unixpipe.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/vfs.o vfs.c
    
    if errorlevel 1 goto err_done

cd ../mem
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/alloc.o alloc.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/mem.o mem.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/shm.o shm.c
    
    if errorlevel 1 goto err_done

cd ../misc
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/args.o args.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/elf.o elf.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/kprintf.o kprintf.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/lgcc.o lgcc.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/logging.o logging.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/multiboot.o multiboot.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/tokenize.o tokenize.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/ubsan.o ubsan.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/symbol_table.o symbol_table.c 
    
    if errorlevel 1 goto err_done

cd ../sys
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/module.o module.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/panic.o panic.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/process.o process.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/signal.o signal.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/syscall.o syscall.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/system.o system.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/task.o task.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../../base/usr/include -c -o ../../bin/kernel/version.o version.c
    
    if errorlevel 1 goto err_done

cd ../
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/libc.o libc.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/spin.o spin.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../base/usr/include -c -o ../bin/kernel/main.o main.c
    
    if errorlevel 1 goto err_done


    as entry.s -o ../bin/kernel/entry.o 
    as gdt.s -o ../bin/kernel/_gdt.o
    as idt.s -o ../bin/kernel/_idt.o
    as irq.s -o ../bin/kernel/_irq.o
    as isr.s -o ../bin/kernel/_isr.o
    as task.s -o ../bin/kernel/_task.o
    as tss.s -o ../bin/kernel/_tss.o
    as user.s -o ../bin/kernel/_user.o

cd ../util
 rem   gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../base/usr/include -c -o ../bin/lm.o lm.c
 rem   gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../base/usr/include -c -o ../bin/netinit.o netinit.c
 rem   gcc -ffreestanding -nostdlib -nostdinc -fno-builtin  -D_KERNEL_ -I../base/usr/include -c -o ../bin/ungz.o ungz.c
    as compiler-rt.s -o ../bin/kernel/compiler.o
   
if errorlevel 1 goto err_done

rem ********************************************************************


rem            Build LIBC
 cd ../libc
 rem    mingw32-make Makefile clean
    mingw32-make Makefile ../bin/libc.a
 rem   mingw32-make Makefile ../bin/libc.dll
 rem  call BuildLibC
   
 cd ../lib
 rem   mingw32-make Makefile clean
    mingw32-make Makefile ../bin/libm.a
 rem   mingw32-make Makefile toaru


echo              Build MODULES
    
  
    
cd ../modules
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/zero.o zero.c 
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/hda.o hda.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/snd.o snd.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/random.o random.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/serial.o serial.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/debug_sh.o debug_sh.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/procfs.o procfs.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/tmpfs.o tmpfs.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ata.o ata.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ext2.o ext2.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/iso9660.o iso9660.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ps2kbd.o ps2kbd.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/ps2mouse.o ps2mouse.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/lfbvideo.o lfbvideo.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vbox.o vbox.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vgadbg.o vgadbg.c 
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vgalog.o vgalog.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/vidset.o vidset.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/packetfs.o packetfs.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/pcspkr.o pcspkr.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/portio.o portio.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/tarfs.o tarfs.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/xtest.o xtest.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/dospart.o dospart.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/e1000.o e1000.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -I../base/usr/include -c -o ../bin/modules/rtl.o rtl.c

if errorlevel 1 goto err_done

     objcopy -O elf32-i386 ../bin/modules/zero.o ../base/mod/zero.ko
     objcopy -O elf32-i386 ../bin/modules/random.o ../base/mod/random.ko
     objcopy -O elf32-i386 ../bin/modules/serial.o ../base/mod/serial.ko
     objcopy -O elf32-i386 ../bin/modules/debug_sh.o ../base/mod/debug_sh.ko
     objcopy -O elf32-i386 ../bin/modules/procfs.o ../base/mod/procfs.ko
     objcopy -O elf32-i386 ../bin/modules/tmpfs.o ../base/mod/tmpfs.ko
     objcopy -O elf32-i386 ../bin/modules/ata.o ../base/mod/ata.ko
     objcopy -O elf32-i386 ../bin/modules/ext2.o ../base/mod/ext2.ko
     objcopy -O elf32-i386 ../bin/modules/iso9660.o ../base/mod/iso9660.ko
     objcopy -O elf32-i386 ../bin/modules/ps2kbd.o ../base/mod/ps2kbd.ko
     objcopy -O elf32-i386 ../bin/modules/ps2mouse.o ../base/mod/ps2mouse.ko
     objcopy -O elf32-i386 ../bin/modules/lfbvideo.o ../base/mod/lfbvideo.ko
     objcopy -O elf32-i386 ../bin/modules/packetfs.o ../base/mod/packetfs.ko
     objcopy -O elf32-i386 ../bin/modules/pcspkr.o ../base/mod/pcspkr.ko
     objcopy -O elf32-i386 ../bin/modules/portio.o ../base/mod/portio.ko
     objcopy -O elf32-i386 ../bin/modules/tarfs.o ../base/mod/tarfs.ko
     objcopy -O elf32-i386 ../bin/modules/vgadbg.o ../base/mod/vgadbg.ko
     objcopy -O elf32-i386 ../bin/modules/vgalog.o ../base/mod/vgalog.ko
     objcopy -O elf32-i386 ../bin/modules/hda.o ../base/mod/hda.ko
     objcopy -O elf32-i386 ../bin/modules/snd.o ../base/mod/snd.ko
     objcopy -O elf32-i386 ../bin/modules/dospart.o ../base/mod/dospart.ko
     objcopy -O elf32-i386 ../bin/modules/e1000.o ../base/mod/e1000.ko
     objcopy -O elf32-i386 ../bin/modules/rtl.o ../base/mod/rtl.ko
     objcopy -O elf32-i386 ../bin/modules/vbox.o ../base/mod/vbox.ko
     objcopy -O elf32-i386 ../bin/modules/vidset.o ../base/mod/vidset.ko
     objcopy -O elf32-i386 ../bin/modules/xtest.o ../base/mod/xtest.ko

 rem   objcopy -O elf32-i386 ../bin/toaru.dll ../base/bin/toaru.so
rem    objcopy -O elf32-i386 ../bin/libc.dll ../base/bin/libc.so


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
    ld   -Tlink2.ld   -nostdlib -nostdinc -o ../bin/apps/init.exe  ../bin/apps/init.o  -L../bin/ -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/hello.o hello.c  
    ld   -Tlink2.ld  -nostdlib -nostdinc -o ../bin/apps/hello.exe  ../bin/apps/hello.o  -L../bin/ -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/getty.o getty.c  
    ld   -Tlink2.ld   -nostdlib -nostdinc -o ../bin/apps/getty.exe  ../bin/apps/getty.o  -L../bin/ -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -Ofast -I../base/usr/include -c -o ../bin/apps/login.o login.c
    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -Ofast -I../base/usr/include -c -o ../bin/apps/auth.o ../lib/auth.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/login.exe  ../bin/apps/login.o ../bin/apps/auth.o  -L../bin/ -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/sh.o sh.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/sh.exe  ../bin/apps/sh.o  -L../bin  -lm -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin  -m32 -Ofast -c  -I../base/usr/include  -o ../bin/apps/stty.o stty.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/stty.exe  ../bin/apps/stty.o  -L../bin  -lc

    gcc  -ffreestanding -nostdlib -nostdinc -fno-builtin  -m32 -Ofast -c  -I../base/usr/include  -o ../bin/apps/ttysize.o ttysize.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/ttysize.exe  ../bin/apps/ttysize.o  -L../bin  -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/stat.o stat.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/stat.exe  ../bin/apps/stat.o  -L../bin   -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/uname.o uname.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/uname.exe  ../bin/apps/uname.o  -L../bin   -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/migrate.o migrate.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/migrate.exe  ../bin/apps/migrate.o  -L../bin  -lm -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/mkdir.o mkdir.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/mkdir.exe  ../bin/apps/mkdir.o  -L../bin   -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/mount.o mount.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/mount.exe  ../bin/apps/mount.o  -L../bin   -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/crc32.o crc32.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/crc32.exe  ../bin/apps/crc32.o  -L../bin   -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/cat.o cat.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/cat.exe  ../bin/apps/cat.o  -L../bin   -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/terminal.o terminal.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/terminal.exe  ../bin/apps/terminal.o  -L../bin  -lm -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/terminal-vga.o terminal-vga.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/terminal-vga.exe  ../bin/apps/terminal-vga.o  -L../bin -lm  -lc

    gcc   -ffreestanding -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/compositor.o compositor.c
    ld   -Tlink2.ld -nostdlib -nostdinc -o ../bin/apps/compositor.exe  ../bin/apps/compositor.o  -L../bin -lm  -lc



    gcc  -ffreestanding  -nostdlib -nostdinc -fno-builtin -m32 -c  -I../base/usr/include  -o ../bin/apps/linker.o ../linker/linker.c
    ld   -T../linker/link.ld -nostdlib -nostdinc -shared -o ../bin/apps/linker.dll  ../bin/apps/linker.o  -L../bin  -lm -lc


 rem   mingw32-make Makefile all

if errorlevel 1 goto err_done
rem goto done
rem ***********************************************************************


cd ../bin
 
    objcopy  -O elf32-i386 apps/linker.dll ../base/usr/lib/ld.so

    objcopy  -O elf32-i386 apps/ttysize.exe ../base/usr/bin/ttysize
    objcopy  -O elf32-i386 apps/stat.exe ../base/usr/bin/stat
    objcopy  -O elf32-i386 apps/uname.exe ../base/usr/bin/uname
    objcopy  -O elf32-i386 apps/migrate.exe ../base/usr/bin/migrate
    objcopy  -O elf32-i386 apps/mkdir.exe ../base/usr/bin/mkdir
    objcopy  -O elf32-i386 apps/mount.exe ../base/usr/bin/mount
    objcopy  -O elf32-i386 apps/uname.exe ../base/usr/bin/uname
    objcopy  -O elf32-i386 apps/crc32.exe ../base/usr/bin/crc32
    objcopy  -O elf32-i386 apps/cat.exe ../base/usr/bin/cat

    objcopy  -O elf32-i386 krnl32.exe ../base/krnl32
    objcopy  -O elf32-i386 apps/init.exe ../base/bin/init
    objcopy  -O elf32-i386 apps/hello.exe ../base/bin/hello
    objcopy  -O elf32-i386 apps/getty.exe ../base/bin/getty
    objcopy  -O elf32-i386 apps/login.exe ../base/bin/login
    objcopy  -O elf32-i386 apps/sh.exe ../base/bin/sh
    objcopy  -O elf32-i386 apps/stty.exe ../base/bin/stty
    objcopy  -O elf32-i386 apps/terminal.exe ../base/bin/terminal
    objcopy  -O elf32-i386 apps/terminal-vga.exe ../base/bin/terminal-vga
    objcopy  -O elf32-i386 apps/compositor.exe ../base/bin/compositor

if errorlevel 1 goto err_done
 
echo              Build Boot ISO CD
cd ../

:mkiso

 rem   mkisofs -R -b boot/isoboot.bin -no-emul-boot  -o learnos.iso  base
    mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table   -o learnos.iso  base


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

