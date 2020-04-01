#include <limits.h>
#include <stdbool.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
 
#if defined(KRNL_BUILD)
#include <modules/tty.h>
#endif

static bool print(const char* data, int length)
{
	const unsigned char* bytes = (const unsigned char*) data;
	int i ;
	for ( i = 0; i < length; i++)
		if (putchar(bytes[i]) == EOF)
			return false;
	return true;
}

int puts(const char* string)
{
	return printf("%s\n", string);
}
 
int putchar(int ic) {
#if defined(KRNL_BUILD)
	char c = (char) ic;
	terminal_write(&c, sizeof(c));
#else
	// TODO: Implement stdio and the write system call.
#endif
	return ic;
}

int printf(const char*  format, ...)
{
	int written = 0;
	va_list parameters;
	va_start(parameters, format);
 
 
	while (*format != '\0') {
		int maxrem = INT_MAX - written;
        const char* format_begun_at;
 
		if (format[0] != '%' || format[1] == '%')
        {
			if (format[0] == '%')
				format++;
			int amount = 1;

			while (format[amount] && format[amount] != '%')
				amount++;

			if (maxrem < amount)
            {
                _set_errno(EOVERFLOW);
				return -1;
			}

			if (!print(format, amount))
				return -1;
            
			format += amount;
			written += amount;
			continue;
		}
 
		 format_begun_at = format++;
 
		if (*format == 'd' || *format == 'i')
		{
			int val = (int)va_arg(parameters, int);
			char str[16];
			itoa(val, str, 10);
			int len = strlen(str);
			format++;

			if (maxrem < len)
            {
				_set_errno(EOVERFLOW);
				return -1;
			}

			if (!print(str, len))
				return -1;
			written += len;
		}
		else if(*format == 'x')
		{
			format++;
			int val = (int)va_arg(parameters, int);
			char str[16];
			itoa(val, str, 16);
			int len = strlen(str);

			if (maxrem < len)
            {
				_set_errno(EOVERFLOW);
				return -1;
			}

			if (!print(str, len))
				return -1;
			written += len;
		}
		else if (*format == 'c')
        {
			format++;
			char c = (char)va_arg(parameters, int);

			if (!maxrem)
            {
				_set_errno(EOVERFLOW);
				return -1;
			}

			if (!print(&c, sizeof(c)))
				return -1;

			written++;
		}
        else if (*format == 's')
        {
			format++;
			char* str = va_arg(parameters, char*);
			int len = strlen(str);

			if (maxrem < len)
            {
				_set_errno(EOVERFLOW);
				return -1;
			}

			if (!print(str, len))
				return -1;
			written += len;
		}
        else
        {
			format = format_begun_at;
			int len = strlen(format);

			if (maxrem < len)
            {
				_set_errno(EOVERFLOW);
				return -1;
			}

			if (!print(format, len))
				return -1;
                
			written += len;
			format += len;
		}
	}
 
	va_end(parameters);
	return written;
}
