#pragma once
 
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void terminal_initialize(void);
void terminal_scroll(void);
void terminal_setcolor(uint8_t color);
void terminal_putchar(char c);
void terminal_write(const char* data, size_t size);
void terminal_writestring(const char* data);
void terminal_clear(void);
void terminal_setcursor(uint8_t x, uint8_t y);

#ifdef __cplusplus
}
#endif