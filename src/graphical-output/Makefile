build:
	nasm -felf64 -gdwarf -I/ src/*.asm -o binary.o
	ld binary.o -o binary

run:
	./binary

clean:
	rm binary
