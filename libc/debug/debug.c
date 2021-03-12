
#include <syscall.h>
#include <syscall_nums.h>
#include <va_list.h>


DEFN_SYSCALL3(dbprint,  SYS_DBPRINT, const char *, int, const char *);

int dbprint(const char *title, int line, const char *fmt, ...)
{
	char buffer[1024];
	va_list args;
	va_start(args, fmt);
	vsprintf(buffer, fmt, args);
	va_end(args);
	return syscall_dbprint(title, line, buffer);
}

