#include <avr/interrupt.h>
#include <avr/io.h>
#include <stdint.h>

#ifndef F_CPU
#define F_CPU 8000000UL
#endif
#define BAUD 9600UL
#define UBRR_VALUE ((F_CPU / (16UL * BAUD)) - 1UL)
#define RB_SIZE 16
#define RB_MASK (RB_SIZE - 1)

static volatile uint8_t rx_buf[RB_SIZE], tx_buf[RB_SIZE];
static volatile uint8_t rx_head, rx_tail, tx_head, tx_tail;

ISR(USART0_RX_vect)
{
    uint8_t next = (rx_head + 1) & RB_MASK;
    uint8_t v = UDR0;
    if (next != rx_tail) { rx_buf[rx_head] = v; rx_head = next; }
}

ISR(USART0_UDRE_vect)
{
    if (tx_tail == tx_head) {
        UCSR0B &= (uint8_t)~_BV(UDRIE0);
    } else {
        UDR0 = tx_buf[tx_tail];
        tx_tail = (tx_tail + 1) & RB_MASK;
    }
}

static void usart0_init(void)
{
    UBRR0H = (uint8_t)(UBRR_VALUE >> 8);
    UBRR0L = (uint8_t)UBRR_VALUE;
    UCSR0A = 0;
    UCSR0B = _BV(RXEN0) | _BV(TXEN0) | _BV(RXCIE0);
    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00);
}

static uint8_t rx_get(uint8_t *v)
{
    if (rx_tail == rx_head) return 0;
    *v = rx_buf[rx_tail];
    rx_tail = (rx_tail + 1) & RB_MASK;
    return 1;
}

static uint8_t tx_put(uint8_t v)
{
    uint8_t next = (tx_head + 1) & RB_MASK;
    if (next == tx_tail) return 0;
    tx_buf[tx_head] = v;
    tx_head = next;
    UCSR0B |= _BV(UDRIE0);
    return 1;
}

void usart0_irq_ready(void) __attribute__((noinline, used));
void usart0_irq_ready(void) { __asm__ __volatile__("" ::: "memory"); }

int main(void)
{
    uint8_t v;
    usart0_init();
    sei();
    usart0_irq_ready();
    for (;;) {
        if (rx_get(&v)) while (!tx_put(v)) { }
    }
}
