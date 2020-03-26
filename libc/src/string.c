#include <string.h>
#include <stdio.h>
#include <stdint.h>

int __attribute__((__cdecl__)) memcmp(const void* aptr, const void* bptr, size_t size)
{
	const unsigned char* a = (const unsigned char*) aptr;
	const unsigned char* b = (const unsigned char*) bptr;
	for (size_t i = 0; i < size; i++)
    {
		if (a[i] < b[i])
			return -1;
		else if (b[i] < a[i])
			return 1;
	}
	return 0;
}

void* __attribute__((__cdecl__)) memcpy(void* restrict dstptr, const void* restrict srcptr, size_t size)
{
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;
	for (size_t i = 0; i < size; i++)
		dst[i] = src[i];
	return dstptr;
}

void* __attribute__((__cdecl__)) memmove(void* dstptr, const void* srcptr, size_t size)
{
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;
	if (dst < src)
    {
		for (size_t i = 0; i < size; i++)
			dst[i] = src[i];
	} else
    {
		for (size_t i = size; i != 0; i--)
			dst[i-1] = src[i-1];
	}
	return dstptr;
}

void* __attribute__((__cdecl__)) memset(void* bufptr, int value, size_t size)
{
	unsigned char* buf = (unsigned char*) bufptr;
	for (size_t i = 0; i < size; i++)
		buf[i] = (unsigned char) value;
	return bufptr;
}

size_t __attribute__((__cdecl__)) strlen(const char* str)
{
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

char* __attribute__((__cdecl__)) strrev(char *str)
{
      char *p1, *p2;

      if (! str || ! *str)
            return str;
      for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2)
      {
            *p1 ^= *p2;
            *p2 ^= *p1;
            *p1 ^= *p2;
      }
      return str;
}

char* __attribute__((__cdecl__)) strcpy(char *dst,const char *src)
{
    int i = 0;
    while(src[i])
    {
        dst[i] = src[i]; 
        i++; 
    }
    dst[i] = '\0';
    return dst;
}

char* __attribute__((__cdecl__)) strcat(char *s2,const char *s1)
{
    int i1 = 0;
    int i2 = 0;
    while(s2[i2])i2++;
    
    while(s1[i1])
    {
        s2[i2++] = s1[i1++]; 
    }
    s2[i2] = '\0';
    return s2;
    
}
