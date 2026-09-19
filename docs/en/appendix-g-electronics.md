# Appendix G — Electronics for AVR programmers

## Purpose
Connect register-level firmware to the electrical circuit it controls.

## Digital inputs
A floating input has no reliable logic state. Learn pull-up/pull-down behavior, active-low wiring, input thresholds and why a button is an electrical component rather than an ideal Boolean variable.

## Outputs and current
GPIO pins have electrical limits. LED current needs a resistor; loads that demand more current need a driver stage. Respect per-pin, port and device limits from the datasheet.

## Drivers
Transistors/MOSFETs allow a low-current MCU signal to control a larger load. EduBoard RGB0 and BUZZ0 deliberately expose this distinction.

## Debounce
Mechanical contacts bounce. Software debounce is a policy layered on physical behavior; Exercise 12 connects both.

## Decoupling
Local decoupling capacitors provide a short high-frequency current path near IC supply pins. Bulk capacitance serves a different time/energy scale.

## Clocks
Clock source, frequency, fuse configuration and timing calculations are linked. Timer/UART errors can originate from a wrong clock assumption.

## Logic levels
TTL/CMOS MCU logic is not RS-232. Likewise, 5 V and 3.3 V systems are not automatically compatible. Identify voltage domains before connecting boards.

## Analog
ADC measurements depend on reference, source impedance, noise, grounding and layout. A numeric ADC code is not automatically an accurate voltage measurement.

## Habit
For every peripheral lab, draw the complete path: MCU pin → protection/driver/passive components → connector/load → return path.
