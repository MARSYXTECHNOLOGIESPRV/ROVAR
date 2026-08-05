; ============================================================
; ROVAR OS - A20 Enable Routine
;
; Included by boot1.asm
;
; BIOS Real Mode
; NASM Intel Syntax
; ============================================================


enable_a20:

    ; Try BIOS A20 service

    mov ax, 0x2401

    int 0x15


    ; For now assume success
    ; (we will add verification later)

    mov ax, 1

    ret
