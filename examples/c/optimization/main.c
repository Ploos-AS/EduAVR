#include <stdint.h>

volatile uint8_t opt_input[8] = { 3, 5, 7, 11, 13, 17, 19, 23 };
volatile uint16_t opt_result;

__attribute__((noinline))
uint16_t weighted_sum(const volatile uint8_t *p)
{
    uint16_t sum = 0;
    for (uint8_t i = 0; i < 8; ++i)
        sum += (uint16_t)p[i] * (uint16_t)(i + 1u);
    return sum;
}

__attribute__((noinline))
void optimization_ready(void)
{
    __asm__ volatile ("" ::: "memory");
}

int main(void)
{
    opt_result = weighted_sum(opt_input);
    optimization_ready();
    for (;;) {}
}
