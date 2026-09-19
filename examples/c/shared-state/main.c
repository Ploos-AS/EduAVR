#include <avr/interrupt.h>
#include <avr/io.h>
#include <stdint.h>

volatile uint8_t shared_ticks;
volatile uint16_t shared_word;
volatile uint8_t snapshot_low;
volatile uint8_t snapshot_high;
volatile uint8_t snapshot_ticks;

void shared_state_ready(void) __attribute__((noinline, used));
void shared_state_ready(void) { __asm__ __volatile__("" ::: "memory"); }

ISR(TIMER0_COMPA_vect)
{
    ++shared_ticks;
    shared_word = (uint16_t)(shared_word + 0x0101u);
}

int main(void)
{
    TCCR0A = _BV(WGM01);
    OCR0A = 124;
    TCCR0B = _BV(CS01) | _BV(CS00);
    TIMSK0 = _BV(OCIE0A);
    sei();

    while (shared_ticks < 3) {
    }

    /* A 16-bit object is wider than the 8-bit CPU. Take an atomic snapshot. */
    uint8_t sreg = SREG;
    cli();
    uint16_t word = shared_word;
    uint8_t ticks = shared_ticks;
    SREG = sreg;

    snapshot_low = (uint8_t)word;
    snapshot_high = (uint8_t)(word >> 8);
    snapshot_ticks = ticks;
    shared_state_ready();

    for (;;) {
    }
}
