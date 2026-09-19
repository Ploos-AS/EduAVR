#include <avr/io.h>

.section .bss
.global adc_result
adc_result: .skip 2

.section .text
.global adc_ready
.type adc_ready, @function
adc_ready:
    ret
.size adc_ready, .-adc_ready

.global main
.type main, @function
main:
    ; ADC0, AVCC reference, right-adjusted result.
    ldi r16, _BV(REFS0)
    sts ADMUX, r16

    ; Enable ADC, prescaler /64: 8 MHz / 64 = 125 kHz ADC clock.
    ldi r16, _BV(ADEN) | _BV(ADPS2) | _BV(ADPS1)
    sts ADCSRA, r16

    ; Start one conversion.
    ori r16, _BV(ADSC)
    sts ADCSRA, r16
1:
    lds r16, ADCSRA
    sbrc r16, ADSC
    rjmp 1b

    ; Read ADCL before ADCH as required by the AVR ADC interface.
    lds r18, ADCL
    lds r19, ADCH
    sts adc_result, r18
    sts adc_result+1, r19

    call adc_ready
2:
    rjmp 2b
.size main, .-main
