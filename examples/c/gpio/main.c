#include <avr/io.h>

__attribute__((noinline))
void gpio_ready(void)
{
    __asm__ volatile ("" ::: "memory");
}

int main(void)
{
    DDRB = _BV(DDB0);
    PORTB = _BV(PORTB1);
    gpio_ready();

    for (;;) {
    }
}
