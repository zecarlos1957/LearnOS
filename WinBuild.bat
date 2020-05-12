@echo off
echo Build script for Windows
echo.

cd ./cd_boot
rem     nasm -felf -o ../bin/boot.o start_eltorito.asm
rem     nasm -felf -o ../bin/asm.o asm.asm
rem      gcc -ffreestanding -nostdinc     -c cstuff.c -o ../bin/cstuff.o

rem  cd ../bin
rem echo Linking MiniLoader...
rem     ld -T../cd_boot/link.ld  -o loader.exe boot.o asm.o cstuff.o
rem     objcopy -O binary loader.exe ../build/boot/grub/loader.bin

cd ../kernel 
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/common.o common.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/descriptor_tables.o descriptor_tables.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/fs.o fs.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/initrd.o initrd.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/isr.o isr.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/kheap.o kheap.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/main.o main.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/monitor.o monitor.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/ordered_array.o ordered_array.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/paging.o paging.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/syscall.o syscall.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/task.o task.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/timer.o timer.c
    gcc -ffreestanding -D_BUILD_DLL_ -D_KERNEL_ -I../base/user/include -c -o ../bin/cpu.o cpu.c
    nasm -fwin32 boot.s -o ../bin/entry.o 
    nasm -fwin32 gdt.s -o ../bin/gdt.o
    nasm -fwin32 interrupt.s -o ../bin/interrupt.o
    nasm -fwin32 process.s -o ../bin/process.o

cd ../apps
    gcc -ffreestanding  -I../base/user/include     -c hello.c -o ../bin/hello.o 

cd ../bin
    ld -T../kernel/link.ld  -shared -o krnl32.exe entry.o gdt.o interrupt.o process.o isr.o cpu.o common.o descriptor_tables.o fs.o initrd.o kheap.o main.o monitor.o ordered_array.o paging.o task.o timer.o syscall.o
rem     gcc -T../kernel/link.ld -shared -o ../build/sys/krnl32.dll entry.o gdt.o interrupt.o process.o isr.o cpu.o common.o descriptor_tables.o fs.o initrd.o kheap.o  monitor.o ordered_array.o main.o paging.o task.o timer.o syscall.o -Wl,--out-implib,libkrnl32.a
    objcopy -O elf32-i386 krnl32.exe ../build/sys/krnl32.elf

rem static link
    gcc -nostdlib -o ../build/sys/hello.exe hello.o -L. -lkrnl32
    path  d:/tools


cd ../
    if exist build\learnos.iso del build\learnos.iso
    mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table   -o build/learnos.iso  build
rem  mkisofs -R -b boot/grub/loader.bin -no-emul-boot -boot-load-size 4 -boot-info-table   -o mtask.iso  build


   d:/programas/oracle/virtualbox/vboxmanage startvm LearnOS
rem    d:/programas/qemu/qemu-system-i386 -cdrom build/learnos.iso
rem    d:/programas/bochs-2.6.9/bochs

echo DoneOK.

pause


echo on
