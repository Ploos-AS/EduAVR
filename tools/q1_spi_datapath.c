#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "sim_avr.h"
#include "sim_elf.h"
#include "avr_spi.h"

static uint8_t tx_seen;
static unsigned tx_count;
static avr_irq_t *spi_in;

static void spi_out_hook(struct avr_irq_t *irq, uint32_t value, void *param)
{
    (void)irq; (void)param;
    tx_seen = (uint8_t)value;
    ++tx_count;
    /* Deterministic virtual peripheral response to each controller byte. */
    avr_raise_irq(spi_in, (uint8_t)(value ^ 0xffu));
}

int main(int argc, char **argv)
{
    elf_firmware_t fw;
    avr_t *avr;
    avr_irq_t *spi_out;
    uint64_t limit;

    if (argc != 2) {
        fprintf(stderr, "usage: %s firmware.elf\n", argv[0]);
        return 2;
    }

    memset(&fw, 0, sizeof(fw));
    elf_read_firmware(argv[1], &fw);
    if (!fw.mmcu[0])
        strcpy(fw.mmcu, "atmega1284p");
    if (!fw.frequency)
        fw.frequency = 8000000;

    avr = avr_make_mcu_by_name(fw.mmcu);
    if (!avr)
        return 2;
    avr_init(avr);
    avr_load_firmware(avr, &fw);

    spi_in = avr_io_getirq(avr, AVR_IOCTL_SPI_GETIRQ(0), SPI_IRQ_INPUT);
    spi_out = avr_io_getirq(avr, AVR_IOCTL_SPI_GETIRQ(0), SPI_IRQ_OUTPUT);
    if (!spi_in || !spi_out) {
        fprintf(stderr, "SPI IRQs unavailable\n");
        return 2;
    }
    avr_irq_register_notify(spi_out, spi_out_hook, NULL);

    limit = avr->cycle + (uint64_t)avr->frequency;
    while (avr->cycle < limit && tx_count == 0) {
        int state = avr_run(avr);
        if (state == cpu_Done || state == cpu_Crashed)
            return 1;
    }

    if (tx_count == 0 || tx_seen != 0x55) {
        fprintf(stderr, "SPI data-path mismatch: count=%u tx=0x%02x\n", tx_count, tx_seen);
        return 1;
    }

    puts("SPI DATA PATH PASS: TX=0x55 virtual peripheral RX=0xaa");
    return 0;
}
