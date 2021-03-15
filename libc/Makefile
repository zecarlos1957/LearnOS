
COBJS = assert/assert.o \
	ctype/_ctype.o \
	ctype/isalnum.o \
	ctype/isalpha.o \
	ctype/isascii.o \
	ctype/iscntrl.o \
	ctype/isdigit.o \
	ctype/isgraph.o \
	ctype/islower.o \
	ctype/isprint.o \
	ctype/ispunct.o \
	ctype/isspace.o \
	ctype/isupper.o \
	ctype/isxdigit.o \
	ctype/tolower.o \
	ctype/toupper.o \
	debug/debug.o \
	dirent/dir.o \
	dirent/mkdir.o \
	dlfcn/dlfcn.o \
	errno/errorno.o \
	iconv/iconv.o \
	ioctl/ioctl.o \
	libgen/basename.o \
	libgen/dirname.o \
	libintl/libintl.o \
	locale/localeconv.o \
	locale/setlocale.o \
	math/bad.o \
	math/math.o \
	poll/poll.o \
	pthread/pthread.o \
	pty/pty.o \
	pwd/pwd.o \
	sched/sched_yield.o \
	signal/kill.o \
	signal/raise.o \
	signal/signal.o \
	stdio/perror.o \
	stdio/printf.o \
	stdio/puts.o \
	stdio/remove.o \
	stdio/rename.o \
	stdio/scanf.o \
	stdio/stdio.o \
	stdio/tmpfile.o \
	stdio/tmpnam.o \
	stdlib/abort.o \
	stdlib/atexit.o \
	stdlib/atof.o \
	stdlib/bsearch.o \
	stdlib/div.o \
	stdlib/getenv.o \
	stdlib/labs.o \
	stdlib/malloc.o \
	stdlib/mbstowcs.o \
	stdlib/mktemp.o \
	stdlib/putenv.o \
	stdlib/qsort.o \
	stdlib/rand.o \
	stdlib/realpath.o \
	stdlib/setenv.o \
	stdlib/strtod.o \
	stdlib/strtoul.o \
	stdlib/system.o \
	string/memcpy.o \
	string/memmove.o \
	string/memset.o \
	string/str.o \
	string/strerror.o \
	string/strncmp.o \
	string/strncpy.o \
	string/strxfrm.o \
	strings/strcasecmp.o \
	sys/fswait.o \
	sys/mount.o \
	sys/network.o \
	sys/reboot.o \
	sys/shm.o \
	sys/sysfunc.o \
	sys/uname.o \
	sys/wait.o \
	time/clock.o \
	time/ctime.o \
	time/gettimeofday.o \
	time/localtime.o \
	time/strftime.o \
	time/time.o \
	unistd/access.o \
	unistd/alarm.o \
	unistd/chdir.o \
	unistd/chmod.o \
	unistd/chown.o \
	unistd/close.o \
	unistd/creat.o \
	unistd/dup2.o \
	unistd/execvp.o \
	unistd/exit.o \
	unistd/fcntl.o \
	unistd/fork.o \
	unistd/fstat.o \
	unistd/getcwd.o \
	unistd/getegid.o \
	unistd/getuid.o \
	unistd/getgid.o \
	unistd/getuid.o \
	unistd/getgid.o \
	unistd/getlogin.o \
	unistd/getopt.o \
	unistd/getopt_long.o \
	unistd/getpgrp.o \
	unistd/getpid.o \
	unistd/getuid.o \
	unistd/getwd.o \
	unistd/hostname.o \
	unistd/isatty.o \
	unistd/link.o \
	unistd/lseek.o \
	unistd/open.o \
	unistd/pipe.o \
	unistd/read.o \
	unistd/readlink.o \
	unistd/rmdir.o \
	unistd/sbrk.o \
	unistd/setpgid.o \
	unistd/setsid.o \
	unistd/setuid.o \
	unistd/sleep.o \
	unistd/stat.o \
	unistd/symlink.o \
	unistd/ttyname.o \
	unistd/umask.o \
	unistd/unlink.o \
	unistd/usleep.o \
	unistd/utime.o \
	unistd/write.o \
	wchar/wcscat.o \
	wchar/wcscmp.o \
	wchar/wcscpy.o \
	wchar/wcslen.o \
	wchar/wcsncpy.o \
	wchar/wcstok.o \
	wchar/wcwidth.o

AOBJS = setjmp.o  crti.o crtn.o crt0.o main.o 

CC = ccache gcc
LD = ccache ld
AR = ccache ar
AS = ccache as

WARNINGS = -Wall 
CFLAGS = $(WARNINGS) -ffreestanding -nostdlib -nostdinc -fno-builtin -D__toaru__   -I../base/usr/include -Ofast



../bin/libc.dll:  $(COBJS)  $(AOBJS)  
	$(CC) -nodefaultlibs -o $@ $(CFLAGS) -shared  $^

../bin/libc.a: $(COBJS)  $(AOBJS)
	$(AR) cr $@ $^




libk: CFLAGS += -D_KERNEL_  $(CFLAGS_EXTRA)
libk: $(COBJS)
	@$(AR) rcs ../bin/libk.a $+


%.o: %.c
	@$(CC) -c $(CFLAGS)  $< -o $@

%.o: %.S
	@$(AS)   $< -o $@

clean:
	@rm ./*/*.o
	@rm *.o
	@rm ../bin/libc.a
	@rm ../bin/libc.dll
