;----------------------
; @author Riza Kaan Ucak
; @date 19.02.2024
;
; Bootloader source code
;----------------------

; BIOS will make the jump to memory at 0000:7c00 
; to continue execution in 16-bit mode.
[org 0x7c00]
[bits 16]

KERNEL_OFFSET   equ 0x1000
STACK_SIZE      equ 0x200

jmp main
nop

%include "print16.asm"
%include "disk.asm"

main:
    ; clear segment registers
    ; init stack address
    mov [ebr.drive_number], dl
    
    cli
    mov ax, 0x0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x9000
    sti
    
    call cls16
    call print16_nl
    call print16_nl
    
    call kernel_load

    jmp $                   ; stay here if everything is ok

kernel_load:
    mov si, MSG_LOAD_KERNEL
    call print16
    
    mov ax, 0
    mov es, ax

    mov bx, [KERNEL_OFFSET] ; read from disk and store in 0x1000
    ;mov bx, 0x7E00          ; read from disk and store in 0x1000
    mov al, 31              ; 31 sector
    mov ch, 0h              ; cylinder
    mov cl, 2h              ; first available sector
    mov dh, 0h              ; head number
    mov dl, 0h              ; drive number
    call disk_read

    ;mov [ebr_drive_number], dl
    ;mov ax, 1
    ;mov cl, 1
    ;mov bx, 0x7e00
    ;call read_disk

    ;mov [ebr_drive_number], dh
    ;call disk_read
    ret

load_protected:
    cli
    ;lgdt[lgdt_descriptor]
    mov eax, cr0
    or eax, 0x01
    mov cr0, eax
    ;jmp CODE_SEG:load32
    sti

; --------------------------------------------------
; Messages

MSG_LOAD_KERNEL db "Zenos kernel loading", 0x0d, 0x0a, 0
DISK_ERROR db "Disk read error ! Error Code: ", 0
SECTORS_ERROR db "Incorrect number of sectors read", 0

; --------------------------------------------------
; Variables

ebr:
    .read_sector            db 0
    .drive_number           db 0
    .total_sectors          dw 2880
    .sector_per_track       db 18 
    .bytes_per_sector       dw 512
    .system_id              db 'FAT12   ', 0
    .volume_label           db ' ZEN OS ', 0 
    .volume_id              db 12h, 34h, 56h, 78h  
    .signature              db 29h  

; bdb_oem:                    db 'MSWIN4.1'
; bdb_sectors_per_cluster:    dw 1
; bdb_reserved_sectors:       dw 1
; bdb_fat_count:              db 2
; bdb_dir_entries_count:      dw 0E0h
; bdb_media_descriptor_type:  db 0F0h
; bdb_sector_per_fat:         db 9 
; bdb_heads:                  db 2
; bdb_hiddent_sectors:        dd 0
; bdb_large_sector_count:     dd 0


times 510 - ($-$$) db 0
dw 0xaa55