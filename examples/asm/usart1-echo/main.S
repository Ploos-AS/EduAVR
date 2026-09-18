#include <avr/io.h>

.global main
.global usart1_ready
.equ UBRR_VALUE, 51

.section .text
main:
    ldi r16, hi8(UBRR_VALUE)
    sts UBRR1H, r16
    ldi r16, lo8(UBRR_VALUE)
    sts UBRR1L, r16
    clr r16
    sts UCSR1A, r16
    ldi r16, _BV(RXEN1) | _BV(TXEN1)
    sts UCSR1B, r16
    ldi r16, _BV(UCSZ11) | _BV(UCSZ10)
    sts UCSR1C, r16
    rcall usart1_ready

echo_loop:
rx_wait:
    lds r16, UCSR1A
    sbrs r16, RXC1
    rjmp rx_wait
    lds r17, UDR1
tx_wait:
    lds r16, UCSR1A
    sbrs r16, UDRE1
    rjmp tx_wait
    sts UDR1, r17
    rjmp echo_loop

usart1_ready:
    ret
