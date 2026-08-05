; ============================================================
; ROVAR OS - Boot0
;
; BIOS Boot Sector
; Loads Boot1 into memory at 0x8000
;
; NASM Intel Syntax
; ============================================================


BITS 16
ORG 0x7C00


BOOT1_ADDR     equ 0x8000
BOOT1_SECTORS  equ 4


start:

    cli


    ; Setup segments

    xor ax, ax

    mov ds, ax
    mov es, ax
    mov ss, ax


    mov sp, 0x7C00


    sti



    ; Save BIOS drive number

    mov [boot_drive], dl



    ; Display message

    mov si, msg_boot

    call print_string



    ; Reset disk

    xor ah, ah

    mov dl, [boot_drive]

    int 0x13



    ; Read Boot1

    mov ah, 0x02

    mov al, BOOT1_SECTORS


    ; Cylinder 0

    mov ch, 0


    ; Start at sector 2

    mov cl, 2


    ; Head 0

    mov dh, 0


    ; BIOS drive

    mov dl, [boot_drive]


    ; Destination

    mov bx, BOOT1_ADDR



    ; Try reading

    call disk_read



    jc disk_error



    ; Boot1 loaded

    mov si, msg_loaded

    call print_string



    ; Jump to Boot1

    jmp 0x0000:BOOT1_ADDR





; ============================================================
; Disk Read with retry
; ============================================================


disk_read:


    mov bp, 3


.retry:


    int 0x13


    jnc .success



    ; Reset disk

    xor ah, ah

    mov dl, [boot_drive]

    int 0x13



    dec bp

    jnz .retry



    stc

    ret



.success:

    clc

    ret





; ============================================================
; Print string
; ============================================================


print_string:


.next:

    lodsb

    test al, al

    jz .done



    mov ah,0x0E

    mov bh,0


    int 0x10


    jmp .next



.done:

    ret





; ============================================================
; Error
; ============================================================


disk_error:


    mov si,msg_error

    call print_string



.hang:

    cli

    hlt

    jmp .hang





; ============================================================
; Data
; ============================================================


boot_drive:

    db 0



msg_boot:

    db "ROVAR Boot0 v0.0.1",13,10,0



msg_loaded:

    db "[ OK ] Boot1 loaded",13,10,0



msg_error:

    db "[FAIL] Disk read",13,10,0





times 510-($-$$) db 0

dw 0xAA55
