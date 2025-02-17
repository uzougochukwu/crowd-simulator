build:
	nasm -felf64 -gdwarf ./src/*.asm -o ./src/game.o
	ld ./src/game.o -o game
run:
	./game
clean:
	rm game
