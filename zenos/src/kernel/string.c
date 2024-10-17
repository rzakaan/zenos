#include "string.h"

size_t strlen(const char* source) {
    long length = 0;
    for (int i = 0; NULL != source[i]; i++) length++;
    return length;
}


size_t strcmp(const char* string_source, const char* string_compare) {
    const unsigned char* s1 = (const unsigned char*)string_source;
    const unsigned char* s2 = (const unsigned char*)string_compare;
    unsigned char c1, c2;
    do
    {
        c1 = (unsigned char)*s1++;
        c2 = (unsigned char)*s2++;
        if (c1 == '\0') return c1 - c2;
    } while (c1 == c2);
    return c1 - c2;
}
