#include <avr/io.h>

.global gpio_ready
.type gpio_ready, @function
gpio_ready:
    ret
.size gpio_ready, .-gpio_ready

.global main
.type main, @function
main:
    ; PB0 output; PB1 input with internal pull-up enabled.
    ldi r18, _BV(DDB0)
    out _SFR_IO_ADDR(DDRB), r18
    ldi r18, _BV(PORTB1)
    out _SFR_IO_ADDR(PORTB), r18
    call gpio_ready
1:
    rjmp 1b
.size main, .-main
