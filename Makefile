AS = nasm
LD = ld
ASFLAGS = -f elf64

ttt86: ttt86.o
	$(LD) ttt86.o -o ttt86

ttt86.o: ttt86.asm
	$(AS) $(ASFLAGS) ttt86.asm -o ttt86.o

run: ttt86
	./ttt86

clean:
	rm -f ttt86.o
