# Q1 Simulator Qualification

Q1 is EduAVR's default software runtime qualification.

## Automated acceptance

`tools/check_q1.sh` builds and runs paired C and hand-written AVR assembly examples against the ATmega1284P simavr model. The current suite qualifies:

- Blink execution and avr-gdb inspection.
- Stack/functions/ABI: paired C and Assembly call probes verify result flow, stack movement during the call, and restoration of the stack pointer after return.
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

## Coverage audit

The simulator suite already provides strong Q1 coverage for the currently implemented peripheral examples. The largest remaining gaps are curriculum topics that do not yet have dedicated paired C/Assembly examples, rather than missing simulator checks for existing examples.

| Course area | Current automated level | Next simulator target |
| --- | --- | --- |
| CPU / Blink / debugger | Q1 | Add explicit CPU/register-state teaching probes as new architecture exercises appear. |
| Stack / functions / ABI | Q1 | Deterministic paired C/Assembly probe verifies argument/result flow and balanced stack behavior in simavr + avr-gdb. |
| GPIO | Execution Q1 | Add a deterministic DDR/PORT/PIN register-state probe. |
| Timers / interrupts | Q1 | Extend with counter/compare variants when new timer lessons are added. |
| PWM | Q1 configuration | Add modeled duty-cycle/state observations where simavr exposes reliable evidence. |
| USART0/1 | Q1 data path | Keep expanding error/status behavior only where the model can inject it reliably. |
| Dual USART bridge | Q1 bidirectional data path | Add overflow/back-pressure tests when those policies are taught. |
| SPI | Q1 data path | Add mode/clock variants with a virtual peripheral. |
| TWI/I2C | Q1 roundtrip | Add ACK/NACK and error-path tests where simavr models them reliably. |
| ADC | Not yet a core example | Add a simulator-backed ADC lesson only after validating the model/API; retain analog accuracy as Q2. |
| EEPROM | Not yet a core example | Add deterministic simulated write/readback and persistence semantics. |

This table is intentionally conservative: a new Q1 claim is added only when the simulator test observes the behavior directly and reproducibly.

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
