# EEPROM — persistent data

!!! abstract "Learning goals"
    Understand why EEPROM differs from SRAM and Flash, use the ATmega1284P EEPROM interface from Assembly and C, and verify a deterministic write/readback in simulation.

!!! info "Prerequisites"
    You should understand AVR memory spaces, registers, polling and basic function calls.

EEPROM is non-volatile memory: unlike SRAM, its contents are intended to survive loss of power. It is useful for small amounts of persistent state such as configuration, calibration values and counters. It is not a replacement for ordinary RAM: writes are slower and EEPROM has finite write endurance.

## Three AVR memory spaces

Keep the roles separate:

- **Flash** stores program code and constants.
- **SRAM** stores normal runtime variables and the stack.
- **EEPROM** stores data that should persist independently of normal program execution.

The EEPROM has its own address/data/control mechanism. A numeric EEPROM address is therefore not an SRAM pointer in the architectural sense, even though avr-libc exposes a convenient pointer-shaped API.

## The paired example

EduAVR uses the same deterministic transaction in C and Assembly:

1. select EEPROM address `0x12`;
2. write value `0x5a`;
3. wait until the write completes;
4. read address `0x12`;
5. store the read value in SRAM;
6. stop at the stable `eeprom_ready` qualification point.

This deliberately simple transaction makes the two implementations and the simulator evidence easy to compare.

## C implementation

The C example uses avr-libc's EEPROM API:

```c
uint8_t *address = (uint8_t *)0x12;
eeprom_write_byte(address, 0x5a);
eeprom_busy_wait();
value = eeprom_read_byte(address);
```

Do not stop at the library call. Disassemble the ELF and identify the register-level operations generated or called by the library implementation.

## Assembly implementation

The Assembly version exposes the hardware sequence directly. Follow `EEARL/EEARH` for the address, `EEDR` for data and `EECR` for control/status.

For the write, notice the protected write-enable sequence: the firmware sets the master write-enable bit before starting the actual EEPROM write. It also waits while a previous/current write is busy.

For the read, the firmware selects the address, triggers the EEPROM read and copies `EEDR` into SRAM.

## Under the hood

Compare the C and Assembly ELFs with `avr-objdump`. Answer:

- Which instructions move the address and data?
- Where does firmware wait for EEPROM completion?
- Which work is hidden by avr-libc?
- Why are the observable SRAM variables useful to a debugger-driven test?

## Try it

Build and disassemble the paired examples:

```sh
make eeprom
make disasm
```

Then run the complete Q1 suite:

```sh
sh tools/check_q1.sh
```

!!! success "Expected result"
    Both implementations write `0x5a` at EEPROM address `0x12` and read `0x5a` back in the simavr model.

## Qualification

**Q0** builds and disassembles both implementations.

**Q1** runs both firmwares in simavr, breaks at `eeprom_ready` and requires the observed address, written value and readback value to be `0x12`, `0x5a` and `0x5a`.

Q1 proves the modeled firmware transaction. **Q2** is still required for physical-device claims such as persistence across actual power removal, endurance, supply-voltage behavior and programming conditions.

## Check your understanding

1. Why is EEPROM useful when SRAM already exists?
2. Why should frequently changing variables normally remain in SRAM?
3. What roles do EEAR, EEDR and EECR have?
4. Why must firmware wait for an EEPROM write to complete?
5. What does the Q1 readback prove, and what does it not prove?

!!! tip "Next"
    The next M5 topic is ADC. EEPROM gives us deterministic persistent-data behavior first; ADC adds the boundary between digital firmware and an analog physical signal.
