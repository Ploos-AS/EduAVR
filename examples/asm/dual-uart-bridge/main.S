#include <avr/io.h>
.global main
.global dual_uart_bridge_ready
.equ UBRR_VALUE, 51
.section .text
main:
    ldi r16, hi8(UBRR_VALUE)
    sts UBRR0H,r16
    sts UBRR1H,r16
    ldi r16, lo8(UBRR_VALUE)
    sts UBRR0L,r16
    sts UBRR1L,r16
    clr r16
    sts UCSR0A,r16
    sts UCSR1A,r16
    ldi r16,_BV(RXEN0)|_BV(TXEN0)
    sts UCSR0B,r16
    ldi r16,_BV(UCSZ01)|_BV(UCSZ00)
    sts UCSR0C,r16
    ldi r16,_BV(RXEN1)|_BV(TXEN1)
    sts UCSR1B,r16
    ldi r16,_BV(UCSZ11)|_BV(UCSZ10)
    sts UCSR1C,r16
    rcall dual_uart_bridge_ready
loop:
    lds r16,UCSR0A
    sbrs r16,RXC0
    rjmp check1
    lds r17,UDR0
wait1:
    lds r16,UCSR1A
    sbrs r16,UDRE1
    rjmp wait1
    sts UDR1,r17
check1:
    lds r16,UCSR1A
    sbrs r16,RXC1
    rjmp loop
    lds r17,UDR1
wait0:
    lds r16,UCSR0A
    sbrs r16,UDRE0
    rjmp wait0
    sts UDR0,r17
    rjmp loop
dual_uart_bridge_ready:
    ret
