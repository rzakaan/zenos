;*----------------------------
;* Loads FAT table to FAT_SEG 
;*----------------------------

LoadFat:
    xor ax, ax
    xor ebx, ebx
    xor ecx, ecx
    xor dx, dx

    ; compute size of FAT and store in "ax"
    mov ax, WORD [bpb_SectorsPerFAT]        ; sectors used by FAT

    ; compute location of FAT and store in "ecx"
    mov cx, WORD [bpb_ReservedSectors]
    add ecx, 2048                       ; temporary code for first partition

    ; read FAT into memory at FAT_SEG
    mov dl, [bpb_DriveNumber]
    mov bx, WORD FAT_SEG
    call ReadSectorsLBA
    ret