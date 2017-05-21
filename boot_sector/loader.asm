[bits 16]
pm_mode:
	jmp code
;prepare GDT
gdt:
;create three segment
dw 0x0000, 0x0000, 0x0000
;0-4GB code segment
dw 0xffff, 0x0000, 0x9a00, 0x00cf
;0-4GB data segment
dw 0xffff, 0x0000, 0x9200, 0x00cf

gdt_48:
	dw 23
	dd 0x50000

code:
	;init
	xor ax, ax
	mov ds, ax
	mov es, ax
	
	;load the kernel from 0 head, 0 cylider, 3 sector to memory 0x6000
	mov ax, 0x600
	mov es, ax
	xor bx, bx

	mov ch, 0
	mov cl, 3
	mov dh, 0
	mov dl, 0

repeate_read:
	mov ah, 2	
	mov al, 1
	int 0x13
	
	jc repeate_read

	;close interrupte
	cli 

	;move GDT to 0x5000 ds:si ----> es:di
	xor ax, ax
	mov ds, ax
	mov ax, 0x5000
	mov es, ax
	mov si, gdt
	xor di, di
	mov cx, 24>>2
	rep 
	movsd

;enter protected mode
enable_A20:
	in al, 0x64
	test al, 0x2
	jnz enable_A20
	mov al, 0xdf
	out 0x64, al

	;use lgdt load the gdtr
	lgdt [gdt_48]

	;set the cr0 PE bit
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	
	jmp 0x08:0x6000

times 512-($-$$) db 0





