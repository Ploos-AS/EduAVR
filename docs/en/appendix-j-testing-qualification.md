# Appendix J — Testing and qualification

## Purpose
Use repeatable evidence and keep simulation claims separate from hardware claims.

## EduAVR levels
- **Q0:** build, static checks and artifact validation.
- **Q1:** simulator/model verification of applicable CPU/peripheral behavior.
- **Q2:** physical board/electrical qualification.

A Q1 PASS never silently becomes a Q2 PASS.

## Regression structure
A useful test states target, setup, exact build, stimulus, expected result, observed result and evidence. Re-run it after relevant changes.

## CI
CI should reproduce toolchain/build checks and deterministic Q0/Q1 tests that are suitable for runners. Hardware-dependent Q2 tests require an identified physical setup or HIL infrastructure.

## HIL
Hardware-in-the-loop can automate programming, stimulus and measurement, but automation does not remove the need to document instruments, wiring, board revision and pass criteria.

## Course exercises
Each BOARD/SIM → BOARD exercise should map to a documented MCU resource, board connection, isolation/routing mechanism when shared, and practical observation point.

## Failure
A failed qualification is useful evidence. Record the failure and cause; do not weaken pass criteria merely to obtain PASS.
