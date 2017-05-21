[bits 16]
pm_mode:
	jmp code
;׼��GDT
gdt:
;����������
dw 0x0000,0x0000,0x0000,0x0000
;0��4GB�Ĵ����
dw 0xffff,0x0000,0x9a00,0x00cf
;0��4GB�����ݶ�
dw 0xffff,0x0000,0x9200,0x00cf

gdt_48:
	dw 23
	dd 0x50000

code:
	;��ʼ��
	xor ax,ax
	mov ds,ax
	mov es,ax
	
	;��kernel��0�Ŵ�ͷ��0�����桢3���������ص��ڴ�0x6000
	mov ax,0x600
	mov es,ax
	xor bx,bx
	
	mov ch,0
	mov cl,3
	mov dh,0
	mov dl,0
rp_read:	
	mov ah,2
	mov al,1
	int 0x13
	jc rp_read
	
	;���ж�
	cli
	
	
	;move GDT to 0x50000 ds:si ---->es:di
	xor ax,ax
	mov ds,ax
	mov ax,0x5000
	mov es,ax
	mov si,gdt
	xor di,di
	mov cx,24>>2
	rep
	movsd
	
	
;���뱣��ģʽ
	;��A20
enable_a20:
	in al,0x64
	test al,0x2
	jnz enable_a20
	mov al,0xdf
	out 0x64,al
	
	;��lgdt����gdtr
	lgdt [gdt_48]
	
	;��cr0��PEλ
	mov eax,cr0
	or eax,0x1
	mov cr0,eax

	;jmp
	jmp 0x08:0x6000
	
times 512-($-$$) db 0