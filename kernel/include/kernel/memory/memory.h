#pragma once

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
	uint8_t status;
	uint32_t size;
} alloc_t;

void mm_init(uint32_t kernel_end);
void mm_print_out();

///void paging_init();
///void paging_map_virtual_to_phys(uint32_t virt, uint32_t phys);

void m_free(void* mem);
char* m_alloc(size_t size);
void p_free(void* mem);	/* page aligned */
char* p_alloc(size_t size); 

#ifdef __cplusplus
}
#endif