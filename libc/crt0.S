.global __start
.extern __main
.extern _pre_main

__start:   /* call from migrate.c */
  pop %eax
  push $__main
  call _pre_main

