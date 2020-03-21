@echo off
echo   assembling, compiling
if not exist ./bin mkdir bin

echo Assembling loader...
cd ./loader
    nasm -f bin stage1.asm -o ../bin/Boot.bin
    nasm -f bin stage2.asm -o ../bin/KRNLDR.SYS

echo Assembling kernel...
cd ../libcpp/src   
    g++ -c -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../libc/include -I../../kernel/include -I../../kb_layouts -c -o ../../bin/cstd.o cstd.cpp
 
cd ../../libc/src 
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../include -I../../kernel/include -I../../kb_layouts -c -o ../../bin/assert.o assert.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../include -I../../kernel/include -I../../kb_layouts -c -o ../../bin/ctype.o ctype.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../include -I../../kernel/include -I../../kb_layouts -c -o ../../bin/errno.o errno.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../include -I../../kernel/include -I../../kb_layouts -c -o ../../bin/stdio.o stdio.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../include -I../../kernel/include -I../../kb_layouts -c -o ../../bin/stdlib.o stdlib.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../include -I../../kernel/include -I../../kb_layouts -c -o ../../bin/string.o string.c

cd ../../kernel/libk/disk
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I ../../../kb_layouts -c -o ../../../bin/fdc.o fdc.c

cd ../hal/cpu 
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../../libc/include -I../../../include -I ../../../../kb_layouts -c -o ../../../../bin/cpustat.o cpustat.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../../libc/include -I../../../include -I ../../../../kb_layouts -c -o ../../../../bin/gdt.o gdt.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../../libc/include -I../../../include -I ../../../../kb_layouts -c -o ../../../../bin/idt.o idt.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../../libc/include -I../../../include -I ../../../../kb_layouts -c -o ../../../../bin/isr.o isr.c
    nasm -f win32 gdt.asm -o ../../../../bin/_gdt.o
  
cd ../
     gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/hal.o hal.c
     gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/irq.o irq.c
     gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/pic.o pic.c
     gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/pit.o pit.c
 
cd ../io
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/keyboard.o keyboard.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/ps2.o ps2.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/tty.o tty.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/vga.o vga.c
 
cd ../memory
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/memory.o memory.c
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../../libc/include -I../../include -I../../../kb_layouts -c -o ../../../bin/paging.o paging.c
 
cd ../
    gcc -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../../libc/include -I../include -I../../kb_layouts -c -o ../../bin/panic.o panic.c
 
cd ../
    g++ -ffreestanding -Wall -Wextra -m32 -nostdlib -lgcc  -fno-builtin -nostdinc -D ARCH_I386 -D KRNL_BUILD -I../libc/include -Iinclude -I../kb_layouts -c -o ../bin/main.o main.cpp
    nasm -f win32 kernel.s -o ../bin/kernel.o
    
cd ../bin 
    ar rsc libc.a assert.o ctype.o errno.o stdio.o stdlib.o string.o cstd.o
    ar rsc libcpu.a  gdt.o idt.o _gdt.o hal.o irq.o pit.o pic.o isr.o cpustat.o 
    ar rsc libio.a  keyboard.o ps2.o tty.o vga.o memory.o panic.o paging.o fdc.o   

echo linking kernel...
    ld  -T ../kernel_linker.ld -o  krnl32.exe kernel.o main.o libc.a libcpu.a libio.a
    objcopy -O binary krnl32.exe krnl.sys 
    del *.o
cd ../

echo Build floppy image...
 

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