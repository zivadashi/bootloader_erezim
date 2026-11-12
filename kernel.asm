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