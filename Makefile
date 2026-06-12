NASM       = nasm
LD         = ld
NASM_FLAGS = -f elf32
LD_FLAGS   = -m elf_i386

.PHONY: all clean

all: calc

calc: calc.o
	$(LD) $(LD_FLAGS) $< -o $@

calc.o: calc.asm
	$(NASM) $(NASM_FLAGS) $< -o $@

clean:
	rm -f *.o calc
