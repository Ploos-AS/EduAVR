.section .bss
.global sample_buffer
sample_buffer: .skip 4
.global current_sample
current_sample: .skip 2
.global sample_ptr
sample_ptr: .skip 2
.global sample_sum
sample_sum: .skip 1

.section .text
.global data_ready
.type data_ready, @function
data_ready:
    ret
.size data_ready, .-data_ready

.global main
.type main, @function
main:
    ; X points at the four-byte buffer.
    ldi r26, lo8(sample_buffer)
    ldi r27, hi8(sample_buffer)

    ldi r16, 0x10
    st X+, r16
    ldi r16, 0x20
    st X+, r16
    ldi r16, 0x30
    st X+, r16
    ldi r16, 0x40
    st X, r16

    ; Store a pointer to the start of the buffer.
    ldi r26, lo8(sample_buffer)
    ldi r27, hi8(sample_buffer)
    sts sample_ptr, r26
    sts sample_ptr+1, r27

    ; struct sample_t { id, value } has two adjacent bytes.
    ldi r16, 0x2a
    sts current_sample, r16
    lds r16, sample_buffer+2
    sts current_sample+1, r16

    ; Sum the buffer through explicit SRAM loads.
    lds r16, sample_buffer
    lds r17, sample_buffer+1
    add r16, r17
    lds r17, sample_buffer+2
    add r16, r17
    lds r17, sample_buffer+3
    add r16, r17
    sts sample_sum, r16

    call data_ready
1:
    rjmp 1b
.size main, .-main
