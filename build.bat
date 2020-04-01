@echo off
echo   assembling, compiling
if not exist ./bin mkdir bin

rem path = d:/programas/rosbe/i386/bin

echo Assembling loader...
    
cd ./loader
    nasm -f bin Boot.asm -o ../bin/Boot.bin
    nasm -f bin loader.asm -o ../bin/KRNLDR.SYS

echo Assembling kernel...
cd ../kernel/arch/x86 
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../ -I../../runtime -c -o ../../../bin/cpustat.o cpustat.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../ -I../../runtime -c -o ../../../bin/gdt.o gdt.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../ -I../../runtime -c -o ../../../bin/idt.o idt.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../ -I../../runtime -c -o ../../../bin/isr.o isr.c
    nasm -f win32 gdt.asm -o ../../../bin/_gdt.o
    nasm -f win32 interrupt.s -o ../../../bin/interrupt.o
    nasm -f win32 kernel.s -o ../../../bin/entry.o

cd ../../runtime   
    gcc -ffreestanding -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/cstd.o cstd.cpp
    gcc -ffreestanding -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/assert.o assert.c
    gcc -ffreestanding -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/ctype.o ctype.c
    gcc -ffreestanding -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/errno.o errno.c
    gcc -ffreestanding -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/stdio.o stdio.c
    gcc -ffreestanding -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/stdlib.o stdlib.c
    gcc -ffreestanding -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/string.o string.c
  
cd ../core
     gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/hal.o hal.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/irq.o irq.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/pic.o pic.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/pit.o pit.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/memory.o memory.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/paging.o paging.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/main.o main.cpp
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/panic.o panic.c
 
cd ../modules
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/fdc.o fdc.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/keyboard.o keyboard.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/ps2.o ps2.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/tty.o tty.c
    gcc -ffreestanding -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../ -I../runtime -c -o ../../bin/vga.o vga.c 
    
cd ../../bin 
    ar rsc libk.a fdc.o cpustat.o gdt.o idt.o isr.o hal.o irq.o pic.o pit.o    
    ar rsc libio.a  keyboard.o ps2.o tty.o vga.o  memory.o  paging.o 
    ar rsc libc.a panic.o  assert.o ctype.o errno.o stdio.o stdlib.o string.o 

 echo linking...
    ld -T ../kernel_linker.ld -o  krnl32.exe entry.o fdc.o cpustat.o gdt.o idt.o  isr.o hal.o irq.o pic.o pit.o  keyboard.o ps2.o tty.o vga.o memory.o  paging.o panic.o  main.o assert.o ctype.o errno.o stdio.o stdlib.o string.o cstd.o _gdt.o
rem    ld  -T ../kernel_linker.ld -o  krnl32.exe kernel.o main.o libk.a libio.a libc.a  cstd.o _gdt.o
    objcopy -O binary krnl32.exe krnl.sys 
    del *.o
cd ../

echo Cleaning up object files...
 

     path  d:/tools
    partcopy bin/boot.bin 0 200 learnos.img 0 

echo Mounting disk image...
    imdisk -a -f learnos.img -s 1440K -m B:
    copy  bin\KRNLDR.SYS B:\
    copy  bin\KRNL.SYS B:\

echo Dismount disk...
    imdisk -D -m B:
   d:/programas/oracle/virtualbox/vboxmanage startvm LearnOS
:done
echo Done.
echo on
pause
