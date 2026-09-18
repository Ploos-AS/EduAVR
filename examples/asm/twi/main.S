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

    ; START
    ldi r16, _BV(TWINT) | _BV(TWSTA) | _BV(TWEN)
    sts TWCR, r16
    rcall twi_wait

    ; EEPROM address 0x50, write direction => 0xa0
    ldi r17, 0xa0
    rcall twi_write

    ; Byte address 0x10.
    ldi r17, 0x10
    rcall twi_write

    ; Payload 0x55.
    ldi r17, 0x55
    rcall twi_write

    ; STOP
    ldi r16, _BV(TWINT) | _BV(TWSTO) | _BV(TWEN)
    sts TWCR, r16

twi_idle:
    rjmp twi_idle

twi_ready:
    ret

twi_wait:
    lds r16, TWCR
    sbrs r16, TWINT
    rjmp twi_wait
    ret

twi_write:
    sts TWDR, r17
    ldi r16, _BV(TWINT) | _BV(TWEN)
    sts TWCR, r16
    rcall twi_wait
    ret
