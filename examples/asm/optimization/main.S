.section .data
.global opt_input
opt_input:
    .byte 3,5,7,11,13,17,19,23

.section .bss
.global opt_result
opt_result: .skip 2

.section .text
.global weighted_sum
.type weighted_sum, @function
weighted_sum:
    ; X points to eight bytes. r25:r24 is the 16-bit sum.
    mov r26, r24
    mov r27, r25
    clr r24
    clr r25
    ldi r20, 1
    ldi r21, 8
1:
    ld r18, X+
    mul r18, r20
    add r24, r0
    adc r25, r1
    clr r1
    inc r20
    dec r21
    brne 1b
    ret
.size weighted_sum, .-weighted_sum

.global optimization_ready
.type optimization_ready, @function
optimization_ready:
    ret
.size optimization_ready, .-optimization_ready

.global main
.type main, @function
main:
    ldi r24, lo8(opt_input + 0x800000)
    ldi r25, hi8(opt_input + 0x800000)
    call weighted_sum
    sts opt_result, r24
    sts opt_result+1, r25
    call optimization_ready
2:
    rjmp 2b
.size main, .-main
