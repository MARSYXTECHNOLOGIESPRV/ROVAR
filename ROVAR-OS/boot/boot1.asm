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

KERNEL_LOAD_ADDR equ 0x10000
KERNEL_SECTORS   equ 32

; ============================================================
; Boot1 Entry Point
; IMPORTANT:
; This must be the first thing in the binary because Boot0
; jumps directly to 0x8000.
; ============================================================


boot1_start:


    cli

    mov [boot_drive], dl


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


    ; ------------------------------------
    ; Load Kernel
    ; ------------------------------------

    call load_kernel

    ; ------------------------------------
    ; Load Global Descriptor Table
    ; ------------------------------------

    call load_gdt

    mov si, msg_gdt_ok
    call print_string

    ; ------------------------------------
    ; Load 32-Bit CPU Protected Mode
    ; ------------------------------------

    call enter_protected_mode


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
; Load Kernel From Disk
;
; Kernel starts at sector 6
; Loads to 0x1000:0000 (0x10000)
; ============================================================

load_kernel:


    mov si, msg_kernel_load
    call print_string


    mov ax, 0x1000
    mov es, ax

    xor bx, bx


    mov ah, 0x02
    mov al, KERNEL_SECTORS

    mov ch, 0
    mov cl, 6
    mov dh, 0

    mov dl, [boot_drive]


    int 0x13


    jc kernel_error


    ret



kernel_error:

    mov si, msg_kernel_error
    call print_string

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

boot_drive:

    db 0


msg_boot1:

    db "ROVAR Boot1 running...",13,10,0



msg_a20_ok:

    db "[ OK ] A20 enabled",13,10,0

msg_kernel_load:

    db "[ OK ] Kernel loaded",13,10,0


msg_kernel_error:

    db "[FAIL] Kernel load",13,10,0


msg_a20_fail:

    db "[FAIL] A20 failed",13,10,0


msg_gdt_ok:

    db "[ OK ] GDT loaded",13,10,0





; ============================================================
; Include additional routines LAST
;
; This prevents the CPU jumping into a subroutine at 0x8000.
; ============================================================


%include "boot/a20.asm"
%include "boot/gdt.asm"
%include "boot/pmode.asm"


; ============================================================
; Boot1 size
;
; Boot0 loads 4 sectors
; ============================================================


times 2048-($-$$) db 0
