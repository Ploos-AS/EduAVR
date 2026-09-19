# Pointers, buffers and structs

!!! abstract "Learning goals"
    Understand how pointers, arrays/buffers and structs become concrete SRAM addresses and byte accesses on AVR, compare C with explicit Assembly, and use deterministic Q1 evidence to verify layout and data flow.

!!! info "Prerequisites"
    You should understand AVR SRAM, registers, load/store instructions, the stack and basic C variables.

Systems programming starts by making data layout explicit. On an 8-bit AVR, a C pointer is not an abstract concept: it contains an address, and dereferencing it causes loads or stores at that address.

## The qualified example

EduAVR provides paired implementations in:

- `examples/c/data-structures/main.c`
- `examples/asm/data-structures/main.S`

Both create the same observable state:

```text
sample_buffer:  0x10 0x20 0x30 0x40
sample_ptr:     address of sample_buffer
current_sample:
    id:         0x2a
    value:      0x30
sample_sum:     0xa0
```

The C version expresses this with an array, a pointer and a two-byte `struct`. The Assembly version expresses the same layout directly in SRAM.

## Pointers and AVR address registers

The C statement:

```c
volatile uint8_t *p = sample_buffer;
```

creates a pointer to the first byte of the buffer. In the Assembly implementation, the X register pair (`r27:r26`) is loaded with the address of `sample_buffer`.

AVR also provides Y and Z pointer register pairs. Instructions such as `ld`, `st` and their increment/decrement addressing forms make these registers useful for arrays and buffers.

## Arrays are contiguous storage

The four-byte buffer occupies four consecutive SRAM locations. Therefore `p[2]` means: start at the address in `p`, advance two bytes and access that byte.

The Assembly example demonstrates the relationship with `st X+` while filling the buffer and explicit `lds` instructions while summing it.

!!! warning "Bounds are a software responsibility"
    Neither a C pointer nor an AVR pointer register knows the size of the array. Accessing beyond the object is a programming error; the CPU does not automatically protect adjacent SRAM.

## Struct layout

The example type is:

```c
typedef struct {
    uint8_t id;
    uint8_t value;
} sample_t;
```

For this deliberately simple structure, the two fields occupy adjacent bytes. The Assembly version reserves two bytes and writes the fields at `current_sample` and `current_sample+1`.

Do not assume every C struct has an obvious packed layout. Field types, alignment rules and compiler ABI matter. When layout is externally visible, verify it rather than guessing.

## volatile in this example

The qualification variables are `volatile` so their accesses remain observable at the stable `data_ready` point. This is useful for the debugger-driven Q1 test.

`volatile` does **not** provide bounds checking, atomicity, locking or general thread/interrupt safety.

## Under the hood

Build and inspect both implementations:

```sh
make data
make disasm
sh tools/check_q1.sh
```

Find:

- the SRAM allocation for the four-byte buffer;
- the address loaded into the pointer;
- the X-register operations in Assembly;
- the two adjacent struct fields;
- the loads and additions producing `0xa0`;
- the compiler-generated instructions implementing C indexing.

Compare the C disassembly with the hand-written Assembly. The goal is not to make them textually identical, but to explain how both produce the same machine-visible state.

## Deterministic Q1 qualification

At `data_ready`, the Q1 harness checks both ELFs and requires:

- buffer bytes = `10 20 30 40`;
- `current_sample.id = 0x2a`;
- `current_sample.value = 0x30`;
- `sample_sum = 0xa0`;
- `sample_ptr` equals the address of `sample_buffer`.

!!! success "Qualified behavior"
    The paired C and Assembly examples are required to produce the same pointer, buffer, struct and sum state in simavr/GDB.

This is a CPU/SRAM claim, so Q1 is appropriate. It does not claim anything about physical board wiring.

## Exercises

1. Change the four buffer values and predict the new 8-bit sum before running Q1.
2. Add a third `uint8_t` field to the struct in both implementations and inspect its address.
3. Rewrite the C sum using pointer increment instead of indexing and compare the generated Assembly.
4. Explain what would happen to neighboring SRAM if Assembly stored a fifth byte beyond the four-byte buffer.
5. Explain why `volatile` makes the qualification state observable but does not make an ISR/main shared object automatically safe.

!!! tip "Next"
    The next systems-programming step is to turn these raw buffers into reusable interfaces and then study `volatile`, ISR/main sharing, stack/SRAM budgets and optimization.
