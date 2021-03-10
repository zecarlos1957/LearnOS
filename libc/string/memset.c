#include <stddef.h>

void * memset(void * dest, int c, size_t n) {
	__asm__ __volatile__("cld; rep stosb"
	             : "=c"((int){0})
	             : "D"(dest), "a"(c), "c"(n)
	             : "flags", "memory");
	return dest;
}

