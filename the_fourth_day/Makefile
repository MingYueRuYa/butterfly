CFLAGS = -Wall -pedantic -W -nostdlib -nostdinc -Wno-long-long -fomit-frame-pointer

all:butterfly.img

bootsect.o: bootsect.asm
	nasm -f elf -o $@ $<

loader.o: loader.asm
	nasm -f elf -o $@ $<

kernel.o: kernel.asm
	nasm -f elf -o $@ $<

butterfly.img: bootsect loader kernel
	cat bootsect loader kernel > butterfly.img

bootsect: bootsect.o
	ld --oformat binary -N -e boot -Ttext 0x7c00 -o bootsect $<

loader: loader.o
	ld --oformat binary -N -e pm_mode -Ttext 0x7e00 -o loader $<

kernel: kernel.o init.o printk.o
	ld --oformat binary -N -e start -Ttext 0x0000 -o kernel kernel.o init.o printk.o

*.o: *.c
	gcc $(CFLAGS) -Os -c -o $@ $<

clean:
	rm -vf *.img bootsect loader kernel *.o	
	
