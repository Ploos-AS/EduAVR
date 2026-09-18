#include <avr/io.h>

.global main
.global usart0_irq_ready

.equ UBRR_VALUE, 51
.equ RB_MASK, 15

.section .bss
rx_buf:  .skip 16
tx_buf:  .skip 16
rx_head: .skip 1
rx_tail: .skip 1
tx_head: .skip 1
tx_tail: .skip 1

.section .text

; ATmega1284P interrupt vectors use 4-byte JMP entries.
; Vector 20 (USART0 RX complete) is at byte address 0x50;
; vector 21 (USART0 data register empty) is at byte address 0x54.
.org 0x50
    jmp usart0_rx_isr
.org 0x54
    jmp usart0_udre_isr

main:
    ldi r16, hi8(UBRR_VALUE)
    sts UBRR0H, r16
    ldi r16, lo8(UBRR_VALUE)
    sts UBRR0L, r16
    clr r16
    sts UCSR0A, r16
    ldi r16, _BV(RXEN0) | _BV(TXEN0) | _BV(RXCIE0)
    sts UCSR0B, r16
    ldi r16, _BV(UCSZ01) | _BV(UCSZ00)
    sts UCSR0C, r16
    sei
    rcall usart0_irq_ready

main_loop:
    lds r18, rx_tail
    lds r19, rx_head
    cp r18, r19
    breq main_loop

    ldi ZH, hi8(rx_buf)
    ldi ZL, lo8(rx_buf)
    add ZL, r18
    adc ZH, r1
    ld r20, Z
    inc r18
    andi r18, RB_MASK
    sts rx_tail, r18

tx_wait:
    lds r21, tx_head
    mov r22, r21
    inc r22
    andi r22, RB_MASK
    lds r23, tx_tail
    cp r22, r23
    breq tx_wait

    ldi ZH, hi8(tx_buf)
    ldi ZL, lo8(tx_buf)
    add ZL, r21
    adc ZH, r1
    st Z, r20
    sts tx_head, r22
    lds r16, UCSR0B
    ori r16, _BV(UDRIE0)
    sts UCSR0B, r16
    rjmp main_loop

usart0_irq_ready:
    ret

usart0_rx_isr:
    push r16
    push r17
    push r18
    push r30
    push r31
    in r16, _SFR_IO_ADDR(SREG)
    push r16
    lds r18, UDR0
    lds r16, rx_head
    mov r17, r16
    inc r17
    andi r17, RB_MASK
    lds r30, rx_tail
    cp r17, r30
    breq rx_done
    ldi ZH, hi8(rx_buf)
    ldi ZL, lo8(rx_buf)
    add ZL, r16
    adc ZH, r1
    st Z, r18
    sts rx_head, r17
rx_done:
    pop r16
    out _SFR_IO_ADDR(SREG), r16
    pop r31
    pop r30
    pop r18
    pop r17
    pop r16
    reti

usart0_udre_isr:
    push r16
    push r17
    push r30
    push r31
    in r16, _SFR_IO_ADDR(SREG)
    push r16
    lds r16, tx_tail
    lds r17, tx_head
    cp r16, r17
    brne tx_send
    lds r17, UCSR0B
    andi r17, ~_BV(UDRIE0)
    sts UCSR0B, r17
    rjmp tx_done
tx_send:
    ldi ZH, hi8(tx_buf)
    ldi ZL, lo8(tx_buf)
    add ZL, r16
    adc ZH, r1
    ld r17, Z
    sts UDR0, r17
    inc r16
    andi r16, RB_MASK
    sts tx_tail, r16
tx_done:
    pop r16
    out _SFR_IO_ADDR(SREG), r16
    pop r31
    pop r30
    pop r17
    pop r16
    reti
