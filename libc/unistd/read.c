#include <unistd.h>
#include <errno.h>
#include <syscall.h>
#include <syscall_nums.h>

DEFN_SYSCALL3(read,  SYS_READ, int, char *, int);
DEFN_SYSCALL3(dbprint,  SYS_DBPRINT, const char *, int, const char *);

int read(int file, void *ptr, size_t len) {
	__sets_errno(syscall_read(file,ptr,len));
}

int dbprint(const char *title, int line, const char *msg)
{
	return syscall_dbprint(title, line, msg);

}