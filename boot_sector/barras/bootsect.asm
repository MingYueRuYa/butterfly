;从软盘加载loader并把控制权交给它
[bits 16]
boot:
	;初始化
	xor ax,ax
	mov ds,ax
	mov es,ax
	
	;把loader从0号磁头、0号柱面、2号扇区加载到内存0x8000
	mov ax,0x800
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
	
	;jmp 0x8000
	jmp 0x800:0
	
times 510-($-$$) db 0
db 0x55,0xaa