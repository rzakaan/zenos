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