# Appendix I — Performance and optimization

## Purpose
Measure before optimizing and connect performance claims to AVR instructions and resources.

## Metrics
- instruction cycles and execution time;
- interrupt latency and ISR duration;
- Flash size;
- static SRAM use;
- stack use;
- peripheral throughput;
- energy/power only when physically measured.

## Cycle analysis
Use the instruction set timing plus control-flow path. Branches, calls, memory accesses and multi-byte operations matter.

## C versus assembly
Compare equivalent behavior, not artificial snippets. Record compiler version/options and inspect generated assembly. Hand assembly is valuable when it improves understanding or satisfies a measured constraint, not because it is assumed faster.

## Optimization experiment
Build one exercise at multiple optimization levels. Record Flash/SRAM, disassembly and measured/modelled timing. Explain semantic changes caused by undefined behavior separately from legitimate optimization.

## Interrupts
Measure worst relevant path, not only average execution. Long ISRs can affect latency elsewhere.

## Rule
State whether every number is calculated, simulated or physically measured.
