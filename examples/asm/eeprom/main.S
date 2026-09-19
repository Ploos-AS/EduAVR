#include <avr/io.h>

.section .bss
.global eeprom_address
eeprom_address: .skip 1
.global eeprom_written
eeprom_written: .skip 1
.global eeprom_readback
eeprom_readback: .skip 1

.section .text
.global eeprom_ready
.type eeprom_ready, @function
eeprom_ready:
    ret
.size eeprom_ready, .-eeprom_ready

.global main
.type main, @function
main:
    ldi r16, 0x12
    sts eeprom_address, r16
    ldi r17, 0x5a
    sts eeprom_written, r17

1:  sbic _SFR_IO_ADDR(EECR), EEPE
    rjmp 1b
    out _SFR_IO_ADDR(EEARL), r16
    clr r18
    out _SFR_IO_ADDR(EEARH), r18
    out _SFR_IO_ADDR(EEDR), r17
    sbi _SFR_IO_ADDR(EECR), EEMPE
    sbi _SFR_IO_ADDR(EECR), EEPE

2:  sbic _SFR_IO_ADDR(EECR), EEPE
    rjmp 2b
    out _SFR_IO_ADDR(EEARL), r16
    out _SFR_IO_ADDR(EEARH), r18
    sbi _SFR_IO_ADDR(EECR), EERE
    in r19, _SFR_IO_ADDR(EEDR)
    sts eeprom_readback, r19

    call eeprom_ready
3:  rjmp 3b
.size main, .-main
