#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

// Screen i/o ports
#define REG_SCREEN_CTRL   0x3d4
#define REG_SCREEN_DATA   0x3d5
#define CURSOR_HIGH_BYTE  14
#define CURSOR_LOW_BYTE   15

/**
 * @brief clear screen
 */
void clear_screen();

/**
 * @brief print a one character to display
 *
 * @param message
 */
void print_at(char* message, int col, int row);

/**
 * @brief print char array to display
 *
 * @param message
 */
void print(char* message);