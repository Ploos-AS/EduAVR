#include <avr/io.h>
.global main
.global dual_uart_irq_ready
.equ UBRR_VALUE,51
.equ RB_MASK,31
.section .bss
rx0: .skip 32
rx1: .skip 32
tx0: .skip 32
tx1: .skip 32
rx0h:.skip 1
rx0t:.skip 1
rx1h:.skip 1
rx1t:.skip 1
tx0h:.skip 1
tx0t:.skip 1
tx1h:.skip 1
tx1t:.skip 1
.section .text
.global __vector_20
.global __vector_21
.global __vector_28
.global __vector_29
.set __vector_20,rx0_isr
.set __vector_21,tx0_isr
.set __vector_28,rx1_isr
.set __vector_29,tx1_isr
main:
 ldi r16,hi8(UBRR_VALUE)
 sts UBRR0H,r16
 sts UBRR1H,r16
 ldi r16,lo8(UBRR_VALUE)
 sts UBRR0L,r16
 sts UBRR1L,r16
 clr r16
 sts UCSR0A,r16
 sts UCSR1A,r16
 ldi r16,_BV(RXEN0)|_BV(TXEN0)|_BV(RXCIE0)
 sts UCSR0B,r16
 ldi r16,_BV(UCSZ01)|_BV(UCSZ00)
 sts UCSR0C,r16
 ldi r16,_BV(RXEN1)|_BV(TXEN1)|_BV(RXCIE1)
 sts UCSR1B,r16
 ldi r16,_BV(UCSZ11)|_BV(UCSZ10)
 sts UCSR1C,r16
 sei
 rcall dual_uart_irq_ready
loop:
 ldi ZL,lo8(rx0)
 ldi ZH,hi8(rx0)
 lds r18,rx0t
 lds r19,rx0h
 cp r18,r19
 breq check1
 add ZL,r18
 adc ZH,r1
 ld r20,Z
 inc r18
 andi r18,RB_MASK
 sts rx0t,r18
 rcall put_tx1
check1:
 ldi ZL,lo8(rx1)
 ldi ZH,hi8(rx1)
 lds r18,rx1t
 lds r19,rx1h
 cp r18,r19
 breq loop
 add ZL,r18
 adc ZH,r1
 ld r20,Z
 inc r18
 andi r18,RB_MASK
 sts rx1t,r18
 rcall put_tx0
 rjmp loop
put_tx0:
 lds r21,tx0h
 mov r22,r21
 inc r22
 andi r22,RB_MASK
 lds r23,tx0t
 cp r22,r23
 breq put_tx0
 ldi ZL,lo8(tx0)
 ldi ZH,hi8(tx0)
 add ZL,r21
 adc ZH,r1
 st Z,r20
 sts tx0h,r22
 lds r16,UCSR0B
 ori r16,_BV(UDRIE0)
 sts UCSR0B,r16
 ret
put_tx1:
 lds r21,tx1h
 mov r22,r21
 inc r22
 andi r22,RB_MASK
 lds r23,tx1t
 cp r22,r23
 breq put_tx1
 ldi ZL,lo8(tx1)
 ldi ZH,hi8(tx1)
 add ZL,r21
 adc ZH,r1
 st Z,r20
 sts tx1h,r22
 lds r16,UCSR1B
 ori r16,_BV(UDRIE1)
 sts UCSR1B,r16
 ret
dual_uart_irq_ready: ret

.macro RX_ISR name,udr,buf,head,tail
\name:
 push r16
 push r17
 push r18
 push r30
 push r31
 in r16,_SFR_IO_ADDR(SREG)
 push r16
 lds r18,\udr
 lds r16,\head
 mov r17,r16
 inc r17
 andi r17,RB_MASK
 lds r30,\tail
 cp r17,r30
 breq 1f
 ldi ZL,lo8(\buf)
 ldi ZH,hi8(\buf)
 add ZL,r16
 adc ZH,r1
 st Z,r18
 sts \head,r17
1:
 pop r16
 out _SFR_IO_ADDR(SREG),r16
 pop r31
 pop r30
 pop r18
 pop r17
 pop r16
 reti
.endm
.macro TX_ISR name,ucsrb,udrie,udr,buf,head,tail
\name:
 push r16
 push r17
 push r30
 push r31
 in r16,_SFR_IO_ADDR(SREG)
 push r16
 lds r16,\tail
 lds r17,\head
 cp r16,r17
 brne 2f
 lds r17,\ucsrb
 andi r17,~_BV(\udrie)
 sts \ucsrb,r17
 rjmp 3f
2:
 ldi ZL,lo8(\buf)
 ldi ZH,hi8(\buf)
 add ZL,r16
 adc ZH,r1
 ld r17,Z
 sts \udr,r17
 inc r16
 andi r16,RB_MASK
 sts \tail,r16
3:
 pop r16
 out _SFR_IO_ADDR(SREG),r16
 pop r31
 pop r30
 pop r17
 pop r16
 reti
.endm
RX_ISR rx0_isr,UDR0,rx0,rx0h,rx0t
RX_ISR rx1_isr,UDR1,rx1,rx1h,rx1t
TX_ISR tx0_isr,UCSR0B,UDRIE0,UDR0,tx0,tx0h,tx0t
TX_ISR tx1_isr,UCSR1B,UDRIE1,UDR1,tx1,tx1h,tx1t
