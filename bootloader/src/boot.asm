;----------------------
; @author Riza Kaan Ucak
; @date 19.02.2024
;
; Bootloader source code
;----------------------

[org 0x7c00]
[bits 16]

KERNEL_OFFSET equ 0x1000
BOOT_ADRESS equ 0x7C00

call main

%include "./print16.asm"

main:
    ; init register and set sp
    mov ax, 0
    mov bx, ax
    mov es, ax
    mov ss, ax    
    mov sp, [BOOT_ADRESS]

    ; clear screen
    call cls16
    call print16_nl
    call print16_nl
    mov si, MESSAGE
    call print16

    ; load kernel
    call kernel_load

    jmp $

kernel_load:
    mov si, MSG_LOAD_KERNEL
    call print16
    ret
; --------------------------------------------------

MESSAGE db "Booting...", 0x0d, 0x0a, 0
MSG_LOAD_KERNEL db "Zenos kernel loading into memory...", 0x0d, 0x0a, 0

times 510 - ($-$$) db 0
dw 0xaa55