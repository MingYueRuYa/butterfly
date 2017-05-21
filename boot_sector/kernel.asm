[bits 32]
extern void init();

start:
	;init
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	;call c function need stack space
	mov esp, 0xa0000

	call init
	jmp $
