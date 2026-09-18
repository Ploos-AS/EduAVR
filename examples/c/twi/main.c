#include <avr/io.h>

void twi_ready(void) __attribute__((noinline, used));
void twi_ready(void) { __asm__ __volatile__("" ::: "memory"); }

static void twi_init(void)
{
    TWSR = 0;
    TWBR = 32;
    TWCR = _BV(TWEN);
}

int main(void)
{
    twi_init();
    twi_ready();
    for (;;) {
    }
}
