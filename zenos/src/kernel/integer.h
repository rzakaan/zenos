/* TYPE DEFINITION */

/* INTEGER 8 MIN/MAX VALUES */
#ifdef __INT8_TYPE__
#define INT8_BIT         8
#define INT8_BYTE        1
#define INT8_MAX         127
#define INT8_MIN         -127-1
#define UINT8_MAX        255
#endif /* __INT8_TYPE__ */

/* INTEGER 16 MIN/MAX VALUES */
#ifdef __INT16_TYPE__
#define INT16_BIT        16
#define INT16_BYTE       2
#define INT16_MAX        32767
#define INT16_MIN        -32767-1
#define UINT16_MAX       65535
#endif /* __INT16_TYPE__ */

/* INTEGER 32 MIN/MAX VALUES */
#ifdef __INT32_TYPE__
#define INT32_BIT        32
#define INT32_BYTE       4
#define INT32_MAX        2147483647
#define INT32_MIN        -2147483647-1
#define UINT32_MAX       4294967295
#endif /* __INT32_TYPE__ */