#include <avr/interrupt.h>
#include <avr/io.h>
#include <stdint.h>

volatile uint8_t timer_events;

void timer0_compa_probe(void) __attribute__((noinline, used));
void timer0_compa_probe(void) { __asm__ __volatile__("" ::: "memory"); }

ISR(TIMER0_COMPA_vect)
{
    timer0_compa_probe();
    ++timer_events;
}

int main(void)
{
    /* Timer0 CTC, compare every 125 ticks at 8 MHz / 64 = 125 kHz. */
    TCCR0A = _BV(WGM01);
    OCR0A = 124;
    TCCR0B = _BV(CS01) | _BV(CS00);
    TIMSK0 = _BV(OCIE0A);

    sei();

    for (;;) {
        /* Deliberately observable state for simulator/debugger labs. */
        if (timer_events == 10) {
            timer_events = 0;
        }
    }
}
