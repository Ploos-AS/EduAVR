# M1 Qualification

## Scope

M1 qualifies the reproducible EduAVR build and inspection environment for the ATmega1284P reference target.

This qualification is intentionally independent of physical STK500 access. Hardware programming and runtime exercises are qualified separately when a board is attached.

## Requirements

The qualification must prove that:

- AVR-GCC is available.
- GNU AVR Binutils are available.
- AVR-LibC is usable by the C example.
- AVRDUDE is installed.
- GNU Make is available.
- ATmega1284P is accepted as the compiler target.
- the reference C Blink builds to ELF and Intel HEX.
- the reference AVR assembly Blink builds to ELF and Intel HEX.
- disassembly listings are generated for both implementations.
- both ELF files identify as AVR objects.

## Run

Native toolchain:

```sh
sh tools/check_m1.sh
```

OCI environment:

```sh
podman build -t eduavr-dev -f container/Containerfile .
podman run --rm -v "$PWD:/work" eduavr-dev sh tools/check_m1.sh
```

Docker can run the same OCI image.

## Result policy

Only the literal final line:

```text
M1 PASS
```

means the build qualification passed.

A GitHub Actions run executes the same qualification script. CI and local/container qualification therefore exercise the same acceptance criteria.

## Not covered by M1

M1 does not claim that a physical STK500 was detected, programmed or electrically verified. Those tests require real hardware and are tracked separately.
