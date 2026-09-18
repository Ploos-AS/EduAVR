# GPIO — from registers to pins

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

Do not memorize that as a universal wiring rule. Draw the circuit and derive the logic level.

## Read-modify-write

Expressions such as:

```c
DDRB |= _BV(DDB0);
```

are read-modify-write operations. Inspect their generated assembly. Depending on register location, operation and optimization, the compiler may use specialized bit instructions or a more general sequence.

## Qualification

Q1 can verify register-level firmware logic and instruction flow.

Q2 is required to claim that a real LED lights, a switch is read electrically, pull-ups behave correctly on the board, or switch bounce has been observed.
