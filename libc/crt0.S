.global __start
.extern _main
.extern _pre_main

__start:   /* call from migrate.c */
  pop %eax
  push $_main
  call _pre_main

