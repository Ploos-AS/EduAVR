#include <avr/io.h>

.section .bss
.global capstone_adc
capstone_adc: .skip 2
.global capstone_calibration
capstone_calibration: .byte 1
.global capstone_value
capstone_value: .skip 2
.global capstone_ticks
capstone_ticks: .skip 2
.global capstone_eeprom
capstone_eeprom: .byte 1
.global capstone_uart_ready
capstone_uart_ready: .byte 1

.section .text
.global main
.global capstone_ready
.global TIMER0_COMPA_vect

TIMER0_COMPA_vect:
    push r24
    in r24, _SFR_IO_ADDR(SREG)
    push r24
    lds r24, capstone_ticks
    inc r24
    sts capstone_ticks, r24
    lds r24, capstone_ticks+1
    adc r24, r1
    sts capstone_ticks+1, r24
    pop r24
    out _SFR_IO_ADDR(SREG), r24
    pop r24
    reti

main:
    ; Timer0 CTC, compare every 125 ticks at 8 MHz / 64.
    ldi r24, _BV(WGM01)
    out _SFR_IO_ADDR(TCCR0A), r24
    ldi r24, 124
    out _SFR_IO_ADDR(OCR0A), r24
    ldi r24, _BV(CS01) | _BV(CS00)
    out _SFR_IO_ADDR(TCCR0B), r24
    ldi r24, _BV(OCIE0A)
    sts TIMSK0, r24

    ; ADC0, AVCC reference, /64 ADC clock.
    ldi r24, _BV(REFS0)
    sts ADMUX, r24
    ldi r24, _BV(ADEN) | _BV(ADPS2) | _BV(ADPS1)
    sts ADCSRA, r24

    ; USART0, 9600 baud, 8N1.
    clr r24
    sts UBRR0H, r24
    ldi r24, 51
    sts UBRR0L, r24
    sts UCSR0A, r24
    ldi r24, _BV(RXEN0) | _BV(TXEN0)
    sts UCSR0B, r24
    ldi r24, _BV(UCSZ01) | _BV(UCSZ00)
    sts UCSR0C, r24
    ldi r24, 1
    sts capstone_uart_ready, r24

    sei

    ; Write and read back one calibration byte through EEPROM.
    ldi r30, lo8(0x20)
    ldi r31, hi8(0x20)
    ldi r24, 0x5a
    sts EEARL, r30
    sts EEARH, r31
    sts EEDR, r24
    in r24, _SFR_IO_ADDR(SREG)
    push r24
    cli
    ldi r24, _BV(EEMPE)
    sts EECR, r24
    ldi r24, _BV(EEPE)
    sts EECR, r24
    pop r24
    out _SFR_IO_ADDR(SREG), r24

1:
    lds r24, EECR
    sbrc r24, EEPE
    rjmp 1b

    ldi r24, 0x20
    sts EEARL, r24
    clr r24
    sts EEARH, r24
    lds r24, EECR
    ori r24, _BV(EERE)
    sts EECR, r24
    lds r24, EEDR
    sts capstone_eeprom, r24
    sts capstone_calibration, r24

    ; Start ADC conversion.
    lds r24, ADCSRA
    ori r24, _BV(ADSC)
    sts ADCSRA, r24

2:
    lds r24, ADCSRA
    sbrc r24, ADSC
    rjmp 2b

    lds r24, ADCL
    lds r25, ADCH
    sts capstone_adc, r24
    sts capstone_adc+1, r25

    lds r18, capstone_calibration
    add r24, r18
    adc r25, r1
    sts capstone_value, r24
    sts capstone_value+1, r25

    ; Deterministic Q1 checkpoint: wait until Timer0 ISR has advanced ticks.
4:
    lds r18, capstone_ticks
    lds r19, capstone_ticks+1
    or r18, r19
    breq 4b

    rcall capstone_ready
3:  rjmp 3b

capstone_ready:
    ret
