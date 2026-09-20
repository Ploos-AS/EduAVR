#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <stdint.h>

volatile uint16_t capstone_adc;
volatile uint8_t capstone_calibration;
volatile uint16_t capstone_value;
volatile uint16_t capstone_ticks;
volatile uint8_t capstone_eeprom;
volatile uint8_t capstone_uart_ready;

void capstone_ready(void) __attribute__((noinline, used));
void capstone_ready(void) { __asm__ volatile ("" ::: "memory"); }

ISR(TIMER0_COMPA_vect)
{
    ++capstone_ticks;
}

static void timer_init(void)
{
    TCCR0A = _BV(WGM01);
    OCR0A = 124;
    TCCR0B = _BV(CS01) | _BV(CS00);
    TIMSK0 = _BV(OCIE0A);
}

static void adc_init(void)
{
    ADMUX = _BV(REFS0);
    ADCSRA = _BV(ADEN) | _BV(ADPS2) | _BV(ADPS1);
}

static uint16_t adc_read(void)
{
    ADCSRA |= _BV(ADSC);
    while (ADCSRA & _BV(ADSC)) {
    }
    return ADC;
}

static void usart_init(void)
{
    UBRR0H = 0;
    UBRR0L = 51; /* 9600 baud at 8 MHz, normal speed. */
    UCSR0A = 0;
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);
    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00);
    capstone_uart_ready = 1;
}

int main(void)
{
    timer_init();
    adc_init();
    usart_init();
    sei();

    const uint8_t calibration = 0x5a;
    eeprom_write_byte((uint8_t *)0x20, calibration);
    eeprom_busy_wait();
    capstone_eeprom = eeprom_read_byte((uint8_t *)0x20);
    capstone_calibration = capstone_eeprom;

    capstone_adc = adc_read();
    capstone_value = (uint16_t)(capstone_adc + capstone_calibration);

    /* Make the integration checkpoint deterministic: observe at least one\n       Timer0 compare interrupt before exposing capstone_ready to Q1. */
    while (capstone_ticks == 0) {
    }

    capstone_ready();

    for (;;) {
    }
}
