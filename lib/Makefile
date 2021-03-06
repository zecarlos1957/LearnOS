

COBJS = auth.o \
	button.o \
	confreader.o \
	decor-fancy.o \
	decorations.o \
	graphics.o \
	icon_cache.o \
	jpeg.o \
	json.o \
	kbd.o \
	markup.o \
	menu.o \
	pex.o \
	rline.o \
	rline_exp.o \
	sdf.o \
	termemu.o \
	textregion.o \
	yutani.o 
#	hashmap.o \
#	list.o \
#	tree.o

CC = ccache gcc
LD = ccache ld
AR = ccache ar

WARNINGS = -Wall 
CFLAGS = $(WARNINGS) -nostdlib -nostdinc -fno-builtin -D_KERNEL_ -DNO_SSE -std=c99 -m32  -I../base/usr/include   -Ofast

libtoaru: ../bin/libtoaru.dll


../bin/libtoaru.dll:  $(COBJS)
	$(CC) -nodefaultlibs -o $@ $(CFLAGS) -shared  $^ ../bin/krnl32.exe  ../bin/libc.dll 


%.o: %.c
	@$(CC) -c $(CFLAGS) $< -o $@

../bin/libm.a: $(COBJS)
	@$(AR) rcs $@ $+

clean:
	@rm *.o
