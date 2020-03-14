
#ifndef LIBC_H
#define LIBC_H

#include <stdarg.h>

extern "C" {
	void 	itoa(char *buf, unsigned long int32_t n, int32_t base);
	
	void *	memset(char *dst,char src, int32_t n);
	void *	memcpy(char *dst, char *src, int32_t n);
	
	
	int32_t 	strlen(char *s);
	int32_t 	strcmp(const char *dst, char *src);
	int32_t 	strcpy(char *dst,const char *src);
	void 	strcat(void *dest,const void *src);
	char *	strncpy(char *destString, const char *sourceString,int32_t maxLength);
	int32_t 	strncmp( const char* s1, const char* s2, int32_t c );
}

#endif
