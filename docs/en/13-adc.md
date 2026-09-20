# ADC — analog to digital

!!! abstract "Learning goals"
    Configure the ATmega1284P ADC, understand reference voltage, channel selection and prescaling, read a 10-bit conversion in Assembly and C, and distinguish modeled Q1 behavior from physical Q2 accuracy.

!!! info "Prerequisites"
    You should understand AVR registers, bit masks, polling and binary numbers.

A microcontroller is digital, but many real signals are analog. The ADC converts an input voltage into a number that firmware can process.

For an ideal 10-bit conversion:

```text
ADC ≈ Vin / Vref × 1023
```

The result ranges from 0 to 1023.

## Configuration used by EduAVR

The paired examples select:

- ADC0 as input;
- AVCC as the reference;
- right-adjusted 10-bit result;
- ADC enabled;
- prescaler /64.

At an 8 MHz CPU clock, /64 gives a 125 kHz ADC clock.

## C and Assembly

The C version configures `ADMUX` and `ADCSRA`, starts one conversion, waits for `ADSC` to clear and reads `ADC`.

The Assembly version performs the same sequence explicitly. It reads **ADCL before ADCH**, which is important for the AVR ADC result register pair.

Both store the result in `adc_result` and reach the stable `adc_ready` qualification point.

## Under the hood

Compare the two ELFs and their disassembly. Find:

- the AVCC reference selection;
- the /64 prescaler bits;
- the instruction that starts conversion;
- the polling loop;
- the ADCL/ADCH reads;
- the SRAM write to `adc_result`.

## Try it

```sh
make adc
make disasm
sh tools/check_q1.sh
```

## Q1 modeled analog input

EduAVR goes beyond register inspection. The Q1 harness injects a modeled **2500 mV** signal into ADC0 through simavr's ADC interface and observes the value consumed by the actual C and Assembly firmware.

The Debian simavr ATmega1284P model used by the qualified environment models the relevant reference at approximately 3.3 V, so the expected conversion is approximately:

```text
2500 / 3300 × 1023 ≈ 775
```

CI requires the result to fall in a narrow tolerance around that modeled value for both implementations.

!!! success "Qualified result"
    Both C and Assembly complete a modeled ADC0 conversion from the injected 2500 mV input and produce the expected approximately 775 result in Q1.

## Q1 is not an electrical calibration

This test proves the firmware and simulator data path. It does **not** prove the voltage reference on a physical EduBoard, ADC absolute accuracy, noise, source impedance, settling, grounding or PCB behavior.

Those are Q2 measurements on real hardware.

## Check your understanding

1. Why does ADC output depend on both input voltage and reference voltage?
2. Why use a prescaler for the ADC clock?
3. Why does the Assembly version read ADCL before ADCH?
4. What is the numeric range of a 10-bit ADC?
5. Why can Q1 validate the firmware data path without validating physical ADC accuracy?

!!! tip "Next"
    With EEPROM and ADC qualified, the next core topics can move from individual peripherals toward C/Assembly data structures and reusable firmware.
