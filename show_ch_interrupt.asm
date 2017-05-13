;show char in screen by interrupte
xor ax, ax
mov ds, ax
mov es, ax

mov ah, 0x0e
mov al, 'B'
int 0x10

jmp $
times 510-($-$$) db 0
db 0x55, 0xaa
