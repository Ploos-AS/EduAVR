#include <avr/io.h>

.global main
.global spi_ready

.section .text
main:
    ; PB4=SS, PB5=MOSI, PB7=SCK outputs; PB6=MISO input.
    in r16, _SFR_IO_ADDR(DDRB)
    ori r16, _BV(DDB4) | _BV(DDB5) | _BV(DDB7)
    andi r16, ~_BV(DDB6)
    out _SFR_IO_ADDR(DDRB), r16

    ldi r16, _BV(SPE) | _BV(MSTR) | _BV(SPR0)
    out _SFR_IO_ADDR(SPCR), r16
    clr r16
    out _SFR_IO_ADDR(SPSR), r16

    rcall spi_ready
    rjmp spi_loop

spi_ready:
    ret

spi_loop:
    ldi r17, 0x55
    out _SFR_IO_ADDR(SPDR), r17
wait_spi:
    in r16, _SFR_IO_ADDR(SPSR)
    sbrs r16, SPIF
    rjmp wait_spi
    in r17, _SFR_IO_ADDR(SPDR)
    rjmp spi_loop
