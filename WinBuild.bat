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
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/common.o common.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/descriptor_tables.o descriptor_tables.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/fs.o fs.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/initrd.o initrd.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/isr.o isr.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/kheap.o kheap.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/main.o main.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/monitor.o monitor.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/ordered_array.o ordered_array.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/paging.o paging.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/syscall.o syscall.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/task.o task.c
    gcc -ffreestanding -fno-stack-protector -c -o ../bin/timer.o timer.c
    nasm -fwin32 boot.s -o ../bin/entry.o 
    nasm -fwin32 gdt.s -o ../bin/gdt.o
    nasm -fwin32 interrupt.s -o ../bin/interrupt.o
    nasm -fwin32 process.s -o ../bin/process.o

rem goto floppy    
cd ../bin
    ld -T../kernel/link.ld -o krnl32.exe entry.o gdt.o interrupt.o process.o isr.o common.o descriptor_tables.o fs.o initrd.o kheap.o main.o monitor.o ordered_array.o paging.o task.o timer.o syscall.o
    objcopy -O elf32-i386 krnl32.exe ../build/sys/krnl32.elf
   path  d:/tools

cd ../
    mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table   -o build/learnos.iso  build
 rem  mkisofs -R -b boot/grub/loader.bin -no-emul-boot -boot-load-size 4 -boot-info-table   -o mtask.iso  build


  d:/programas/oracle/virtualbox/vboxmanage startvm LearnOS
 
 
echo DoneOK.
 
pause


echo on 
