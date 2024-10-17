
[bits 16]

kernel_main:
    mov si, KERNEL_MESSAGE
    call print

halt:
    jmp halt


print:
    push si
    push ax 
    push bx

print_loop:
    loadsb
    or al, al
    jz print_done

    mov ah, 0x0e
    mov bh, 0
    int 10h

    jmp print_loop
print_done:
    pop bx
    pop ax
    pop si
    ret

; --------------------------------------------
; Message

KERNEL_MESSAGE db "Kernel loaded, wellcome", 0x0d, 0x0a, 0
kernel_cluster dw 0
kernel_load_segment equ 0x2000
kernel_offset equ 0