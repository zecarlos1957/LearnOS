
@echo off
echo Build script for Windows (Mingw32-gcc)
rem  For now we built the OS with a batch file.

echo Assembling bootloader...

if exist LearnOS.img del LearnOS.img

cd ./boot
    nasm -f bin Boot.asm -o ../build/Boot.bin
    nasm -f bin Stage2.asm -o ../build/KRNLDR.SYS

cd ../kernel   
    nasm -f win stage3.asm -o ../build/stage3.o 
    gcc  -fno-builtin -ffreestanding  -I include -c main.cpp -o ../build/main.o


cd ../build
echo linking...

     ld  -mi386pe  -T../kernel/x86/link.ld  -nostdlib -nostdinc -o krnl32.exe  stage3.o main.o
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
