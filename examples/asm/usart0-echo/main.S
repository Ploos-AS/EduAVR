#include <avr/io.h>

.global main
.global usart0_ready

.equ UBRR_VALUE, 51

.section .text
main:
    ; 9600 baud at 8 MHz, asynchronous normal-speed mode.
    ldi r16, hi8(UBRR_VALUE)
    sts UBRR0H, r16
    ldi r16, lo8(UBRR_VALUE)
    sts UBRR0L, r16

    clr r16
    sts UCSR0A, r16

    ldi r16, _BV(RXEN0) | _BV(TXEN0)
    sts UCSR0B, r16

    ldi r16, _BV(UCSZ01) | _BV(UCSZ00)
    sts UCSR0C, r16
    rcall usart0_ready
    rjmp echo_loop

usart0_ready:
    ret

echo_loop:
wait_rx:
    lds r16, UCSR0A
    sbrs r16, RXC0
    rjmp wait_rx
    lds r17, UDR0

wait_tx:
    lds r16, UCSR0A
    sbrs r16, UDRE0
    rjmp wait_tx
    sts UDR0, r17
    rjmp echo_loop
