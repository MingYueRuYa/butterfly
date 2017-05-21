; load the loader from floppy disk and give it to it
[bits 16]
boot:
	; init
	xor ax,ax
	mov ds,ax
	mov es,ax
	
	; Load the loader from 0 head, 0 cylinder, 2 sector loaded into memory 0x7e00
	mov ax,0x7e0
	mov es,ax
	xor bx,bx
	
	mov ch,0
	mov cl,2
	mov dh,0
	mov dl,0
	
rp_read:
	mov ah,2
	mov al,1
	int 0x13
	jc rp_read
	
	;jmp to loader memory address
	jmp 0x7e0:0
	
times 510-($-$$) db 0
db 0x55,0xaa
