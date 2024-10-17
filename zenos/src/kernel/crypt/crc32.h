#include <stdint.h>

struct CRC32_CTX {
    uint8_t* encoded_data;
};

static void crc32_encrypt(struct CRC32_CTX* crc32_ctx, uint8_t* buffer);
static void crc32_decrypt(struct CRC32_CTX* crc32_ctx, uint8_t* buffer);