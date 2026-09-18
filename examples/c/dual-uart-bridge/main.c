#include <avr/io.h>
#include <stdint.h>
#ifndef F_CPU
#define F_CPU 8000000UL
#endif
#define BAUD 9600UL
#define UBRR_VALUE ((F_CPU / (16UL * BAUD)) - 1UL)

void dual_uart_bridge_ready(void) __attribute__((noinline, used));
void dual_uart_bridge_ready(void) { __asm__ __volatile__("" ::: "memory"); }

static void uart_init(void) {
    UBRR0H=(uint8_t)(UBRR_VALUE>>8); UBRR0L=(uint8_t)UBRR_VALUE;
    UCSR0A=0; UCSR0B=_BV(RXEN0)|_BV(TXEN0); UCSR0C=_BV(UCSZ01)|_BV(UCSZ00);
    UBRR1H=(uint8_t)(UBRR_VALUE>>8); UBRR1L=(uint8_t)UBRR_VALUE;
    UCSR1A=0; UCSR1B=_BV(RXEN1)|_BV(TXEN1); UCSR1C=_BV(UCSZ11)|_BV(UCSZ10);
}
int main(void) {
    uart_init(); dual_uart_bridge_ready();
    for (;;) {
        if (UCSR0A & _BV(RXC0)) {
            uint8_t v=UDR0; while (!(UCSR1A & _BV(UDRE1))) {} UDR1=v;
        }
        if (UCSR1A & _BV(RXC1)) {
            uint8_t v=UDR1; while (!(UCSR0A & _BV(UDRE0))) {} UDR0=v;
        }
    }
}
