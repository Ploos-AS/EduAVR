# GPIO — from registers to pins

!!! abstract "Learning goals"
    After this lesson you should be able to configure a GPIO pin as input or output, explain pull-ups and active-low inputs, and inspect the instructions generated for register operations.

!!! info "Prerequisites"
    You should understand the basic AVR execution model and registers from [AVR architecture](02-avr-architecture.md).

GPIO is where AVR software first meets the outside world.

For each GPIO port, three registers form the basic model:

- `DDRx` — data direction;
- `PORTx` — output value or input pull-up control;
- `PINx` — input state and, on supported AVR devices, output-toggle behavior.

## Output

To make PB0 an output in C:

```c
DDRB |= _BV(DDB0);
PORTB |= _BV(PORTB0);
```

In AVR assembly the same hardware can be manipulated directly:

```asm
sbi _SFR_IO_ADDR(DDRB), DDB0
sbi _SFR_IO_ADDR(PORTB), PORTB0
```

Clear the output with `cbi`, or toggle PB0 through the PIN register on ATmega1284P.

## Input and pull-up

An input is selected by clearing its DDR bit. Setting the corresponding PORT bit enables the internal pull-up.

This commonly makes a button active-low: released reads as 1; pressed reads as 0.

!!! warning "Derive it from the circuit"
    Do not memorize active-low as a universal wiring rule. Draw the circuit and derive the logic level.

## Read-modify-write

Expressions such as:

```c
DDRB |= _BV(DDB0);
```

are read-modify-write operations. Inspect their generated assembly. Depending on register location, operation and optimization, the compiler may use specialized bit instructions or a more general sequence.

## Try it

Build both the C and assembly GPIO examples, inspect their disassembly, and identify the instructions that configure and change the GPIO registers.

!!! success "Expected result"
    In simulation you can verify register-level firmware logic and instruction flow. Do not interpret that as evidence that a physical LED, switch or pull-up has been electrically verified.

## Qualification boundary

**Q1** verifies register-level firmware logic and instruction flow. The automated paired C/Assembly probe deterministically checks `DDRB` and `PORTB` and observes `PINB` in simavr + avr-gdb.

**Q2** is required to claim that a real LED lights, a switch is read electrically, pull-ups behave correctly on the board, or switch bounce has been observed.

## Check your understanding

1. What roles do DDRx, PORTx and PINx have?
2. Why is a pull-up button commonly active-low?
3. Which claims can Q1 establish, and which require Q2?

!!! tip "Next"
    Continue to [Stack and functions](04-stack-functions.md).
