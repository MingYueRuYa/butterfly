;show ch in screen by graphics card
mov ax, 0xB800
mov gs, ax
mov ah, 0x04
mov al, 'H'
mov [gs:0], ax
mov al, 'H'
mov [gs:2], ax
mov al, 'l'
mov [gs:4], ax
mov al, 'l'
mov [gs:6], ax
mov al, 'o'
mov [gs:8], ax
mov al, ' '

times 510-($-$$) db 0
db 0x55, 0xaa
