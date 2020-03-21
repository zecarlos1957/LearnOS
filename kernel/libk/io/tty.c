#include <stdbool.h>
#include <string.h>
#include <kernel/io/ports.h>
#include <kernel/io/vga.h>

#include <kernel/io/tty.h>

static uint8_t VGA_WIDTH = 80;
static uint8_t VGA_HEIGHT = 25;
static uint16_t* VGA_MEMORY = (uint16_t*)0xB8000;

static uint8_t cursor_x;
static uint8_t cursor_y;
static uint8_t terminal_color;

static void update_cursor(void)
{
	uint32_t pos = cursor_y * VGA_WIDTH + cursor_x;

	outportb(0x3D4, 14);
	outportb(0x3D5, pos >> 8);
	outportb(0x3D4, 15);
	outportb(0x3D5, pos);
}

void terminal_initialize(void)
{
	cursor_y = 0;
	cursor_x = 0;
	terminal_color = vga_entry_color(VGA_COLOR_WHITE, VGA_COLOR_BLACK);

	terminal_clear();
	update_cursor();
}

void terminal_scroll(void)
{
	for(uint16_t i = 0; i < VGA_WIDTH * (VGA_HEIGHT - 1); i++)
		VGA_MEMORY[i] = VGA_MEMORY[i + VGA_WIDTH];
	
	for(uint8_t i = 0; i < VGA_WIDTH; i++)
		VGA_MEMORY[(VGA_HEIGHT - 1) * VGA_WIDTH + i] = 0;

	cursor_y--;

	update_cursor();
}

void terminal_setcolor(uint8_t color)
{
	terminal_color = color;
}

void terminal_putentryat(unsigned char c, uint8_t color, uint8_t x, uint8_t y)
{
	uint32_t index = y * VGA_WIDTH + x;
	VGA_MEMORY[index] = vga_entry(c, color);
}
 
void terminal_putchar(char c)
{
	switch(c)
	{
		case '\b':
			cursor_x--;
			terminal_putchar(' ');
			cursor_x -= 2;
			break;

		case '\n':
			cursor_y++;
			cursor_x = -1;
			break;

		case '\r':
			cursor_x = -1;
			break;

		case '\t':
			cursor_x += 4;
			break;

		default:
			terminal_putentryat((unsigned char)c, terminal_color, cursor_x, cursor_y);
	}

	if (++cursor_x == VGA_WIDTH)
    {
		cursor_x = 0;
		cursor_y++;
	}

	if(cursor_y == VGA_HEIGHT)
		terminal_scroll();

	update_cursor();
}
 
void terminal_write(const char* data, size_t size)
{
	for (size_t i = 0; i < size; i++)
		terminal_putchar(data[i]);
}
 
void terminal_writestring(const char* data)
{
	terminal_write(data, strlen(data));
}

void terminal_clear(void)
{
	for (uint8_t x = 0; x < VGA_WIDTH; x++)
    {
	    for (uint8_t y = 0; y < VGA_HEIGHT; y++)
        {
			uint32_t index = y * VGA_WIDTH + x;
			VGA_MEMORY[index] = vga_entry(' ', terminal_color);
		}
	}

	cursor_y = 0;
	cursor_x = 0;
	
	update_cursor();
}

void terminal_setcursor(uint8_t x, uint8_t y)
{
	cursor_y = y;
	cursor_x = x;
	update_cursor();
}