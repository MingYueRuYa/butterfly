CFLAGS = -Wall -pedantic -W -nostdlib -nostdinc -Wno-long-long -fomit-frame-pointer

all:butterfly.img

boot_sector.o: boot_sector.asm
	nasm -f elf -o $@ $<

loader.o: loader.asm
	nasm -f elf -o $@ $<

kernel.o: kernel.asm
	nasm -f elf -o $@ $<

butterfly.img: boot_sector loader kernel
	cat boot_setctor loader kernel > butterfly.img

boot_sector: boot_sector.o
	ld --oformat binary -N -e boot -Ttext 0x7c00 -o boot_sector $<

loader: loader.o
	ld --oformat binary -N -e pm_mode -Ttext 0x8000 -o loader $<

kernel: kernel.o init.o
	ld --oformat binary -N -e start -Ttext 0x6000 -o kernel kernel.o init.o

*.o: *.c
	gcc $(CFLAGS) -Os -c -o $@ $<

clean:
	rm -vf *.img boot_sector loader kernel *.o	
	
