#ifndef _DEBUG_H
#define _DEBUG_H



extern int dbprint(const char *title, int line, const char *fmt, ...);


#define dprint( ...) dbprint(__FILE__, __LINE__, __VA_ARGS__)

#endif