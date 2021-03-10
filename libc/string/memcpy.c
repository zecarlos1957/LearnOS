#include <stddef.h>

void * memcpy(void * restrict dest, const void * restrict src, size_t n) {
	__asm__ __volatile__("cld; rep movsb"
	            : "=c"((int){0})
	            : "D"(dest), "S"(src), "c"(n)
	            : "flags", "memory");
	return dest;
}
