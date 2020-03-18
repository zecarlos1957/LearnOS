/*
  $ @ File : io.h
  $ @ Decription : Contains the iPrototype of the io class
  */

#ifndef IO_INCLUDED
#define IO_INCLUDED

#include "system.h"

// @ Class Name : io
// @ Description : Defines io Handlers
class io
{
public:
  static void outb(u16int port , u8int value);
  static u8int inb(u16int port);
  static u16int inw(u16int port);
};

#endif
