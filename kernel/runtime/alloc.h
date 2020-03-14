
#ifndef ALLOC_H
#define ALLOC_H


extern "C" {
	void *ksbrk(int32_t);
	void *kmalloc(unsigned long);
	void kfree(void *);
}

#endif
