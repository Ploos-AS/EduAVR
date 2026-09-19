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
    ; Preserve the ABI call-saved Y register, then reserve exactly
    ; 8 bytes of local stack storage using ordinary PUSH operations.
    push r28
    push r29
    push r18
    push r18
    push r18
    push r18
    push r18
    push r18
    push r18
    push r18

    ; Y points at the first byte of the local frame.
    in r28, _SFR_IO_ADDR(SPL)
    in r29, _SFR_IO_ADDR(SPH)

    mov r18, r24
    ldi r19, 8
1:
    st Y+, r18
    inc r18
    dec r19
    brne 1b

    in r18, _SFR_IO_ADDR(SPL)
    sts budget_sp_deep, r18
    in r19, _SFR_IO_ADDR(SPH)
    sts budget_sp_deep+1, r19

    in r28, _SFR_IO_ADDR(SPL)
    in r29, _SFR_IO_ADDR(SPH)
    ld r24, Y
    adiw r28, 7
    ld r18, Y
    add r24, r18

    ; The 8 local bytes are ordinary stack slots. They may be
    ; discarded with POP because r18 is call-clobbered.
    pop r18
    pop r18
    pop r18
    pop r18
    pop r18
    pop r18
    pop r18
    pop r18
    pop r29
    pop r28
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
