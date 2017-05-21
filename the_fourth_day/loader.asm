[bits 16]
pm_mode:
	jmp code
	
; prepare GDT
gdt:
; create three segment
dw 0x0000,0x0000,0x0000,0x0000
; 0-4GB code segment
dw 0xffff,0x0000,0x9a00,0x00cf
; 0-4GB data segment
dw 0xffff,0x0000,0x9200,0x00cf

gdt_48:
	dw 23
	; load GDT memory address
	dd 0x20000
	
code:
	xor ax,ax
	mov ds,ax
	mov es,ax
	
	; load kernel from 0 head, 0 cylider, 3 sector to memory 0x8000
	mov ax,0x800
	mov es,ax
	xor bx,bx
	
;	mov ch,0
;	mov cl,3
;	mov dh,0
;	mov dl,0
	
;	logic address
	mov si,2
	mov cx,100
continue:
;	mov ah,2
;	mov al,1
;	int 0x13
;	jc rp_read
	call read_sect
	inc si
	add bx,512
	loop continue
	
	; close interrupt
	cli

;	move kernel first sector 0x8000 to 0x0000
	cld
	xor ax,ax
	mov ds,ax
	mov ax,0x0000
	mov es,ax
	mov si,0x8000
	xor di,di
	mov cx,512>>2
	rep
	movsd
	
	; move GDT to 0x20000 ds:si ----> es:di
	xor ax,ax
	mov ds,ax
	mov ax,0x2000
	mov es,ax
	mov si,gdt
	xor di,di
	mov cx,24>>2
	rep
	movsd
	
; enter protected mode
; open A20
enable_a20:
	in al,0x64
	test al,0x2
	jnz enable_a20
	mov al,0xdf
	out 0x64,al
	
	; use lgdt load gdtr
	lgdt [gdt_48]
	 
	mov eax,cr0
	or eax,0x1
	mov cr0,eax
	
	jmp 0x08:0x0000

; si save logic address
read_sect:
	push ax	
	push dx
	push cx
	push bx

	mov ax,si
	xor dx,dx
	mov bx,18	

	div bx

	inc dx
	; sector number
	mov cl,dl
	; save quotient
	mov dl,al
	and al,1
	; head number
	mov dh,al

	; restore quotient
	mov al,dl
	shr al,1
	; cylinder number
	mov ch,al

	xor dl,dl
	pop bx
rp_read:
	mov ah,2
	mov al,1
	int 0x13
	;read sector content to es:bx memory
	jc rp_read

	pop cx
	pop dx
	pop ax
	ret
	
times 512-($-$$) db 0
	
