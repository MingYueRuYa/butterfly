unsigned int cursor_pos = 0;

void inline outb(int port,int data)
{
	__asm __volatile("outb %0,%w1"::"r"(data),"r"(port));
}

void set_cursor(unsigned int pos)
{
	outb(0x3d4,0x0e);
	outb(0x3d5,(cursor_pos>>8)&0xff);
	outb(0x3d4,0x0f);
	outb(0x3d5,cursor_pos&0xff);
}

void print_c(char c)
{
	char *show = 0xb8000 + (cursor_pos<<1);
	*show = c;
	cursor_pos++;
	set_cursor(cursor_pos);
}

void printk(const char *fmt)
{
	char *s = fmt;
	while(*s != '\0')
	{
		print_c(*s);
		s++;
	}
}
