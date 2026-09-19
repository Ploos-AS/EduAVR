#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "sim_avr.h"
#include "sim_elf.h"
#include "avr_ioport.h"

static uint32_t last_level;
static uint64_t last_cycle;
static uint64_t high_cycles;
static uint64_t low_cycles;
static unsigned edges;

static void pin_hook(struct avr_irq_t *irq, uint32_t value, void *param)
{
    avr_t *avr = (avr_t *)param;
    uint32_t level = value ? 1u : 0u;
    (void)irq;

    if (edges != 0) {
        uint64_t span = avr->cycle - last_cycle;
        if (last_level)
            high_cycles += span;
        else
            low_cycles += span;
    }
    last_level = level;
    last_cycle = avr->cycle;
    ++edges;
}

int main(int argc, char **argv)
{
    elf_firmware_t fw;
    avr_t *avr;
    avr_irq_t *oc0a;
    uint64_t limit;
    uint64_t total;
    unsigned duty_per_mille;

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

    oc0a = avr_io_getirq(avr, AVR_IOCTL_IOPORT_GETIRQ('B'), 3);
    if (!oc0a) {
        fprintf(stderr, "PB3 IRQ unavailable\n");
        return 2;
    }
    avr_irq_register_notify(oc0a, pin_hook, avr);

    limit = avr->cycle + 200000;
    while (avr->cycle < limit && edges < 40) {
        int state = avr_run(avr);
        if (state == cpu_Done || state == cpu_Crashed)
            return 1;
    }

    total = high_cycles + low_cycles;
    if (edges < 10 || total == 0) {
        fprintf(stderr, "PWM waveform not observed: edges=%u\n", edges);
        return 1;
    }

    duty_per_mille = (unsigned)((high_cycles * 1000u) / total);
    if (duty_per_mille < 220 || duty_per_mille > 280) {
        fprintf(stderr, "PWM duty mismatch: %u.%u%% edges=%u\n",
                duty_per_mille / 10, duty_per_mille % 10, edges);
        return 1;
    }

    printf("PWM WAVEFORM PASS: duty=%u.%u%% edges=%u\n",
           duty_per_mille / 10, duty_per_mille % 10, edges);
    return 0;
}
