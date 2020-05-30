/* vim: tabstop=4 shiftwidth=4 noexpandtab
 * This file is part of ToaruOS and is released under the terms
 * of the NCSA / University of Illinois License - see LICENSE.md
 * Copyright (C) 2011~2018 K. Lange
 *
 * hello - Prints "Hello, world."
 */
//#include <stdio.h>
#include <syscall.h>

int _main(int argc, char * argv[]) {
	syscall_monitor_write("Hello, world.");
	return 0;
}
