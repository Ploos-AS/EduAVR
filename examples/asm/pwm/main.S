#include <avr/io.h>

.global main
.global pwm_ready

.section .text
main:
    ; OC0A is PB3 on ATmega1284P.
    sbi _SFR_IO_ADDR(DDRB), DDB3

    ; Fast PWM, non-inverting OC0A, TOP=0xff.
    ldi r16, _BV(COM0A1) | _BV(WGM01) | _BV(WGM00)
    out _SFR_IO_ADDR(TCCR0A), r16

    ; About 25% duty cycle.
    ldi r16, 63
    out _SFR_IO_ADDR(OCR0A), r16

    ; Start Timer0 with clk/64.
    ldi r16, _BV(CS01) | _BV(CS00)
    out _SFR_IO_ADDR(TCCR0B), r16

loop:
    rjmp loop
