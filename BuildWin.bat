
@echo off
echo Build script for Windows (Mingw32-gcc)
rem  For now we built the OS with a batch file.

echo Assembling bootloader...

if exist LearnOS.img del LearnOS.img

cd ./boot
    nasm -f bin Boot.asm -o ../build/Boot.bin
    nasm -f bin Stage2.asm -o ../build/KRNLDR.SYS

cd ../kernel/arch
    nasm -f win entry.asm -o ../../build/entry.o 
    nasm -f win gdt.asm -o ../../build/_gdt.o 
    nasm -f win idt.asm -o ../../build/_idt.o 
    nasm -f win interrupt.asm -o ../../build/interrupt.o 
    
cd ../core
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c io.cpp -o ../../build/io.o
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c gdt.cpp -o ../../build/gdt.o
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c idt.cpp -o ../../build/idt.o
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c isr.cpp -o ../../build/isr.o
 
cd ../modules
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c timer.cpp -o ../../build/timer.o
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c memory.cpp -o ../../build/memory.o
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c common.cpp -o ../../build/common.o
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c display.cpp -o ../../build/display.o
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ../include -c keyboard.cpp -o ../../build/keyboard.o
    
cd ../
    gcc  -fno-builtin -nostdlib -nostdinc -ffreestanding  -I ./include -c main.cpp -o ../build/main.o
    
cd ../build
echo linking...
    ar rsc libcore.a _gdt.o _idt.o interrupt.o gdt.o idt.o isr.o io.o common.o display.o keyboard.o memory.o timer.o
    ld  -mi386pe  -T../kernel/arch/link.ld  -nostdlib -nostdinc -o krnl32.exe  entry.o main.o libcore.a 
    objcopy -O binary krnl32.exe krnl32.sys

cd ../
    path  d:/tools
    partcopy build/boot.bin 0 200 LearnOS.img 0 

echo Mounting disk image...
 
    imdisk -a -f LearnOS.img -s 1440K -m B:
    copy build\KRNLDR.SYS B:\
    copy build\KRNL32.SYS B:\

rem echo Dismount disk...
    imdisk -D -m B:
    d:/programas/oracle/virtualbox/vboxmanage startvm LearnOS
rem echo Done.
 
echo on
pause
