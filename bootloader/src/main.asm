[org 0x7c00]
KERNEL_OFFSET equ 0x1000

;mov [BOOT_DRIVE], dl
;mov bp, 0x9000
;mov sp, bp

call cls16
call load_kernel
call switch_pm
jmp $

%include "./print16.asm"
%include "./print32.asm"
%include "./disk.asm"
%include "./gdt.asm"
%include "./switch_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print16
    call print16_nl

    mov bx, KERNEL_OFFSET
    mov dh, 16
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    call KERNEL_OFFSET
    jmp $

BOOT_DRIVE db 0
MSG_LOAD_KERNEL db "Zenos kernel loading into memory...", 0

; padding and boot signature
times 510 - ($-$$) db 0
dw 0xaa55