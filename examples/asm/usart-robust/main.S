#include <avr/io.h>
.global main
.global uart_robust_ready
.global uart0_rx_bytes
.global uart0_tx_bytes
.global uart0_frame_errors
.global uart0_overrun_errors
.global uart0_parity_errors
.equ UBRR_VALUE,51
.section .bss
uart0_rx_bytes:.skip 2
uart0_tx_bytes:.skip 2
uart0_frame_errors:.skip 2
uart0_overrun_errors:.skip 2
uart0_parity_errors:.skip 2
uart0_dropped_bytes:.skip 2
.section .text
main:
 ldi r16,hi8(UBRR_VALUE)
 sts UBRR0H,r16
 ldi r16,lo8(UBRR_VALUE)
 sts UBRR0L,r16
 clr r16
 sts UCSR0A,r16
 ldi r16,_BV(RXEN0)|_BV(TXEN0)
 sts UCSR0B,r16
 ldi r16,_BV(UCSZ01)|_BV(UCSZ00)
 sts UCSR0C,r16
 rcall uart_robust_ready
loop:
 lds r16,UCSR0A
 sbrs r16,RXC0
 rjmp loop
 lds r17,UDR0
 rcall inc_rx
 sbrc r16,FE0
 rcall inc_fe
 sbrc r16,DOR0
 rcall inc_dor
 sbrc r16,UPE0
 rcall inc_upe
txwait:
 lds r18,UCSR0A
 sbrs r18,UDRE0
 rjmp txwait
 sts UDR0,r17
 rcall inc_tx
 rjmp loop
uart_robust_ready: ret
inc_rx:
 ldi ZL,lo8(uart0_rx_bytes)
 ldi ZH,hi8(uart0_rx_bytes)
 rjmp inc16
inc_tx:
 ldi ZL,lo8(uart0_tx_bytes)
 ldi ZH,hi8(uart0_tx_bytes)
 rjmp inc16
inc_fe:
 ldi ZL,lo8(uart0_frame_errors)
 ldi ZH,hi8(uart0_frame_errors)
 rjmp inc16
inc_dor:
 ldi ZL,lo8(uart0_overrun_errors)
 ldi ZH,hi8(uart0_overrun_errors)
 rjmp inc16
inc_upe:
 ldi ZL,lo8(uart0_parity_errors)
 ldi ZH,hi8(uart0_parity_errors)
inc16:
 ld r24,Z
 ldd r25,Z+1
 adiw r24,1
 st Z,r24
 std Z+1,r25
 ret
