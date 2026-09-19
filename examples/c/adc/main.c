#include <avr/io.h>
#include <stdint.h>

volatile uint16_t adc_result;

__attribute__((noinline))
void adc_ready(void)
{
    __asm__ volatile ("" ::: "memory");
}

int main(void)
{
    /* ADC0, AVCC reference, right-adjusted result. */
    ADMUX = _BV(REFS0);

    /* Enable ADC, prescaler /64: 8 MHz / 64 = 125 kHz ADC clock. */
    ADCSRA = _BV(ADEN) | _BV(ADPS2) | _BV(ADPS1);

    /* Start one conversion and wait for completion. */
    ADCSRA |= _BV(ADSC);
    while (ADCSRA & _BV(ADSC)) {
    }

    adc_result = ADC;
    adc_ready();

    for (;;) {
    }
}
