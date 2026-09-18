# Q1 Simulator Qualification

Q1 is EduAVR's default software runtime qualification.

## Automated acceptance

`tools/check_q1.sh` builds and runs the paired C and hand-written AVR assembly examples against the ATmega1284P simavr model. The current suite qualifies:

- Blink execution and avr-gdb inspection.
- Timer0 interrupt delivery to a stable firmware probe.
- PWM register configuration.
- USART0 polling RX -> firmware -> TX loopback.
- USART0 interrupt-driven RX/TX ring buffers with a 32-byte loopback.
- SPI controller configuration and a modeled transfer to a virtual peripheral.
- TWI/I2C controller configuration and a modeled EEPROM transaction.

### TWI/I2C roundtrip

The TWI Q1 data-path test performs a complete modeled firmware roundtrip in both C and assembly:

1. write `0x55` to virtual EEPROM register `0x10`;
2. address register `0x10` again;
3. issue a repeated START and read transaction;
4. return the EEPROM byte through simavr's TWI model;
5. require the firmware's `twi_readback` SRAM byte to equal `0x55`.

This is stronger than observing bus events alone: Q1 verifies that the AVR firmware actually consumes the modeled read response.

Run:

```sh
sh tools/check_q1.sh
```

The final line must be:

```text
Q1 PASS
```

## CI

GitHub Actions runs M1/Q0 and Q1 using the same Debian AVR environment. Run `35383245332` qualified commit `0c78ccb197f4efe7bf2d2030aaafff2b9decf721` successfully after the USART0 assembly ISR vector linkage and TWI SRAM assertion were enabled.

## Boundary

Q1 proves only behavior exercised by the simulator/model. It does **not** qualify STK500 programming, voltage levels, pull-ups, signal integrity, real bus timing, external devices, oscillator accuracy, reset/power behavior, or other electrical properties. Those remain Q2 physical qualification.
