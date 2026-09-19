#include <avr/io.h>

.section .bss
.global shared_ticks
shared_ticks: .byte 1
.global shared_word
shared_word: .byte 2
.global snapshot_low
snapshot_low: .byte 1
.global snapshot_high
snapshot_high: .byte 1
.global snapshot_ticks
snapshot_ticks: .byte 1

.section .text
.global main
.global TIMER0_COMPA_vect
.global shared_state_ready

main:
    ldi r16, _BV(WGM01)
    out _SFR_IO_ADDR(TCCR0A), r16
    ldi r16, 124
    out _SFR_IO_ADDR(OCR0A), r16
    ldi r16, _BV(OCIE0A)
    sts TIMSK0, r16
    ldi r16, _BV(CS01) | _BV(CS00)
    out _SFR_IO_ADDR(TCCR0B), r16
    sei

1:
    lds r16, shared_ticks
    cpi r16, 3
    brlo 1b

    ; Preserve interrupt state and take one coherent multi-byte snapshot.
    in r18, _SFR_IO_ADDR(SREG)
    cli
    lds r20, shared_word
    lds r21, shared_word+1
    lds r22, shared_ticks
    out _SFR_IO_ADDR(SREG), r18

    sts snapshot_low, r20
    sts snapshot_high, r21
    sts snapshot_ticks, r22
    call shared_state_ready
2:
    rjmp 2b

TIMER0_COMPA_vect:
    push r16
    push r17
    in r16, _SFR_IO_ADDR(SREG)
    push r16

    lds r16, shared_ticks
    inc r16
    sts shared_ticks, r16

    lds r16, shared_word
    lds r17, shared_word+1
    subi r16, lo8(-(0x0101))
    sbci r17, hi8(-(0x0101))
    sts shared_word, r16
    sts shared_word+1, r17

    pop r16
    out _SFR_IO_ADDR(SREG), r16
    pop r17
    pop r16
    reti

shared_state_ready:
    ret
