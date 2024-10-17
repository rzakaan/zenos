#ifndef MEM_H
#define MEM_H

#include <stddef.h>

void memcp(char* source, char* dest, int n);
void memset(char* source, int chr, int n);
void* malloc(size_t size);

#endif