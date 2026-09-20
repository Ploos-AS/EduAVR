#include <avr/io.h>

.section .bss
.global budget_result
budget_result: .byte 1
.global budget_sp_before
budget_sp_before: .byte 2
.global budget_sp_deep
budget_sp_deep: .byte 2
.global budget_sp_after
budget_sp_after: .byte 2
.global budget_static
budget_static: .skip 16

.section .text
.global main
.global budget_worker
.global budget_ready

budget_worker:
    ; AVR-GCC ABI: r24 carries the argument and r24 returns the result.
    ; Reserve exactly 8 bytes using ordinary PUSH operations.  r16 is
    ; call-clobbered, so its saved values do not need ABI preservation.
    push r16
    push r16
    push r16
    push r16
    push r16
    push r16
    push r16
    push r16

    ; Z points at the current top of the stack. AVR PUSH stores at SP and
    ; then decrements SP, so the eight reserved bytes live at SP+1..SP+8.
    in r30, _SFR_IO_ADDR(SPL)
    in r31, _SFR_IO_ADDR(SPH)
    adiw r30, 1

    mov r18, r24
    ldi r19, 8
1:
    st Z+, r18
    inc r18
    dec r19
    brne 1b

    in r18, _SFR_IO_ADDR(SPL)
    sts budget_sp_deep, r18
    in r19, _SFR_IO_ADDR(SPH)
    sts budget_sp_deep+1, r19

    ; Read local[0] and local[7] back from SP+1..SP+8 without touching
    ; the caller's return address below the frame.
    in r30, _SFR_IO_ADDR(SPL)
    in r31, _SFR_IO_ADDR(SPH)
    adiw r30, 1
    ld r24, Z
    adiw r30, 7
    ld r18, Z
    add r24, r18

    pop r16
    pop r16
    pop r16
    pop r16
    pop r16
    pop r16
    pop r16
    pop r16
    ret

main:
    ldi r30, lo8(budget_static)
    ldi r31, hi8(budget_static)
    clr r18
2:
    st Z+, r18
    inc r18
    cpi r18, 16
    brne 2b

    in r18, _SFR_IO_ADDR(SPL)
    sts budget_sp_before, r18
    in r18, _SFR_IO_ADDR(SPH)
    sts budget_sp_before+1, r18

    ldi r24, 0x20
    call budget_worker
    sts budget_result, r24

    in r18, _SFR_IO_ADDR(SPL)
    sts budget_sp_after, r18
    in r18, _SFR_IO_ADDR(SPH)
    sts budget_sp_after+1, r18

    call budget_ready
3:  rjmp 3b

budget_ready:
    ret
