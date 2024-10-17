#ifndef AES_H
#define AES_H

#define AES128 1
//#define AES192 1
//#define AES256 1

// Block length in bytes - AES is 128b block only
#define AES_BLOCKLEN 16

#if defined(AES256) && (AES256 == 1)
#define AES_KEYLEN 32
#define AES_keyExpSize 240
#elif defined(AES192) && (AES192 == 1)
#define AES_KEYLEN 24
#define AES_keyExpSize 208
#else
#define AES_KEYLEN 16
#define AES_keyExpSize 176
#endif

struct AES_CTX {
    char round_key[AES_keyExpSize];
};

static void aes_encrypt(const struct AES_CTX* ctx, uint8_t* buf);
static void aes_decrypt(const struct AES_CTX* ctx, uint8_t* buf);

#endif // !AES_H