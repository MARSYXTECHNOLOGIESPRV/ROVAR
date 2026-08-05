; ============================================================
; ROVAR OS - Protected Mode Transition
;
; Switches CPU from 16-bit Real Mode
; into 32-bit Protected Mode
;
; NASM Intel Syntax
; ============================================================


enter_protected_mode:


    cli


    ; ------------------------------------
    ; Enable Protected Mode
    ; ------------------------------------

    mov eax, cr0

    or eax, 0x1

    mov cr0, eax



    ; ------------------------------------
    ; Far jump into 32-bit code
    ; ------------------------------------

    jmp CODE_SEG:protected_mode_start




; ============================================================
; 32-bit Protected Mode
; ============================================================

BITS 32


protected_mode_start:


    ; ------------------------------------
    ; Setup data segments
    ; ------------------------------------

    mov ax, DATA_SEG

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax



    ; ------------------------------------
    ; Setup stack
    ; ------------------------------------

    mov esp, 0x90000



    ; ------------------------------------
    ; Jump to kernel
    ;
    ; Kernel loaded at 0x10000
    ; ------------------------------------

    jmp 0x10000
