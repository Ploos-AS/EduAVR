#include <avr/io.h>

.global main
main:
    sbi _SFR_IO_ADDR(DDRB), DDB0

loop:
    sbi _SFR_IO_ADDR(PINB), PINB0

    ldi r18, 41
delay_outer:
    ldi r24, 0xff
    ldi r25, 0xff
delay_inner:
    sbiw r24, 1
    brne delay_inner
    dec r18
    brne delay_outer
    rjmp loop
