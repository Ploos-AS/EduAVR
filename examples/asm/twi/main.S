#include <avr/io.h>

.global main
.global twi_ready

.section .text
main:
    clr r16
    sts TWSR, r16

    ldi r16, 32
    sts TWBR, r16

    ldi r16, _BV(TWEN)
    sts TWCR, r16

    rcall twi_ready
    rjmp twi_idle

twi_ready:
    ret

twi_idle:
    rjmp twi_idle
