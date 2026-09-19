#include <avr/io.h>

.section .bss
.global stack_result
stack_result:
    .skip 1
.global stack_sp_before
stack_sp_before:
    .skip 2
.global stack_sp_inside
stack_sp_inside:
    .skip 2
.global stack_sp_after
stack_sp_after:
    .skip 2

.section .text

.global abi_add8
.type abi_add8, @function
abi_add8:
    ; AVR-GCC ABI: first uint8_t argument in r24, second in r22,
    ; uint8_t return value in r24.
    push r16

    in r16, _SFR_IO_ADDR(SPL)
    sts stack_sp_inside, r16
    in r16, _SFR_IO_ADDR(SPH)
    sts stack_sp_inside+1, r16

    add r24, r22

    pop r16
    ret
.size abi_add8, .-abi_add8

.global stack_ready
.type stack_ready, @function
stack_ready:
    ret
.size stack_ready, .-stack_ready

.global main
.type main, @function
main:
    in r18, _SFR_IO_ADDR(SPL)
    sts stack_sp_before, r18
    in r18, _SFR_IO_ADDR(SPH)
    sts stack_sp_before+1, r18

    ldi r24, 0x12
    ldi r22, 0x34
    call abi_add8
    sts stack_result, r24

    in r18, _SFR_IO_ADDR(SPL)
    sts stack_sp_after, r18
    in r18, _SFR_IO_ADDR(SPH)
    sts stack_sp_after+1, r18

    call stack_ready
1:
    rjmp 1b
.size main, .-main
