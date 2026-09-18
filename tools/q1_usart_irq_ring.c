#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "sim_avr.h"
#include "sim_elf.h"
#include "avr_uart.h"

static const uint8_t message[] = "0123456789ABCDEF0123456789ABCDEF";
static uint8_t echoed[sizeof(message)-1];
static size_t echoed_len;

static void tx_hook(struct avr_irq_t *irq, uint32_t value, void *param)
{
    (void)irq; (void)param;
    if (echoed_len < sizeof(echoed)) echoed[echoed_len++] = (uint8_t)value;
}

int main(int argc, char **argv)
{
    if (argc != 2) return 2;
    elf_firmware_t fw; memset(&fw, 0, sizeof(fw));
    if (elf_read_firmware(argv[1], &fw) < 0) return 2;
    if (!fw.mmcu[0]) strcpy(fw.mmcu, "atmega1284p");
    if (!fw.frequency) fw.frequency = 8000000;
    avr_t *avr = avr_make_mcu_by_name(fw.mmcu);
    if (!avr) return 2;
    avr_init(avr); avr_load_firmware(avr, &fw);

    uint32_t flags = 0;
    avr_ioctl(avr, AVR_IOCTL_UART_GET_FLAGS('0'), &flags);
    flags &= ~AVR_UART_FLAG_STDIO;
    avr_ioctl(avr, AVR_IOCTL_UART_SET_FLAGS('0'), &flags);

    avr_irq_t *rx = avr_io_getirq(avr, AVR_IOCTL_UART_GETIRQ('0'), UART_IRQ_INPUT);
    avr_irq_t *tx = avr_io_getirq(avr, AVR_IOCTL_UART_GETIRQ('0'), UART_IRQ_OUTPUT);
    avr_irq_t *xon = avr_io_getirq(avr, AVR_IOCTL_UART_GETIRQ('0'), UART_IRQ_OUT_XON);
    if (!rx || !tx) return 2;
    avr_irq_register_notify(tx, tx_hook, NULL);

    size_t sent = 0;
    uint64_t limit = avr->cycle + (uint64_t)avr->frequency * 4;
    while (avr->cycle < limit && echoed_len < sizeof(echoed)) {
        int state = avr_run(avr);
        if (state == cpu_Done || state == cpu_Crashed) return 1;
        if (sent < sizeof(message)-1 && (!xon || xon->value))
            avr_raise_irq(rx, message[sent++]);
    }
    if (sent != sizeof(message)-1 || echoed_len != sizeof(echoed) ||
        memcmp(message, echoed, sizeof(echoed))) {
        fprintf(stderr, "USART0 IRQ RING FAIL: sent=%zu echoed=%zu\n", sent, echoed_len);
        return 1;
    }
    puts("USART0 IRQ RING PASS: 32-byte interrupt loopback");
    return 0;
}
