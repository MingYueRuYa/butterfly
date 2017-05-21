[bits 32]
extern init

start:
	mov ax,0x10
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov gs,ax
	mov ss,ax
	; call c function need stack space
	mov esp,0xa0000
	
	; move remain kernel to 0x200
	cld
	mov esi,0x8200
	mov edi,0x200
	mov ecx,(100-1)<<7
	rep 
	movsd

	call init
	
	jmp $
