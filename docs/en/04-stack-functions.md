# Stack, subroutines and C functions

!!! abstract "Learning goals"
    Understand how AVR uses the stack for calls and returns, how registers are preserved, and how C functions map to the AVR-GCC calling convention.

!!! info "Prerequisites"
    You should understand the AVR register model, SRAM, and basic disassembly.

## CALL and RET

A function call is not magic. The CPU must remember where to return, preserve required state and agree on where arguments and results live.

AVR subroutines can be entered with call instructions and leave with `ret`. The return address is stored on the stack.

## PUSH and POP

```asm
push r18
; use r18
pop r18
ret
```

The stack lives in SRAM and grows as values, return addresses and saved registers are pushed. A subroutine must follow the calling convention: saving every register is wasteful, while saving too few corrupts the caller.

## ABI / calling convention

AVR-GCC follows an ABI defining argument and return registers, call-used and call-saved registers, stack use and frame-pointer conventions.

Do not infer the complete ABI from one compiler listing. Consult the toolchain documentation and inspect real output.

## C functions

```c
uint8_t add8(uint8_t a, uint8_t b)
{
    return a + b;
}
```

Compile it at `-O0` and `-Os`. Inspect where the arguments arrive, where the result is returned, whether a stack frame is created, and which instructions disappear after optimization.

## Under the hood

Compare the C function with a hand-written Assembly routine. Identify the instructions that implement the arithmetic and the instructions that exist only to satisfy function-call and ABI requirements.

## Try it

Use avr-gdb to stop immediately before a function call. Record the stack pointer, single-step through the call, function body and return, then inspect the stack and relevant registers again.

!!! success "Expected result"
    You can explain where the return address is stored and identify the argument and result registers used by the inspected example.

## Qualification

This lesson is Q1-qualified. The automated paired C/Assembly probe verifies argument/result flow, observes the stack pointer moving downward inside the call, and requires it to be restored after return in simavr + avr-gdb.

## Check your understanding

1. Where does the AVR stack live?
2. Why does a calling convention exist?
3. Why can a function prologue and epilogue change with optimization?
4. Why is understanding the ABI important when mixing C and Assembly?

!!! tip "Next"
    Continue to [Timers and interrupts](05-timers-interrupts.md).
