#include <avr/io.h>
#include <stdint.h>

volatile uint8_t budget_result;
volatile uint16_t budget_sp_before;
volatile uint16_t budget_sp_deep;
volatile uint16_t budget_sp_after;
volatile uint8_t budget_static[16];

static inline uint16_t read_sp(void)
{
    uint8_t lo, hi;
    __asm__ volatile ("in %0,%2\n\tin %1,%3"
        : "=r"(lo), "=r"(hi)
        : "I"(_SFR_IO_ADDR(SPL)), "I"(_SFR_IO_ADDR(SPH)));
    return ((uint16_t)hi << 8) | lo;
}

__attribute__((noinline))
static uint8_t budget_worker(uint8_t seed)
{
    volatile uint8_t local[8];
    for (uint8_t i = 0; i < 8; ++i)
        local[i] = (uint8_t)(seed + i);
    budget_sp_deep = read_sp();
    return (uint8_t)(local[0] + local[7]);
}

void budget_ready(void) __attribute__((noinline, used));
void budget_ready(void) { __asm__ __volatile__("" ::: "memory"); }

int main(void)
{
    for (uint8_t i = 0; i < sizeof budget_static; ++i)
        budget_static[i] = i;

    budget_sp_before = read_sp();
    budget_result = budget_worker(0x20);
    budget_sp_after = read_sp();
    budget_ready();
    for (;;) {}
}
