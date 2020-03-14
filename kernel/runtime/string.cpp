
#include <os.h>



extern "C"
{
	int32_t strlen(char *s)
	{
		int32_t i = 0;
		while (*s++)
			i++;
		return i;
	}
	
	char *strncpy(char *destString, const char *sourceString,int32_t maxLength)
	{
	  unsigned count;

	  if ((destString == (char *) NULL) || (sourceString == (char *) NULL))
		{
		  return (destString = NULL);
		}

	  if (maxLength > 255)
		maxLength = 255;

	  for (count = 0; (int32_t)count < (int32_t)maxLength; count ++)
		{
		  destString[count] = sourceString[count];
		  
		  if (sourceString[count] == '\0')
		break;
		}

	  if (count >= 255)
		{
		  return (destString = NULL);
		}

	  return (destString);
	}
	
	int32_t strcmp(const char *dst, char *src)
	{
		int32_t i = 0;

		while ((dst[i] == src[i])) {
			if (src[i++] == 0)
				return 0;
		}

		return 1;
	}
	

	int32_t strcpy(char *dst,const char *src)
	{
		int32_t i = 0;
		while ((dst[i] = src[i++]));

		return i;
	}
	

	void strcat(void *dest,const void *src)
	{
	   memcpy((char*)((int32_t)dest+(int32_t)strlen((char*)dest)),(char*)src,strlen((char*)src));
	}
	

	int32_t strncmp( const char* s1, const char* s2, int32_t c ) {
		int32_t result = 0;

		while ( c ) {
			result = *s1 - *s2++;

			if ( ( result != 0 ) || ( *s1++ == 0 ) ) {
				break;
			}

			c--;
		}

		return result;
	}
}

