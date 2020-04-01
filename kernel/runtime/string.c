#include <string.h>
#include <stdio.h>
#include <stdint.h>

int __attribute__((__cdecl__)) memcmp(const void* aptr, const void* bptr, int size)
{
    int i;
	const unsigned char* a = (const unsigned char*) aptr;
	const unsigned char* b = (const unsigned char*) bptr;
	for ( i = 0; i < size; i++)
    {
		if (a[i] < b[i])
			return -1;
		else if (b[i] < a[i])
			return 1;
	}
	return 0;
}

void* __attribute__((__cdecl__)) memcpy(void*  dstptr, const void* srcptr, int size)
{
    int i;
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;
	for (  i = 0; i < size; i++)
		dst[i] = src[i];
	return dstptr;
}

void* __attribute__((__cdecl__)) memmove(void* dstptr, const void* srcptr, int size)
{
    int i;
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;
	if (dst < src)
    {
		for (i = 0; i < size; i++)
			dst[i] = src[i];
	} else
    {
		for ( i = size; i != 0; i--)
			dst[i-1] = src[i-1];
	}
	return dstptr;
}

void* __attribute__((__cdecl__)) memset(void* bufptr, int value, int size)
{
    int i;
 	unsigned char* buf = (unsigned char*) bufptr;
	for ( i = 0; i < size; i++)
		buf[i] = (unsigned char) value;
	return bufptr;
}

int __attribute__((__cdecl__)) strlen(const char* str)
{
	int len = 0;
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