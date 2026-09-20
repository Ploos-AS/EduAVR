# Integrated systems capstone

!!! abstract "Learning goals"
    Integrate timer interrupts, ADC, EEPROM, USART configuration and a small data path into one deterministic AVR firmware. Read the resulting system as interacting peripherals rather than isolated examples.

!!! info "Prerequisites"
    Complete lessons 13–18 and the testing/qualification appendix.

The capstone is deliberately small. The goal is not to build a product; it is to demonstrate that the mechanisms from the course can coexist in one firmware image while remaining observable and testable.

## The system

The paired C and Assembly implementations contain:

- Timer0 in CTC mode with an interrupt-driven tick counter;
- ADC0 conversion using the AVCC reference;
- an EEPROM calibration byte at address `0x20`;
- USART0 initialized for 9600 baud, 8N1;
- a final value calculated as `ADC result + calibration`;
- explicit probe variables for Q1 qualification.

Build it with:

```sh
make capstone
```

## Why this is different from the earlier lessons

Earlier examples isolate one mechanism at a time. Here, initialization order, interrupt state, peripheral registers, persistent data and application state interact.

## Q1 evidence

Run:

```sh
sh tools/check_capstone_q1.sh
```

The qualification checks both C and Assembly for successful simulator execution, reaching the capstone probe, EEPROM readback of `0x5a`, USART initialization, Timer0 interrupt progress, ADC result availability, and a final result equal to ADC result plus calibration.

This is integration evidence, not a claim of electrical correctness.

## Debugging exercise

Stop at `capstone_ready` in GDB and inspect `capstone_adc`, `capstone_calibration`, `capstone_value`, `capstone_ticks`, `capstone_eeprom` and `capstone_uart_ready`.

Then inspect the generated Assembly for the C version and identify where each peripheral is initialized.

## Design questions

1. Why does the timer interrupt need to preserve machine state?
2. What would happen if EEPROM calibration were read before the write completed?
3. Which parts of the system depend on the simulated ADC model?
4. Why is the USART configuration observable even though this capstone does not transmit application data?
5. Which state belongs to peripherals and which state belongs to the application?
6. What additional Q2 tests would be needed on a physical EduBoard-AVR?

!!! success "M6 integration"
    The capstone demonstrates that course mechanisms can be combined into one deterministic C/Assembly system while retaining explicit Q1 evidence.