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

ISR(USART1_RX_vect)
{
    uint8_t next = (rx_head + 1) & RB_MASK;
    uint8_t v = UDR1;
    if (next != rx_tail) { rx_buf[rx_head] = v; rx_head = next; }
}

ISR(USART1_UDRE_vect)
{
    if (tx_tail == tx_head) {
        UCSR1B &= (uint8_t)~_BV(UDRIE1);
    } else {
        UDR1 = tx_buf[tx_tail];
        tx_tail = (tx_tail + 1) & RB_MASK;
    }
}

static void usart1_init(void)
{
    UBRR1H = (uint8_t)(UBRR_VALUE >> 8);
    UBRR1L = (uint8_t)UBRR_VALUE;
    UCSR1A = 0;
    UCSR1B = _BV(RXEN1) | _BV(TXEN1) | _BV(RXCIE1);
    UCSR1C = _BV(UCSZ11) | _BV(UCSZ10);
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
    UCSR1B |= _BV(UDRIE1);
    return 1;
}

void usart1_irq_ready(void) __attribute__((noinline, used));
void usart1_irq_ready(void) { __asm__ __volatile__("" ::: "memory"); }

int main(void)
{
    uint8_t v;
    usart1_init();
    sei();
    usart1_irq_ready();
    for (;;) {
        if (rx_get(&v)) while (!tx_put(v)) { }
    }
}
