#include <stdint.h>

typedef struct {
    uint8_t id;
    uint8_t value;
} sample_t;

volatile uint8_t sample_buffer[4];
volatile sample_t current_sample;
volatile uint8_t *volatile sample_ptr;
volatile uint8_t sample_sum;

__attribute__((noinline))
void data_ready(void)
{
    __asm__ volatile ("" ::: "memory");
}

int main(void)
{
    volatile uint8_t *p = sample_buffer;

    p[0] = 0x10;
    p[1] = 0x20;
    p[2] = 0x30;
    p[3] = 0x40;

    sample_ptr = p;
    current_sample.id = 0x2a;
    current_sample.value = p[2];
    sample_sum = (uint8_t)(p[0] + p[1] + p[2] + p[3]);

    data_ready();

    for (;;) {
    }
}
