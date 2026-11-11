[org 0x7c00]

; Prints A and stops
start:
mov ah, 0x0e   ; BIOS teletype function
mov al, 'A'    ; Character to print
mov bh, 0
mov bl, 7
int 0x10       ; Call BIOS video interrupt

halt:
cli            ; Clear interrupts
hlt            ; Stop the CPU
jmp halt


; Currently not running:

; disable interrupts and set global descriptor table
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
jmp 8:10000h

; putting the boot signature
times 510-($-$$) db 0
dw 0xaa55
