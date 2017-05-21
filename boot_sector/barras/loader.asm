[bits 16]
pm_mode:
	jmp code
;准备GDT
gdt:
;创建三个段
dw 0x0000,0x0000,0x0000,0x0000
;0到4GB的代码段
dw 0xffff,0x0000,0x9a00,0x00cf
;0到4GB的数据段
dw 0xffff,0x0000,0x9200,0x00cf

gdt_48:
	dw 23
	dd 0x50000

code:
	;初始化
	xor ax,ax
	mov ds,ax
	mov es,ax
	
	;把kernel从0号磁头、0号柱面、3号扇区加载到内存0x6000
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
	
	;关中断
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
	
	
;进入保护模式
	;打开A20
enable_a20:
	in al,0x64
	test al,0x2
	jnz enable_a20
	mov al,0xdf
	out 0x64,al
	
	;用lgdt加载gdtr
	lgdt [gdt_48]
	
	;置cr0的PE位
	mov eax,cr0
	or eax,0x1
	mov cr0,eax

	;jmp
	jmp 0x08:0x6000
	
times 512-($-$$) db 0