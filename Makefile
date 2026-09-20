MCU ?= atmega1284p
F_CPU ?= 8000000UL
CC := avr-gcc
OBJCOPY := avr-objcopy
OBJDUMP := avr-objdump
SIZE := avr-size

CFLAGS := -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -Wextra -Werror
LDFLAGS := -mmcu=$(MCU)

BUILD := build

.PHONY: all c asm gpio stack timers pwm usart bridge robust spi twi eeprom adc data shared budget optimize capstone analyze resource-gate disasm size check clean

all: c asm gpio stack timers pwm usart bridge robust spi twi eeprom adc data shared budget optimize capstone

$(BUILD):
	mkdir -p $(BUILD)

c: $(BUILD)/blink-c.hex
asm: $(BUILD)/blink-asm.hex

gpio: $(BUILD)/gpio-c.hex $(BUILD)/gpio-asm.hex

stack: $(BUILD)/stack-functions-c.hex $(BUILD)/stack-functions-asm.hex

timers: $(BUILD)/timer-isr-c.hex $(BUILD)/timer-isr-asm.hex

pwm: $(BUILD)/pwm-c.hex $(BUILD)/pwm-asm.hex

usart: $(BUILD)/usart0-echo-c.hex $(BUILD)/usart0-echo-asm.hex $(BUILD)/usart0-irq-ring-c.hex $(BUILD)/usart0-irq-ring-asm.hex $(BUILD)/usart1-echo-c.hex $(BUILD)/usart1-echo-asm.hex $(BUILD)/usart1-irq-ring-c.hex $(BUILD)/usart1-irq-ring-asm.hex

bridge: $(BUILD)/dual-uart-bridge-c.hex $(BUILD)/dual-uart-bridge-asm.hex $(BUILD)/dual-uart-irq-bridge-c.hex $(BUILD)/dual-uart-irq-bridge-asm.hex

robust: $(BUILD)/usart-robust-c.hex $(BUILD)/usart-robust-asm.hex

spi: $(BUILD)/spi-c.hex $(BUILD)/spi-asm.hex

twi: $(BUILD)/twi-c.hex $(BUILD)/twi-asm.hex

eeprom: $(BUILD)/eeprom-c.hex $(BUILD)/eeprom-asm.hex

adc: $(BUILD)/adc-c.hex $(BUILD)/adc-asm.hex

data: $(BUILD)/data-structures-c.hex $(BUILD)/data-structures-asm.hex

shared: $(BUILD)/shared-state-c.hex $(BUILD)/shared-state-asm.hex

budget: $(BUILD)/resource-budget-c.hex $(BUILD)/resource-budget-asm.hex

optimize: $(BUILD)/optimization-c-os.hex $(BUILD)/optimization-c-o0.hex $(BUILD)/optimization-c-o2.hex $(BUILD)/optimization-asm.hex

$(BUILD)/blink-c.elf: examples/c/blink/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/blink-asm.elf: examples/asm/blink/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/gpio-c.elf: examples/c/gpio/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/gpio-asm.elf: examples/asm/gpio/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/stack-functions-c.elf: examples/c/stack-functions/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/stack-functions-asm.elf: examples/asm/stack-functions/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/timer-isr-c.elf: examples/c/timer-isr/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/timer-isr-asm.elf: examples/asm/timer-isr/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/pwm-c.elf: examples/c/pwm/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/pwm-asm.elf: examples/asm/pwm/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart0-echo-c.elf: examples/c/usart0-echo/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart0-echo-asm.elf: examples/asm/usart0-echo/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart0-irq-ring-c.elf: examples/c/usart0-irq-ring/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart0-irq-ring-asm.elf: examples/asm/usart0-irq-ring/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart1-echo-c.elf: examples/c/usart1-echo/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart1-echo-asm.elf: examples/asm/usart1-echo/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart1-irq-ring-c.elf: examples/c/usart1-irq-ring/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart1-irq-ring-asm.elf: examples/asm/usart1-irq-ring/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/dual-uart-bridge-c.elf: examples/c/dual-uart-bridge/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/dual-uart-bridge-asm.elf: examples/asm/dual-uart-bridge/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/dual-uart-irq-bridge-c.elf: examples/c/dual-uart-irq-bridge/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/dual-uart-irq-bridge-asm.elf: examples/asm/dual-uart-irq-bridge/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart-robust-c.elf: examples/c/usart-robust/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/usart-robust-asm.elf: examples/asm/usart-robust/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/spi-c.elf: examples/c/spi/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/spi-asm.elf: examples/asm/spi/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/twi-c.elf: examples/c/twi/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/twi-asm.elf: examples/asm/twi/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/eeprom-c.elf: examples/c/eeprom/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/eeprom-asm.elf: examples/asm/eeprom/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/adc-c.elf: examples/c/adc/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/adc-asm.elf: examples/asm/adc/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/data-structures-c.elf: examples/c/data-structures/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/data-structures-asm.elf: examples/asm/data-structures/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/shared-state-c.elf: examples/c/shared-state/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/shared-state-asm.elf: examples/asm/shared-state/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/resource-budget-c.elf: examples/c/resource-budget/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/resource-budget-asm.elf: examples/asm/resource-budget/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/capstone-c.elf: examples/c/capstone/main.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/capstone-asm.elf: examples/asm/capstone/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/optimization-c-os.elf: examples/c/optimization/main.c | $(BUILD)
	$(CC) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -Wextra -Werror $< -o $@

$(BUILD)/optimization-c-o0.elf: examples/c/optimization/main.c | $(BUILD)
	$(CC) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -O0 -Wall -Wextra -Werror $< -o $@

$(BUILD)/optimization-c-o2.elf: examples/c/optimization/main.c | $(BUILD)
	$(CC) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -O2 -Wall -Wextra -Werror $< -o $@

$(BUILD)/optimization-asm.elf: examples/asm/optimization/main.S | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/%.hex: $(BUILD)/%.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

disasm: all
	$(OBJDUMP) -d -S $(BUILD)/blink-c.elf > $(BUILD)/blink-c.lst
	$(OBJDUMP) -d -S $(BUILD)/blink-asm.elf > $(BUILD)/blink-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/gpio-c.elf > $(BUILD)/gpio-c.lst
	$(OBJDUMP) -d -S $(BUILD)/gpio-asm.elf > $(BUILD)/gpio-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/stack-functions-c.elf > $(BUILD)/stack-functions-c.lst
	$(OBJDUMP) -d -S $(BUILD)/stack-functions-asm.elf > $(BUILD)/stack-functions-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/timer-isr-c.elf > $(BUILD)/timer-isr-c.lst
	$(OBJDUMP) -d -S $(BUILD)/timer-isr-asm.elf > $(BUILD)/timer-isr-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/pwm-c.elf > $(BUILD)/pwm-c.lst
	$(OBJDUMP) -d -S $(BUILD)/pwm-asm.elf > $(BUILD)/pwm-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/usart0-echo-c.elf > $(BUILD)/usart0-echo-c.lst
	$(OBJDUMP) -d -S $(BUILD)/usart0-echo-asm.elf > $(BUILD)/usart0-echo-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/usart0-irq-ring-c.elf > $(BUILD)/usart0-irq-ring-c.lst
	$(OBJDUMP) -d -S $(BUILD)/usart0-irq-ring-asm.elf > $(BUILD)/usart0-irq-ring-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/usart1-echo-c.elf > $(BUILD)/usart1-echo-c.lst
	$(OBJDUMP) -d -S $(BUILD)/usart1-echo-asm.elf > $(BUILD)/usart1-echo-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/usart1-irq-ring-c.elf > $(BUILD)/usart1-irq-ring-c.lst
	$(OBJDUMP) -d -S $(BUILD)/usart1-irq-ring-asm.elf > $(BUILD)/usart1-irq-ring-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/spi-c.elf > $(BUILD)/spi-c.lst
	$(OBJDUMP) -d -S $(BUILD)/spi-asm.elf > $(BUILD)/spi-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/twi-c.elf > $(BUILD)/twi-c.lst
	$(OBJDUMP) -d -S $(BUILD)/twi-asm.elf > $(BUILD)/twi-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/eeprom-c.elf > $(BUILD)/eeprom-c.lst
	$(OBJDUMP) -d -S $(BUILD)/eeprom-asm.elf > $(BUILD)/eeprom-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/adc-c.elf > $(BUILD)/adc-c.lst
	$(OBJDUMP) -d -S $(BUILD)/adc-asm.elf > $(BUILD)/adc-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/data-structures-c.elf > $(BUILD)/data-structures-c.lst
	$(OBJDUMP) -d -S $(BUILD)/data-structures-asm.elf > $(BUILD)/data-structures-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/shared-state-c.elf > $(BUILD)/shared-state-c.lst
	$(OBJDUMP) -d -S $(BUILD)/shared-state-asm.elf > $(BUILD)/shared-state-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/resource-budget-c.elf > $(BUILD)/resource-budget-c.lst
	$(OBJDUMP) -d -S $(BUILD)/resource-budget-asm.elf > $(BUILD)/resource-budget-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/optimization-c-os.elf > $(BUILD)/optimization-c-os.lst
	$(OBJDUMP) -d -S $(BUILD)/optimization-c-o0.elf > $(BUILD)/optimization-c-o0.lst
	$(OBJDUMP) -d -S $(BUILD)/optimization-c-o2.elf > $(BUILD)/optimization-c-o2.lst
	$(OBJDUMP) -d -S $(BUILD)/optimization-asm.elf > $(BUILD)/optimization-asm.lst
	$(OBJDUMP) -d -S $(BUILD)/capstone-c.elf > $(BUILD)/capstone-c.lst
	$(OBJDUMP) -d -S $(BUILD)/capstone-asm.elf > $(BUILD)/capstone-asm.lst

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
