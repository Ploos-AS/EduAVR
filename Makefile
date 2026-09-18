MCU ?= atmega1284p
F_CPU ?= 8000000UL
CC := avr-gcc
OBJCOPY := avr-objcopy
OBJDUMP := avr-objdump
SIZE := avr-size

CFLAGS := -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -Wextra -Werror
LDFLAGS := -mmcu=$(MCU)

BUILD := build

.PHONY: all c asm disasm size check clean

all: c asm

$(BUILD):
	mkdir -p $(BUILD)

c: $(BUILD)/blink-c.hex
asm: $(BUILD)/blink-asm.hex

$(BUILD)/blink-c.elf: examples/c/blink/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/blink-asm.elf: examples/asm/blink/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/%.hex: $(BUILD)/%.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

disasm: all
	$(OBJDUMP) -d -S $(BUILD)/blink-c.elf > $(BUILD)/blink-c.lst
	$(OBJDUMP) -d -S $(BUILD)/blink-asm.elf > $(BUILD)/blink-asm.lst

size: all
	$(SIZE) -C --mcu=$(MCU) $(BUILD)/*.elf

check:
	@command -v $(CC)
	@command -v $(OBJCOPY)
	@command -v $(OBJDUMP)
	@command -v $(SIZE)
	@command -v avrdude
	@$(CC) --version | head -1
	@avrdude --version 2>&1 | head -1
	$(MAKE) clean all disasm size

clean:
	rm -rf $(BUILD)
