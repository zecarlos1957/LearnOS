#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define PORTWAIT_PORT 0x80
 
static inline __attribute__((__always_inline__)) void outportb(uint16_t portid, uint8_t value)
{
    __asm__ __volatile__ ("outb %1, %0" : : "dN" (portid), "a" (value));
}
 
static inline __attribute__((__always_inline__)) void outportw(uint16_t port, uint16_t value)
{
	__asm__ __volatile__ ("outw %1, %0" : : "dN" (port), "a" (value));
}
 
static inline __attribute__((__always_inline__)) void outportl(uint16_t port, uint32_t value)
{	
    __asm__ __volatile__  ("outl %1, %0" : : "a"(value), "dN" (port));
}
 
static inline __attribute__((__always_inline__)) uint8_t inportb(uint16_t portid)
{
    uint8_t rv;
    __asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (portid));
	return rv;
}
 
static inline __attribute__((__always_inline__)) uint16_t inportw(uint16_t portid)
{
    uint16_t rv;
	__asm__ __volatile__ ("inw %1, %0" : "=a" (rv) : "dN" (portid));
	return rv;
}

static inline __attribute__((__always_inline__)) uint32_t inportl(uint16_t portid)
{
    uint32_t rv;
	asm volatile ("inl %%dx, %%eax" : "=a" (rv) : "dN" (portid));
//	__asm__ __volatile__ ("inl %0, %1" : "=a"(rv) : "dN"(portid));
	return rv;
}
  
static inline __attribute__((__always_inline__)) void portwait(void)
{
    asm volatile( "outb %%al, $0x80" : : "a"(0) );
}
 
#ifdef __cplusplus
}
#endif