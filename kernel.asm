[BITS 32]

; getting the cursor position
mov eax, 0

mov dx,0x3D4       ; Tell the control I/O port to get the lower byte of
mov al,0x0F        ; the cursor offset
out dx,al
mov dx,0x3D5       ; Switch to data I/O port
in  al,dx          ; Get the cursor offset's lower byte
mov bl, al

mov dx,0x3D4       ; Tell the control I/O port to get the higher byte of
mov al,0x0E        ; the cursor offset
out dx,al
mov dx,0x3D5       ; Switch to data I/O port
in  al,dx          ; Get the higher byte
mov ah, al
mov al, bl

imul ax,2

; Write "!" to VGA to screen at cursor location
mov cl, '!'
mov ch, 7
mov edi, 0xB8000
add edi, eax
mov [edi], cl
mov [edi + 1], ch

cli            ; Clear interrupts
hlt            ; Stop the CPU
halt:
jmp halt

VIDEO_MEMORY equ 0xB8000