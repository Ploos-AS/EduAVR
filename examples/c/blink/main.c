#include <avr/io.h>
#include <util/delay.h>

#ifndef F_CPU
#define F_CPU 8000000UL
#endif

int main(void)
{
    DDRB |= _BV(DDB0);

    for (;;) {
        PORTB ^= _BV(PORTB0);
        _delay_ms(500);
    }
}
