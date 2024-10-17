;*----------------------------------
;* Reads a series of sectors        
;* Parameters:                      
;*   dl  : bootdrive                
;*   ax  : sectors count            
;*   ebx : address to load to       
;*   ecx : LBA address              
;* Returns:                         
;*   cf  : set if error             
;*----------------------------------

readSectorsLBA:
    mov si, LBA_Packet
    mov ah, 0x42
    int 13h
    mov [LBA_Packet.block_cout], ax
    mov [LBA_Packet.transfer_buffer], ebx
    mov [LBA_Packet.lba_value], ecx
    ret

align 4
LBA_Packet:
    .packet_size    db 0x10     ; use transfer_64 10h : 18h
    .reserved       db 0        ; reserved for future expansion
    .sector_count   dw 0        ; number of sectors to read
    .transfer_buff  dd 0        ; address to load in ram
    .lba_value      dq 0        ; LBA address value