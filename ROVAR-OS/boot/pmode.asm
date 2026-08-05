; ============================================================
; ROVAR OS - Protected Mode Transition
;
; Intel x86
; NASM Intel Syntax
;
; Switches the CPU from 16-bit Real Mode
; to 32-bit Protected Mode.
; ============================================================


enter_protected_mode:

    ; ------------------------------------
    ; Disable interrupts
    ; ------------------------------------

    cli


    ; ------------------------------------
    ; Enable Protected Mode
    ; ------------------------------------

    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax


    ; ------------------------------------
    ; Far jump into 32-bit code
    ; ------------------------------------

    jmp CODE_SEG:protected_mode_start




; ============================================================
; 32-bit Code Begins Here
; ============================================================

BITS 32

protected_mode_start:


    ; ------------------------------------
    ; Load data segment selectors
    ; ------------------------------------

    mov ax, DATA_SEG

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax


    ; ------------------------------------
    ; Setup a new stack
    ; ------------------------------------

    mov esp, 0x90000


    ; ============================================================
    ; Clear VGA text screen
    ; ============================================================

clear_screen:

    mov edi, 0xB8000

    mov eax, 0x0F200F20
    ; Two spaces:
    ; 0x20 = space
    ; 0x0F = white foreground, black background


    mov ecx, 1000
    ; 80*25 cells = 2000
    ; Each dword clears 2 cells
    ; 2000 / 2 = 1000


    rep stosd



; ============================================================
; Write ROVAR test message
; ============================================================

    mov edi, 0xB8000


    mov byte [edi], 'R'
    mov byte [edi+2], 'O'
    mov byte [edi+4], 'V'
    mov byte [edi+6], 'A'
    mov byte [edi+8], 'R'


    mov byte [edi+1], 0x0F
    mov byte [edi+3], 0x0F
    mov byte [edi+5], 0x0F
    mov byte [edi+7], 0x0F
    mov byte [edi+9], 0x0F


.hang:

    cli
    hlt
    jmp .hang
