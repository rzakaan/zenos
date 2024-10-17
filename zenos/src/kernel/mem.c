#include "mem.h"

/**
 * kernel starts at 0x10000 as defined
 *
 */
int free_mem_addr = 0x10000;

void memcp(char* source, char* dest, int n) {
    for (int i = 0; i < n; i++) {
        *(dest + i) = *(source + i);
    }
}

void memset(char* source, int chr, int n) {
    for (int i = 0; i < n; i++) {
        *(source + i) = chr;
    }
}

void* malloc(size_t size) {
    // ! implementation continues
    int ret = free_mem_addr;
    free_mem_addr += size;
    return (void*)ret;
}
