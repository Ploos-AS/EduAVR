# Stack, subroutines and C functions

A function call is not magic. The CPU must remember where to return, preserve required state and agree on where arguments and results live.

## CALL and RET

AVR subroutines can be entered with call instructions and leave with `ret`. The return address is stored on the stack.

The stack lives in SRAM and grows as values, return addresses and saved registers are pushed.

## PUSH and POP

```asm
push r18
; use r18
pop r18
ret
```

A subroutine must follow the calling convention. Saving every register is wasteful; saving too few corrupts the caller.

## ABI / calling convention

AVR-GCC follows an ABI defining matters such as:

- argument registers;
- return-value registers;
- call-used registers;
- call-saved registers;
- stack use;
- frame-pointer conventions.

Do not guess these rules from one compiler listing. Consult the toolchain ABI documentation and inspect real output.

## C functions

Start with a deliberately simple function:

```c
uint8_t add8(uint8_t a, uint8_t b)
{
    return a + b;
}
```

Compile it at `-O0` and `-Os`. Inspect:

- where `a` and `b` arrive;
- where the result is returned;
- whether a stack frame is created;
- which instructions disappear after optimization.

## Why this matters

Understanding the calling convention allows C and assembly to coexist safely. Later EduAVR labs can call an assembly routine from C and a C function from assembly.

## Qualification

This lesson is Q1: stack, calls, register state and generated code can be studied in simavr and avr-gdb without physical hardware.
