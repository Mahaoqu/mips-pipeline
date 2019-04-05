ifndef CROSS_COMPILE
    CROSS_COMPILE = mips-linux-gnu-
endif

CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
OBJECTS = inst_rom.o

export CROSS_COMPILE

all: inst_rom.bin

%.o: %.mips
	$(CC) -mips32 $< -o $@

inst_rom.om: ram.ld $(OBJECTS)
	$(LD) -T ram.ld $(OBJECTS) -o $@

inst_rom.bin: inst_rom.om
	$(OBJCOPY) --remove-section .reginfo \
	--remove-section .MIPS.abiflags -O verilog $< $@
    
clean:
	rm -f *.o *.om *.data *.bin