# Q1 Simulator Qualification

Q1 is EduAVR's default software runtime qualification.

## Automated acceptance

`tools/check_q1.sh` builds and runs paired C and hand-written AVR assembly examples against the ATmega1284P simavr model. The current suite qualifies:

- Blink execution and avr-gdb inspection.
- Timer0 interrupt delivery to a stable firmware probe.
- PWM register configuration.
- USART0 and USART1 polling RX -> firmware -> TX loopback.
- USART0 and USART1 interrupt-driven RX/TX ring buffers with 32-byte deterministic loopback.
- Bidirectional USART0 <-> USART1 polling bridge.
- Bidirectional interrupt/ring-buffer USART0 <-> USART1 bridge.
- Robust-USART normal data path. Simulator qualification does not claim FE/DOR/UPE electrical/error injection unless explicitly modeled.
- SPI controller configuration and modeled transfer to a virtual peripheral.
- TWI/I2C controller configuration and modeled EEPROM write/readback.

### TWI/I2C roundtrip

The TWI Q1 data-path test performs a complete modeled firmware roundtrip in both C and assembly:

1. write `0x55` to virtual EEPROM register `0x10`;
2. address register `0x10` again;
3. issue a repeated START and read transaction;
4. return the EEPROM byte through simavr's TWI model;
5. require the firmware's `twi_readback` SRAM byte to equal `0x55`.

This verifies that the firmware consumes the modeled read response, not merely that bus events occurred.

## Running Q1

```sh
sh tools/check_q1.sh
```

A successful complete run ends with:

```text
Q1 PASS
```

GitHub Actions runs M1/Q0 and Q1 in the Debian AVR environment on pushes and pull requests. CI conclusion, rather than the presence of the text `Q1 PASS` alone, is authoritative for repository qualification.

## Boundary

Q1 proves only behavior exercised by the simulator/model. It does **not** qualify STK500/EduBoard programming, voltage levels, pull-ups, signal integrity, real bus timing, external devices, oscillator accuracy, ADC electrical accuracy, reset/power behavior, fuses, or other physical properties. Those remain Q2 physical qualification.
