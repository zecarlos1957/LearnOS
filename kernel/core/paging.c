#include <stdint.h>

#include <core/memory.h>

static uint32_t* page_directory = 0;
static uint32_t page_dir_loc = 0;
static uint32_t* last_page = 0;

/* Paging now will be really simple
 * we reserve 0-8MB for kernel stuff
 * heap will be from approx 1mb to 4mb
 * and paging stuff will be from 4mb
 */

void paging_map_virtual_to_phys(uint32_t virt, uint32_t phys)
{
    int i;
	uint16_t id = virt >> 22;
	for(i = 0; i < 1024; i++)
	{
		last_page[i] = phys | 3;
		phys += 4096;
	}
	page_directory[id] = ((uint32_t)last_page) | 3;
	last_page = (uint32_t *)(((uint32_t)last_page) + 4096);
}

void paging_enable()
{
    uint32_t cr0;
    asm volatile("mov %0, %%cr3":: "r"(page_dir_loc));
    asm volatile("mov %%cr0, %0": "=r"(cr0));
    cr0 |= 0x80000001; // Enable paging!
    asm volatile("mov %0, %%cr0":: "r"(cr0));
 /*   
    __asm__ __volatile__ ("mov %0, %%eax" : : "m"(page_dir_loc));
    __asm__ __volatile__ ("mov %cr3, %%eax");
    __asm__ __volatile__ ("mov %%eax, %cr0");
    __asm__ __volatile__ ("or %%eax, $0x80000001");
    __asm__ __volatile__ ("mov %cr0, %%eax");
*/
}

void paging_init()
{
    int i;
	page_directory = (uint32_t*)0x400000;
	page_dir_loc = (uint32_t)page_directory;
	last_page = (uint32_t *)0x404000;

	for(i = 0; i < 1024; i++)
		page_directory[i] = 0 | 2;

	paging_map_virtual_to_phys(0, 0);
	paging_map_virtual_to_phys(0x400000, 0x400000);
	paging_enable();
}
