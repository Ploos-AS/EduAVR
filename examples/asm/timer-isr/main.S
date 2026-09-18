#include <avr/io.h>

.global main
.global TIMER0_COMPA_vect
.global timer0_compa_probe

.section .bss
timer_events:
    .byte 1

.section .text

main:
    ; Timer0 CTC.
    ldi r16, _BV(WGM01)
    out _SFR_IO_ADDR(TCCR0A), r16

    ; Compare every 125 ticks.
    ldi r16, 124
    out _SFR_IO_ADDR(OCR0A), r16

    ; Enable Timer0 compare A interrupt.
    ldi r16, _BV(OCIE0A)
    sts TIMSK0, r16

    ; Clock / 64.
    ldi r16, _BV(CS01) | _BV(CS00)
    out _SFR_IO_ADDR(TCCR0B), r16

    sei

loop:
    lds r16, timer_events
    cpi r16, 10
    brne loop
    clr r16
    sts timer_events, r16
    rjmp loop

TIMER0_COMPA_vect:
    rjmp timer0_compa_probe

timer0_compa_probe:
    push r16
    in r16, _SFR_IO_ADDR(SREG)
    push r16

    lds r16, timer_events
    inc r16
    sts timer_events, r16

    pop r16
    out _SFR_IO_ADDR(SREG), r16
    pop r16
    reti
