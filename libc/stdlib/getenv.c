#include <string.h>
#include <stdlib.h>

extern char ** environ;


char * getenv(const char *name) {
	char ** e = environ;
	if(!environ)return NULL; /// ERRROR falha _libc_init
	
	size_t len = strlen(name);
	while (*e) {
		char * t = *e;
		if (strstr(t, name) == *e) {
			if (t[len] == '=') {
				return &t[len+1];
			}
		}
		e++;
	}
	return NULL;
}
