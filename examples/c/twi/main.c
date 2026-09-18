#include <avr/io.h>
#include <util/twi.h>

void twi_ready(void) __attribute__((noinline, used));
void twi_ready(void) { __asm__ __volatile__("" ::: "memory"); }

static void twi_init(void)
{
    TWSR = 0;
    TWBR = 32;
    TWCR = _BV(TWEN);
}

static void twi_wait(void)
{
    while (!(TWCR & _BV(TWINT))) {
    }
}

static void twi_start(void)
{
    TWCR = _BV(TWINT) | _BV(TWSTA) | _BV(TWEN);
    twi_wait();
}

static void twi_write(unsigned char value)
{
    TWDR = value;
    TWCR = _BV(TWINT) | _BV(TWEN);
    twi_wait();
}

static void twi_stop(void)
{
    TWCR = _BV(TWINT) | _BV(TWSTO) | _BV(TWEN);
}

/* Q1 transaction: write 0x55 to byte address 0x10 of a virtual 0x50 EEPROM. */
static void twi_demo_transaction(void)
{
    twi_start();
    twi_write((0x50u << 1) | TW_WRITE);
    twi_write(0x10);
    twi_write(0x55);
    twi_stop();
}

int main(void)
{
    twi_init();
    twi_ready();
    twi_demo_transaction();
    for (;;) {
    }
}
