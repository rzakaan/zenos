; --------------------------------------------
; @author Riza Kaan Ucak
; @date 21.01.2022
; @description Lov Level Disk Services
; --------------------------------------------
;
; Note
; A sector is the smallest pyhsical storage unit on the disk, 
; and on most file systems it is fixed at 512 bytes in size
; 
; ------------------------------------------------------------
; Disk Services
; int 13h
;
; CHS (Cylinder Head Sector)
; cylinder(platter) > head > track > cluster > sector
;
; The cylinder number in CH range 0 - 1023(3FF)
; The head number in     DH range 0 - 255(FF)
; The sector number in   CL range 1 - 63(3F)
;
; Since this cannot be held in a single byte, 
; the 2 highest bits of this 10-bit number are stored in bits 6 and 7 of the CL register
;
; Logical Block Addressing (LBA)
; Converting CHS to LBA
; LBA = (C * TH * TS) + (H * TS) + (S - 1)
;   C : Sektor Clynder Numner
;   TH: Total Headers on disk
;   TS: Total Sector on disk
;   H : Sector head number
;   S : Sector's number
;
; Converting LBA to CHS
;   t = LBA/Sector per track
;   s = (LBA % sector per track) + 1
;   h = (t % number of heads)
;   c = (t / number of headers)
; ----------------------------------------------------------------------------------------------------

; ----------------------------------------------------------------------------------------------------
; 0x02 Read Sector Disk
; 
; load 'dh' sectors from drive 'dl' into ES:BX
; 
; Args
;   al     : read sector number     : (0x01 .. 0x80)
;   ch     : cylinder               : (0x00 .. 0x3FF, upper 2 bits in 'cl')
;   cl     : sector index           : (1=boot-sector, 2=first-available)
;   dh     : head number            : (0x00 .. 0xF)
;   dl     : drive number           : (0=floppy, 1=floppy2, 80h=hdd, 81h=hdd2)
;   es:bx  : buffer address pointer : es + bx
; 
;   cf     : if 0x01 error status else 0x00
;   ah     : return code
;   al     : actual read count
disk_read:
    push dx
    
    call lba_to_chs

    mov ah, 2h           ; read sector service
    ;mov cl, 2h          ; first available sector
    ;mov ch, 0h          ; cylinder
    ;mov dh, 0h          ; head number
    ;mov al, dh          ; number sectors
    int 13h              ; interrupt disk services
    jc disk_error        ; check error (stored in the carry bit)

    cmp al, dh
    jne sectors_error

    ; no error
    mov [ebr.read_sector], al      ; set actual read count
    mov [ebr.drive_number], dl     ; set actual read count

    pop dx
    ret
disk_error:
    ;
    ; ah -> error code
    ; dh -> disk drive
    mov si, DISK_ERROR
    call print16
    
    mov dl, ah
    mov dx, 0
    call print16_hex
    call print16_nl
    jmp disk_end
sectors_error:
    mov bx, SECTORS_ERROR
    call print16
disk_end:
    jmp $

;
; --------------------------------------------------------------------------------------------------------------------
;
disk_load:
    push ax
    push bx
    push cx
    push dx
    push di

    call lba_to_chs

    mov ah, 2h
    mov di, 3   ; counter
retry:
    stc
    int 13h
    jnc doneRead

    call diskReset

    dec di
    test di, di
    jnz retry
failDiskRead:
    mov si, DISK_ERROR
    call print16
    hlt 
    jmp $
diskReset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc failDiskRead
    popa
    ret
doneRead:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;
; input LBA index in ax
;
; cx [bits  0-5]: sector number
; cx [bits 6-15]: cylinder
; dx head
lba_to_chs:
    pusha
    push dx

    xor dx, dx
    div word [ebr.sector_per_track]     ; lba % sector per track + 1
    
    ; sector
    inc dx
    mov cx, dx
    xor dx, dx

    ; head : (lba / sector per track) % number of heads
    mov dh, dl
    mov ch, al
    shl ah, 6
    
    ; cylinder  : (lba % sector per track)
    or cl, ah
    
    popa
    mov dl, al
    popa
    ret