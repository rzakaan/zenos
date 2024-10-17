;
; Global Descriptor Table
;
;
; |31                    |   |    |   |   |       |   |     |   |      |                    0|
; |-------------------------------------------------------------------------------------------
; | Base Address (24-31) | G | DB |   | A | Limit | P | DPL | S | Type | Base Address (16-23)|
; |-------------------------------------------------------------------------------------------
; | Base Address (0-15)  |                    |                                              |
; |------------------------------------------------------------------------------------------|

; gdt starts with a null 8-byte
gdt_start:
    dd 0x0   ; 4 byte
    dd 0x0   ; 4 byte

; code segment descriptor. base = 0x00000000, length = 0xfffff, 8 byte
gdt_code: 
    dw 0xffff       ; segment length, bits 0-15
    dw 0x0          ; segment base,   bits 0-15
    db 0x0          ; segment base,   bits 16-23
    db 10011010b    ; flags (8 bits)
    db 11001111b    ; flags (4 bits) + segment length, bits 16-19
    db 0x0          ; segment base,   bits 24-31

; data segment descriptor. base and length identical to code segment, 8 byte
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

; gdt descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1      ; size (16 bit)
    dd gdt_start                    ; address (32 bit)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start