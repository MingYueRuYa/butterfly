;load the loader from floppy disk and give control to him
;indicates real mode
[bits 16]
boot:
	;init
	xor ax, ax
	mov ds, ax
	mov es, ax

	;load the loader from 0 head, 0 cylinder, 2 sector loaded into memory 0x8000
	mov ax, 0x800
	mov es, ax
	xor bx, bx

	mov ch, 0
	mov cl, 2 
	mov dh, 0
	mov dl, 0

repeat_read:
	mov ah, 2	
	mov al, 1
	int 0x13
	jc repeat_read

	jmp 0x800:0

times 510-($-$$) db 0
db 0x55, 0xaa
