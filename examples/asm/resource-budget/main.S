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
    ; Reserve exactly 8 bytes using ordinary PUSH operations. r16 is
    ; call-saved by the AVR-GCC ABI; the matching POPs preserve it.
    push r16
    push r16
    push r16
    push r16
    push r16
    push r16
    push r16
    push r16

    ; The eight PUSHes themselves are the stack-depth exercise. Do not use
    ; Z as a writable frame pointer here: an off-by-one stack address can
    ; overwrite saved state or a return address. Keep the deterministic
    ; computation in registers while SP remains eight bytes deeper.
    mov r20, r24
    ldi r21, 7
    add r20, r21

    in r18, _SFR_IO_ADDR(SPL)
    sts budget_sp_deep, r18
    in r18, _SFR_IO_ADDR(SPH)
    sts budget_sp_deep+1, r18

    ; Equivalent result to local[0] + local[7]: x + (x + 7).
    add r24, r20

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
