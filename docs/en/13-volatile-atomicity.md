# volatile, interrupts and atomicity

!!! abstract "Learning goals"
    Understand why ISR/main shared state needs explicit treatment, what `volatile` does and does not guarantee, why multi-byte objects are not automatically atomic on an 8-bit AVR, and how to take a coherent snapshot.

!!! info "Prerequisites"
    Complete the pointers, buffers and structs lesson first. You should also understand interrupts, SREG and SRAM loads/stores.

An interrupt can change program state between two instructions in `main()`. That is useful, but it means shared data has rules that ordinary sequential code does not.

## The paired example

EduAVR provides:

- `examples/c/shared-state/main.c`
- `examples/asm/shared-state/main.S`

Timer0 periodically updates:

```text
shared_ticks   8-bit
shared_word   16-bit
```

The ISR increments `shared_ticks` and adds `0x0101` to `shared_word`. Main waits until at least three interrupts have occurred and then records one coherent snapshot.

## What volatile means

In C, the shared objects are declared `volatile`. This tells the compiler that their values may change for reasons not visible in ordinary control flow and that accesses are observable.

It does **not** mean:

- the access is atomic;
- multiple accesses form one transaction;
- interrupts are disabled;
- races are impossible;
- a multi-byte value cannot change halfway through a read.

Inspect the generated disassembly and identify the loads/stores that remain because the objects are volatile.

## Why 16 bits matter on an 8-bit CPU

`shared_word` is 16 bits wide, but AVR handles it as separate byte operations. An interrupt could occur between the low-byte and high-byte reads.

A mixed result can therefore be possible if main reads a changing multi-byte object without protection.

This is different from visibility. `volatile` addresses compiler observability; atomicity is a machine/execution property.

## Atomic snapshot in C

The example preserves SREG, disables interrupts, copies the shared values, then restores the previous SREG:

```c
uint8_t sreg = SREG;
cli();
uint16_t word = shared_word;
uint8_t ticks = shared_ticks;
SREG = sreg;
```

The protected region is deliberately short. Work that does not require atomicity happens after interrupts are restored.

## The same operation in Assembly

The Assembly version makes the sequence explicit:

```asm
in  r18, SREG
cli
lds r20, shared_word
lds r21, shared_word+1
lds r22, shared_ticks
out SREG, r18
```

This is the machine-level reason the C pattern works.

## Deterministic Q1

Run:

```sh
make shared
make disasm
sh tools/check_q1.sh
```

At `shared_state_ready`, Q1 verifies both implementations. The timer must have generated at least three events, and the low and high bytes of the protected `shared_word` snapshot must correspond to the same captured tick count.

!!! success "Qualified result"
    Build #371 and container qualification #29 passed for the paired shared-state implementation and deterministic Q1 probe.

Q1 demonstrates interrupt-driven CPU/SRAM behavior in the simulator. It does not make claims about physical interrupt sources or electrical timing.

## Design rules

Keep shared state small and ownership clear. Prefer short critical sections. Do not disable interrupts around slow work merely for convenience. For larger data structures, consider copying a minimal snapshot or designing a producer/consumer protocol rather than protecting a long operation.

## Exercises

1. Explain why adding `volatile` alone cannot make a 16-bit read atomic.
2. Find the two byte loads used for `shared_word` in each implementation.
3. Move unnecessary work into the protected region and explain the latency cost.
4. Add another shared 16-bit value and extend the snapshot correctly.
5. Describe a ring-buffer design where ISR and main each own different indices.

!!! tip "Next"
    Next, quantify SRAM and stack use and study how optimization changes generated AVR code without changing required program semantics.
