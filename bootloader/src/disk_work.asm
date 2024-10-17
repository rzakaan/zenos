
; inputs
;   cx [bits 0-15]  sector number
;   cx [bits 6-15]  cylinder
;   dh head
lba_to_chs:
    push ax
    push dx
    
    xor dx, dx
    div word[bdb_sector_per_track]
    
    inc dx
    mov cx, dx

    xor dx, dx
    div word[bdb_heads]
    mov dl, dl
    mov ch, cl
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, dl
    pop ax
    ret

read_disk:
    ; read disk
    ; ah = 2
    ; al = number of sectors read
    ; ch track/cylinder number
    ; cl sector number 
    ; dh head number
    ; dl drive number
    ; cf = 0 is succes
    pusha
    push bx
    push cx
    push dx
    push di

    call lba_to_chs
    mov ah, 2h
    mov di, 3 ; counter

    ret

retry:
    stc
    int 13h
    jnc done_read

    call disk_reset
    dec di
    test di, di
    jnz retry

disk_read_fail:
    mov si, MSG_DISK_READ_FAILURE
    call print
    hlt
    jmp hlt

disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc disk_read_fail
    popa

done_read:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret