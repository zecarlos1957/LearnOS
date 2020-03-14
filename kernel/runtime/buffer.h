
#ifndef BUFFER_H
#define BUFFER_H


class Buffer
{
	public:
		Buffer(char* n,uint32_t siz);
		Buffer();
		~Buffer();
		
		void	add(uint8_t* c,uint32_t s);
		uint32_t	get(uint8_t* c,uint32_t s);
		void	clear();
		uint32_t		isEmpty();
		
		
		Buffer &operator>>(char *c);
		
		
		uint32_t 	size;
		char*	map;
	
};


#endif
