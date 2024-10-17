#include "display.h"
#include "ports.h"
#include "../mem.h"

// * Declarations
int get_cursor_offset();
void set_cursor_offset(int offset);
int print_char(char c, int col, int row, char attr);
int get_offset(int col, int row);
int get_offset_row(int offset);
int get_offset_col(int offset);

int get_offset(int col, int row) {
    return 2 * (row * MAX_COLS + col);
}

int get_offset_row(int offset) {
    return offset / (2 * MAX_COLS);
}

int get_offset_col(int offset) {
    return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2;
}

int get_cursor_offset() {
    port_byte_out(REG_SCREEN_CTRL, CURSOR_HIGH_BYTE);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;
    port_byte_out(REG_SCREEN_CTRL, CURSOR_LOW_BYTE);
    offset += port_byte_in(REG_SCREEN_DATA);
    return offset * 2;
}

void set_cursor_offset(int offset) {
    offset /= 2;
    port_byte_out(REG_SCREEN_CTRL, CURSOR_HIGH_BYTE);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, CURSOR_LOW_BYTE);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

void clear_screen() {
    int screen_size = MAX_COLS * MAX_ROWS;
    char* pScreen = (char*)VIDEO_ADDRESS;
    for (int i = 0; i < screen_size; i++) {
        pScreen[i * 2] = ' ';
        pScreen[i * 2 + 1] = WHITE_ON_BLACK;
    }
    set_cursor_offset(get_offset(0, 0));
}

void print(char* message) {
    print_at(message, -1, -1);
}

void print_at(char* message, int col, int row) {
    // set cursor if col/row are negative
    int offset;
    if (col >= 0 && row >= 0)
        offset = get_offset(col, row);
    else {
        offset = get_cursor_offset();
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }

    int i = 0;
    while (message[i] != 0) {
        offset = print_char(message[i++], col, row, WHITE_ON_BLACK);
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }
}

int print_char(char c, int col, int row, char attr) {
    unsigned char* vmem = (unsigned char*)VIDEO_ADDRESS;
    if (!attr) attr = WHITE_ON_BLACK;

    // Error control: print a red 'E' if the coords aren't right
    if (col >= MAX_COLS || row >= MAX_ROWS) {
        vmem[2 * (MAX_COLS) * (MAX_ROWS)-2] = 'E';
        vmem[2 * (MAX_COLS) * (MAX_ROWS)-1] = RED_ON_WHITE;
        return get_offset(col, row);
    }

    int offset;
    if (col >= 0 && row >= 0) offset = get_offset(col, row);
    else offset = get_cursor_offset();

    if (c == '\n') {
        row = get_offset_row(offset);
        offset = get_offset(0, row + 1);
    }
    else {
        vmem[offset] = c;
        vmem[offset + 1] = attr;
        offset += 2;
    }

    // Check if the offset is over screen size and scroll
    if (offset >= MAX_ROWS * MAX_COLS * 2) {
        int i;
        for (i = 1; i < MAX_ROWS; i++)
        {
            memcp((char*)get_offset(0, i) + VIDEO_ADDRESS, (char*)get_offset(0, i - 1) + VIDEO_ADDRESS, MAX_COLS * 2);
        }

        // Blank last line
        char* last_line = (char*)get_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS;
        for (i = 0; i < MAX_COLS * 2; i++) last_line[i] = 0;

        offset -= 2 * MAX_COLS;
    }

    set_cursor_offset(offset);
    return offset;
}