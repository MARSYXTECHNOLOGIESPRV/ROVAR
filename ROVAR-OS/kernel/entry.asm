; ============================================================
; ROVAR Kernel Entry
;
; 32-bit entry point
; NASM Intel Syntax
; ============================================================

BITS 32


global kernel_start
extern kernel_main


kernel_start:

    call kernel_main


.hang:

    cli
    hlt
    jmp .hang
