; ============================================================
; ROVAR OS - Boot1
;
; Second Stage Loader
;
; Loaded by Boot0 at physical address 0x8000
;
; BIOS Real Mode
; NASM Intel Syntax
; ============================================================


BITS 16
ORG 0x8000



; ============================================================
; Boot1 Entry Point
; IMPORTANT:
; This must be the first thing in the binary because Boot0
; jumps directly to 0x8000.
; ============================================================


boot1_start:


    cli


    ; ------------------------------------
    ; Setup segments
    ; ------------------------------------

    xor ax, ax

    mov ds, ax
    mov es, ax
    mov ss, ax


    ; ------------------------------------
    ; Setup stack
    ; ------------------------------------

    mov sp, 0x9000


    sti



    ; ------------------------------------
    ; Boot1 started
    ; ------------------------------------

    mov si, msg_boot1

    call print_string



    ; ------------------------------------
    ; Enable A20
    ; ------------------------------------

    call enable_a20



    cmp ax, 1

    je .a20_ok



.a20_fail:

    mov si, msg_a20_fail

    call print_string

    jmp halt




.a20_ok:


    mov si, msg_a20_ok

    call print_string





; ============================================================
; Temporary halt
;
; Next:
; - GDT
; - Protected Mode
; - Kernel Loader
; ============================================================


halt:


    cli

    hlt

    jmp halt





; ============================================================
; BIOS Text Output
;
; DS:SI -> zero terminated string
; ============================================================


print_string:


.next:


    lodsb


    test al, al

    jz .done



    mov ah, 0x0E

    mov bh, 0x00


    int 0x10


    jmp .next



.done:


    ret





; ============================================================
; Messages
; ============================================================


msg_boot1:

    db "ROVAR Boot1 running...",13,10,0



msg_a20_ok:

    db "[ OK ] A20 enabled",13,10,0



msg_a20_fail:

    db "[FAIL] A20 failed",13,10,0





; ============================================================
; Include additional routines LAST
;
; This prevents the CPU jumping into a subroutine at 0x8000.
; ============================================================


%include "boot/a20.asm"




; ============================================================
; Boot1 size
;
; Boot0 loads 4 sectors
; ============================================================


times 2048-($-$$) db 0
