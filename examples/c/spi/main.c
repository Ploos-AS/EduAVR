#include <avr/io.h>
#include <stdint.h>

void spi_ready(void) __attribute__((noinline, used));
void spi_ready(void) { __asm__ __volatile__("" ::: "memory"); }

static void spi_init(void)
{
    DDRB |= _BV(DDB4) | _BV(DDB5) | _BV(DDB7);
    DDRB &= (uint8_t)~_BV(DDB6);
    SPCR = _BV(SPE) | _BV(MSTR) | _BV(SPR0);
    SPSR = 0;
}

static uint8_t spi_transfer(uint8_t value)
{
    SPDR = value;
    while (!(SPSR & _BV(SPIF))) {
    }
    return SPDR;
}

int main(void)
{
    spi_init();
    spi_ready();
    for (;;) {
        (void)spi_transfer(0x55);
    }
}
