; ============================================================
; ROVAR OS - Global Descriptor Table
;
; Intel x86 Protected Mode
; NASM Intel Syntax
;
; This GDT uses a flat memory model:
;   - Code: 0x00000000 -> 0xFFFFFFFF
;   - Data: 0x00000000 -> 0xFFFFFFFF
; ============================================================


; ------------------------------------------------------------
; Segment Selector Constants
; ------------------------------------------------------------

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


; ------------------------------------------------------------
; Global Descriptor Table
; ------------------------------------------------------------

gdt_start:


; ------------------------------------------------------------
; Null Descriptor (Required)
; Selector = 0x00
; ------------------------------------------------------------

gdt_null:

    dq 0x0000000000000000


; ------------------------------------------------------------
; Kernel Code Segment
; Selector = 0x08
; Base  = 0x00000000
; Limit = 0xFFFFFFFF
; ------------------------------------------------------------

gdt_code:

    dw 0xFFFF          ; Limit (0-15)
    dw 0x0000          ; Base  (0-15)
    db 0x00            ; Base  (16-23)

    db 10011010b       ; Access byte
                       ; Present
                       ; Ring 0
                       ; Code
                       ; Readable

    db 11001111b       ; Flags
                       ; 4KB Granularity
                       ; 32-bit
                       ; Limit (16-19)

    db 0x00            ; Base (24-31)


; ------------------------------------------------------------
; Kernel Data Segment
; Selector = 0x10
; Base  = 0x00000000
; Limit = 0xFFFFFFFF
; ------------------------------------------------------------

gdt_data:

    dw 0xFFFF
    dw 0x0000
    db 0x00

    db 10010010b       ; Present
                       ; Ring 0
                       ; Data
                       ; Writable

    db 11001111b

    db 0x00


gdt_end:


; ------------------------------------------------------------
; GDTR Structure
; Used by LGDT instruction
; ------------------------------------------------------------

gdt_descriptor:

    dw gdt_end - gdt_start - 1
    dd gdt_start



; ------------------------------------------------------------
; Load GDT Routine
; ------------------------------------------------------------

load_gdt:

    lgdt [gdt_descriptor]

    ret
