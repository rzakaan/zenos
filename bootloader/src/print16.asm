; NOTES
; --------------------------------------------------
; int 10h
;
; Video Mode
;   AH = 00H
;   AL = Video Mod
;
; Teletype Mode
;   AH = 0Eh
;   AL = <Character>
;   BH = Page Number
;   BL = Color (Only Graphic Mode)
;
; Background Color
;   AH = 0Bh
;   BH = 00h
;   BL = Background
;
; --------------------------------------------------


;
; About
;   clear screen
;
cls16:
    pusha
    mov ah, 0x00
    mov al, 0x03        ; text mode 80x25 16 colors
    int 0x10
    popa
    ret

;
; About         
;   prints the specified message to the screen
;
; Args
;   si  - (ptr) it is the base address for the string
;
print16:
    pusha
    mov ah, 0x0e        ; tty(teletype) mode
print16_loop:
    lodsb               ; DS:(E) SI -> AL
    cmp al, 0           ; if char == 0 null
    je print16_done
   
    int 0x10
    jmp print16_loop
print16_done:
    popa
    ret

;
; About
;   prints new line
;
; Args
;   no args
;
; Notes
;   Dec - Hex
;   10  - 0x0A - Line Feed
;   13  - 0x0D - Carriage Return
;
print16_nl:
    pusha
    
    mov ah, 0x0e        ; tty(teletype) mode
    mov al, 0x0a
    int 0x10
    
    mov al, 0x0d
    int 0x10
    
    popa
    ret

;
;   dx
;   A-F: 41-46
;   0-9: 30-39
print16_hex:
    pusha
    push cx
    mov cx, 0           ; index
print16_hex_loop:
    cmp cx, 4           ; loop 4 times
    je  print16_hex_done

    ; convert char(dx) to ascii
    mov ax, dx
    and ax, 0000fh           ; masking
    add al, 030h             ; ascii N
    jle print16_hex_step2
    add al, 7                ; 'A' is ASCII 65 instead of 58, so 65-58=7
print16_hex_step2:
    mov bx, PRINT16_HEX_OUT + 5 ; base + length
    sub bx, cx               ; our index variable
    mov [bx], al             ; copy the ASCII char on 'al' to the position pointed by 'bx'
    ror dx, 4                ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

    ; increment index and loop
    add cx, 1
    jmp print16_hex_loop
print16_hex_done:
    mov si, PRINT16_HEX_OUT
    call print16
    pop cx
    popa
    ret

PRINT16_HEX_OUT: db '0x0000', 0 