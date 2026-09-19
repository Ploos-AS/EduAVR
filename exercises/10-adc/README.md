# Exercise 10 — ADC: from voltage to number

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR potentiometer/analog source or STK500 with suitable analog source
- **Qualification:** Q1 + Q2
- **Concepts:** ADC, reference voltage, quantization, prescaler, ADMUX, ADCSRA, 10-bit results

## Learning objectives
Explain how an analog voltage becomes a digital number, calculate expected ADC codes, configure the ATmega1284P ADC directly and distinguish modeled conversion behavior from real analog accuracy/noise.

## Mental model
```text
potentiometer -> voltage -> ADC input -> sample/convert -> ADC result registers -> CPU
                              ^
reference voltage ------------+
CPU clock -> prescaler -> ADC clock
```

## Short theory
An ADC maps a continuous input range into discrete numeric codes. The reference defines the top of the measurement range; resolution determines the number of available codes. Configuration also sets the ADC clock and selected channel.

## Part A — Assembly / Q1
Configure reference, channel and ADC prescaler. Start a conversion, wait for completion and read the 10-bit result correctly. Before running, calculate expected codes for 0%, about 25%, 50%, 75% and near-full-scale input.

## Observe
Record ADMUX, ADCSRA and result-register state. Explain why a 10-bit result does not fit in one 8-bit register.

## Part B — C / Q1
Implement the same conversion with direct register-level C. Disassemble initialization and result reading. Identify where the compiler handles the multi-byte value.

## Under the hood
```text
C adc_read() -> register writes -> ADC hardware -> ADCL/ADCH -> AVR instructions -> uint16_t
```

## Part C — Board / Q2
Use the EduBoard potentiometer/analog source. Measure or document the reference/input assumptions, sample several positions and compare measured ADC values with calculated expectations.

## Task
Read the potentiometer and divide its range into four zones. Indicate the active zone using LEDs.

## Expected result
Changing analog voltage changes the ADC result and selected LED zone. Real readings may vary around ideal calculated values.

## Questions
- What does the reference voltage mean?
- Why is ADC output quantized?
- Why does ADC clock matter?
- Why can Q1 test software logic but not analog noise or absolute accuracy?
- How does C represent the 10-bit result on an 8-bit CPU?

## Challenge
Take multiple samples and implement a simple average. Compare stability with single-sample readings.

## Qualification boundary
Q1 covers register/control-flow behavior. Q2 is required for real voltage, reference, noise and ADC accuracy claims.
