#include <avr/io.h>
#include <stdint.h>

volatile uint8_t stack_result;
volatile uint16_t stack_sp_before;
volatile uint16_t stack_sp_inside;
volatile uint16_t stack_sp_after;

static inline uint16_t read_sp(void)
{
    uint8_t spl;
    uint8_t sph;

    __asm__ volatile (
        "in %0, %2\n\t"
        "in %1, %3"
        : "=r" (spl), "=r" (sph)
        : "I" (_SFR_IO_ADDR(SPL)), "I" (_SFR_IO_ADDR(SPH))
    );

    return ((uint16_t)sph << 8) | spl;
}

__attribute__((noinline))
uint8_t abi_add8(uint8_t a, uint8_t b)
{
    volatile uint8_t saved = a;
    stack_sp_inside = read_sp();
    return (uint8_t)(saved + b);
}

__attribute__((noinline))
void stack_ready(void)
{
    __asm__ volatile ("" ::: "memory");
}

int main(void)
{
    stack_sp_before = read_sp();
    stack_result = abi_add8(0x12, 0x34);
    stack_sp_after = read_sp();
    stack_ready();

    for (;;) {
    }
}
