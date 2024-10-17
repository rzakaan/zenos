;
; Switching Protected Mode
;

[bits 16]
switch_pm:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1             ; enable protected mode
    mov cr0, eax
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    mov ax, DATA_SEG        ; update segment registers in GDT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; setup stack
    mov esp, ebp

    call BEGIN_PM           ; move back to boot.asm