
#include <os.h>
#include <runtime/buffer.h>



Buffer::Buffer(char* n,uint32_t siz){
	map=(char*)kmalloc(siz);
	size=siz;
	memcpy(map,n,siz);
}

Buffer::Buffer(){
	size=0;
	map=NULL;
}

Buffer::~Buffer(){
	if (map!=NULL)
		kfree(map);
}

void Buffer::add(uint8_t* c,uint32_t s){
	char* old=map;
	map=(char*)kmalloc(size+s);
	memcpy(map,old,size);
	kfree(old);
	memcpy((char*)(map+size),(char*)c,s);
	size=size+s;
}

uint32_t Buffer::get(uint8_t* c,uint32_t s){
	if( s>size)
		s=size;
	memcpy((char*)c,(char*)(map+(size-s)),s);
	char*old=map;
	map=(char*)kmalloc(size-s);
	memcpy(map,old,(size-s));
	kfree(old);
	size=size-s;
	return s;
}

uint32_t Buffer::isEmpty(){
	if (size==0)
		return 1;
	else
		return 0;
}

void Buffer::clear(){
	size=0;
	if (map!=NULL)
		kfree(map);	
}

Buffer &Buffer::operator>>(char *c)
{
	memcpy(c,map,size);
	return *this;
}
