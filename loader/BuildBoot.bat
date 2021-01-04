@echo off




 

    nasm -fbin isoboot.asm -o ../cdboot/boot/isoboot.bin

    nasm -fwin entry.asm -o ./entry.o

    gcc   -ffreestanding -c  -o ./cstuff.o cstuff.c
    ld -Tlink.ld -o  ./setupldr.exe  ./entry.o ./cstuff.o 
    objcopy -O binary ./setupldr.exe ../cdboot/loader/setupldr.sys

 rem   mkisofs -R -b boot/grub/isoboot.bin -no-emul-boot -boot-load-size 4 -boot-info-table   -o ntldr.iso  cdboot


 rem   D:/programas/oracle/virtualbox/vboxmanage startvm NTLDR

rem echo DoneOK.

rem pause


echo on
