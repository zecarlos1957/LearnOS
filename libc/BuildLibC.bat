echo             Compiling LIBC

cd ./assert
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/assert.o assert.c
cd ../ctype
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/_ctype.o _ctype.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isalnum.o isalnum.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isalpha.o isalpha.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isacii.o isascii.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/iscnctrl.o iscntrl.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isdigit.o isdigit.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isgraph.o isgraph.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/islower.o islower.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isprint.o isprint.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/ispunct.o ispunct.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isspace.o isspace.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isupper.o isupper.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isxdigit.o isxdigit.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/tolower.o tolower.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/toupper.o toupper.c
cd ../dirent
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/dir.o dir.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/mkdir.o mkdir.c
cd ../dlfcn
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/dlfcn.o dlfcn.c
cd ../errno
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/errorno.o errorno.c
cd ../iconv
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/iconv.o iconv.c
cd ../ioctl
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/ioctl.o ioctl.c
cd ../libgen
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/basename.o basename.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/dirname.o dirname.c
cd ../libintl
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/libintl.o libintl.c
cd ../locale
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/localeconv.o localeconv.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/setlocale.o setlocale.c
cd ../math
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/bad.o bad.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/math.o math.c
cd ../poll
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/poll.o poll.c
cd ../pthread
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/pthread.o pthread.c
cd ../pty
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/pty.o pty.c
cd ../pwd
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/pwd.o pwd.c
cd ../sched
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/sched_yield.o sched_yield.c
cd ../signal

    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/kill.o kill.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/raise.o raise.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/signal.o signal.c
cd ../stdio
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/perror.o perror.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/printf.o printf.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/puts.o puts.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/remove.o remove.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/rename.o rename.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/scanf.o scanf.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/stdio.o stdio.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/tmpfile.o tmpfile.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/tmpnam.o tmpnam.c
cd ../stdlib
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/abort.o abort.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/atexit.o atexit.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/atof.o atof.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/bsearch.o bsearch.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/div.o div.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getenv.o getenv.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/labs.o labs.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/malloc.o malloc.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/mbstowcs.o mbstowcs.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/mktemp.o mktemp.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/putenv.o putenv.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/qsort.o qsort.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/rand.o rand.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/realpath.o realpath.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/setenv.o setenv.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/strtod.o strtod.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/strtoul.o strtoul.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/system.o system.c
cd ../string
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/memcpy.o memcpy.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/memmove.o memmove.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/memset.o memset.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/str.o str.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/strerror.o strerror.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/strncmp.o strncmp.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/strncpy.o strncpy.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/strxfrm.o strxfrm.c
cd ../strings
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/strcasecmp.o strcasecmp.c
cd ../sys
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/fswait.o fswait.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/mount.o mount.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/reboot.o reboot.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/shm.o shm.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/sysfunc.o sysfunc.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/uname.o uname.c
rem    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/network.o network.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/wait.o wait.c
cd ../time
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/clock.o clock.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/ctime.o ctime.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/gettimeofday.o gettimeofday.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/localtime.o localtime.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/strftime.o strftime.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/time.o time.c
cd ../unistd
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/access.o access.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/alarm.o alarm.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/chdir.o chdir.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/chmod.o chmod.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/chown.o chown.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/close.o close.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/creat.o creat.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/dup2.o dup2.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/execvp.o execvp.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/exit.o exit.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/fcntl.o fcntl.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/fork.o fork.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/fstat.o fstat.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getcwd.o getcwd.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getegid.o getegid.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/geteuid.o geteuid.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getlogin.o getlogin.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getopt.o getopt.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getopt_long.o getopt_long.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getpgrp.o getpgrp.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getpid.o getpid.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getuid.o getuid.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/getwd.o getwd.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/hostname.o hostname.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/isatty.o isatty.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/link.o link.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/lseek.o lseek.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/open.o open.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/pipe.o pipe.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/read.o read.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/readlink.o readlink.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/rmdir.o rmdir.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/sbrk.o sbrk.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/setpgid.o setpgid.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/setsid.o setsid.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/setuid.o setuid.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/sleep.o sleep.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/stat.o stat.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/symlink.o symlink.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/ttyname.o ttyname.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/umask.o umask.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/unlink.o unlink.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/usleep.o usleep.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/utime.o utime.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/write.o write.c
cd ../wchar
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/wcscat.o wcscat.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/wcscmp.o wcscmp.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/wcscpy.o wcscpy.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/wcslen.o wcslen.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/wcsncpy.o wcsncpy.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/wcstok.o wcstok.c
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../../base/usr/include -c -o ../../bin/libc/wcwidth.o wcwidth.c
cd ../
    gcc -ffreestanding -nostdlib -nostdinc -fno-builtin   -I../base/usr/include -c -o ../bin/libc/main.o main.c
    as crt0.s -o ../bin/libc/crt0.o 
    as crti.s -o ../bin/libc/crti.o 
    as crtn.s -o ../bin/libc/crtn.o 
    as setjmp.s -o ../bin/libc/setjmp.o 


rem ********************************************************************
 echo             Link shared LIBC 

 cd ../bin/libc
    for %%f in (*.o) do ar rcs ../libc.a %%f
  rem      for %%f in (*.o) do gcc -ffreestanding -nostdlib -nostdinc -fno-builtin -nostdlib -nostdinc -shared -o  ../liblibc.so %%f
 cd ../
