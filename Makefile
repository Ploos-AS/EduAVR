MCU ?= atmega1284p
F_CPU ?= 8000000UL
CC := avr-gcc
OBJCOPY := avr-objcopy
OBJDUMP := avr-objdump
SIZE := avr-size

CFLAGS := -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -Wextra -Werror
LDFLAGS := -mmcu=$(MCU)

BUILD := build

.PHONY: all c asm timers pwm disasm size check clean

all: c asm timers pwm

$(BUILD):
	mkdir -p $(BUILD)

c: $(BUILD)/blink-c.hex
asm: $(BUILD)/blink-asm.hex

timers: $(BUILD)/timer-isr-c.hex $(BUILD)/timer-isr-asm.hex

pwm: $(BUILD)/pwm-c.hex $(BUILD)/pwm-asm.hex

$(BUILD)/blink-c.elf: examples/c/blink/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/blink-asm.elf: examples/asm/blink/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/timer-isr-c.elf: examples/c/timer-isr/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/timer-isr-asm.elf: examples/asm/timer-isr/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/pwm-c.elf: examples/c/pwm/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/pwm-asm.elf: examples/asm/pwm/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/%.hex: $(BUILD)/%.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

disasm: all
	$(OBJDUMP) -d -S $(BUILD)/blink-c.elf > $(BUILD)/blink-c.lst
	$(OBJDUMP) -d -S $(BUILD)/blink-asm.elf > $(BUILD)/blink-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/timer-isr-c.elf > $(BUILD)/timer-isr-c.lst
	$(OBJDUMP) -d -S $(BUILD)/timer-isr-asm.elf > $(BUILD)/timer-isr-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/pwm-c.elf > $(BUILD)/pwm-c.lst
	$(OBJDUMP) -d -S $(BUILD)/pwm-asm.elf > $(BUILD)/pwm-asm.lst

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
