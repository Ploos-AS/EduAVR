#include <avr/io.h>
#include <stdint.h>
#ifndef F_CPU
#define F_CPU 8000000UL
#endif
#define BAUD 9600UL
#define UBRR_VALUE ((F_CPU / (16UL * BAUD)) - 1UL)

void usart1_ready(void) __attribute__((noinline, used));
void usart1_ready(void) { __asm__ __volatile__("" ::: "memory"); }

int main(void)
{
    UBRR1H = (uint8_t)(UBRR_VALUE >> 8);
    UBRR1L = (uint8_t)UBRR_VALUE;
    UCSR1A = 0;
    UCSR1B = _BV(RXEN1) | _BV(TXEN1);
    UCSR1C = _BV(UCSZ11) | _BV(UCSZ10);
    usart1_ready();

    for (;;) {
        while (!(UCSR1A & _BV(RXC1))) { }
        uint8_t v = UDR1;
        while (!(UCSR1A & _BV(UDRE1))) { }
        UDR1 = v;
    }
}
