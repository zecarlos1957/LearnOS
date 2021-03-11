# auth.o \
#	button.o \
#	confreader.o \
#	decor-fancy.o \
#	decorations.o \
#	graphics.o \
#	icon_cache.o \
#	jpeg.o \
#	json.o \
#	kbd.o \
#	markup.o \
#	menu.o \
#	pex.o \
#	rline.o \
#	rline_exp.o \
#	sdf.o \
#	termemu.o \
#	textregion.o \
#	yutani.o \
#	hashmap.o \
#	list.o \
#	tree.o



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
	yutani.o \
	hashmap.o \
	list.o \
	tree.o \
	main.o

CC = ccache gcc
LD = ccache ld
AR = ccache ar

WARNINGS = -Wall 
CFLAGS = $(WARNINGS) -nostdlib -nostdinc -fno-builtin  -DNO_SSE  -m32  -I../base/usr/include   -Ofast

toaru: ../bin/toaru.dll


../bin/toaru.dll:  $(COBJS)
	$(CC) -nodefaultlibs -o $@ $(CFLAGS) -shared  $^  -L../bin -lc


%.o: %.c
	@$(CC) -c $(CFLAGS) $< -o $@

../bin/libm.a: $(COBJS)
	@$(AR) rcs $@ $+ 

clean:
	@rm *.o
	@rm ../bin/libm.a
	@rm ../bin/libm.dll
