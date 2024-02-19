[bits 32]

global _start
_start:
    [extern main]   ; must have same name as kernel.c 'main' function
    call main       ; calls the C function. The linker will know where it is placed in memory
    jmp $