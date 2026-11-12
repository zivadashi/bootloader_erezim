[org 0x7c00]

jmp start

gdt_start:
    dq 0x0           ; Null descriptor (required)
gdt_code:
    dw 0xFFFF        ; Limit (low)
    dw 0x0000        ; Base (low)
    db 0x00          ; Base (middle)
    db 10011010b     ; Access byte (32-bit code segment)
    db 11001111b     ; Flags (4 KB granularity)
    db 0x00          ; Base (high)
gdt_data:
    dw 0xFFFF        ; Limit (low)
    dw 0x0000        ; Base (low)
    db 0x00          ; Base (middle)
    db 10010010b     ; Access byte (data segment)
    db 11001111b     ; Flags (4 KB granularity)
    db 0x00          ; Base (high)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

DAPACK:
	db	0x10
	db	0
blkcnt:	dw	1		; int 13 resets this to # of blocks actually read/written
db_add:	dw	0x0000		; memory buffer destination address
	dw	0x1000		; segment 0
d_lba:	dq	1

start:

xor ax, ax
mov ds, ax
mov es, ax

; testing if A20 is already enabled
in al, 0x92
test al, 2
jnz enabled

; not enabled - enable manually
or al, 2
and al, 0xFE
out 0x92, al
enabled:

mov ah, 0x0e   ; BIOS teletype function
mov al, 'A'    ; Character to print
mov bh, 0
mov bl, 7
int 0x10       ; Call BIOS video interrupt

mov si, DAPACK		; address of "disk address packet"
mov ah, 0x42		; AL is unused
mov dl, 0x80		; drive number 0 (OR the drive # with 0x80)
int 0x13
jc short failed_read
jmp finished_read

failed_read:
mov ah, 0x0e   ; BIOS teletype function
mov al, 'B'    ; Character to print
mov bh, 0
mov bl, 7
int 0x10       ; Call BIOS video interrupt

halt:
cli            ; Clear interrupts
hlt            ; Stop the CPU
jmp halt

finished_read:
mov ah, 0x0e   ; BIOS teletype function
mov al, 'C'    ; Character to print
mov bh, 0
mov bl, 7
int 0x10       ; Call BIOS video interrupt

cli
lgdt [gdt_descriptor]

; disable interrupts and set global descriptor table
mov eax,cr0
mov eax,cr0
or eax,1
mov cr0,eax

; set registers and far jump to the kernel
mov ax,10h
mov ds,ax
mov es,ax
mov fs,ax
mov gs,ax
mov ss,ax
jmp 0x1000:0x0000

; putting the boot signature
times 510-($-$$) db 0
dw 0xaa55
