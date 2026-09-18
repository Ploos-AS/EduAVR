#include <avr/io.h>
#include <stdint.h>

#ifndef F_CPU
#define F_CPU 8000000UL
#endif

#define BAUD 9600UL
#define UBRR_VALUE ((F_CPU / (16UL * BAUD)) - 1UL)

static void usart0_init(void)
{
    UBRR0H = (uint8_t)(UBRR_VALUE >> 8);
    UBRR0L = (uint8_t)UBRR_VALUE;
    UCSR0A = 0;
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);
    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00);
}

static uint8_t usart0_getc(void)
{
    while (!(UCSR0A & _BV(RXC0))) {
    }
    return UDR0;
}

static void usart0_putc(uint8_t value)
{
    while (!(UCSR0A & _BV(UDRE0))) {
    }
    UDR0 = value;
}

int main(void)
{
    usart0_init();

    for (;;) {
        usart0_putc(usart0_getc());
    }
}
