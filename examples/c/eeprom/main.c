#include <avr/eeprom.h>
#include <stdint.h>

volatile uint8_t eeprom_address;
volatile uint8_t eeprom_written;
volatile uint8_t eeprom_readback;

__attribute__((noinline))
void eeprom_ready(void)
{
    __asm__ volatile ("" ::: "memory");
}

int main(void)
{
    uint8_t *address = (uint8_t *)0x12;
    const uint8_t value = 0x5a;

    eeprom_address = 0x12;
    eeprom_written = value;
    eeprom_write_byte(address, value);
    eeprom_busy_wait();
    eeprom_readback = eeprom_read_byte(address);
    eeprom_ready();

    for (;;) {
    }
}
