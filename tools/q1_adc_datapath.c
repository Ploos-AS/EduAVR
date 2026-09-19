#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "sim_avr.h"
#include "sim_elf.h"
#include "avr_adc.h"
#include <fcntl.h>
#include <unistd.h>
#include <libelf.h>
#include <gelf.h>

static uint32_t symbol_addr(const char *path, const char *wanted)
{
    uint32_t result = 0;
    if (elf_version(EV_CURRENT) == EV_NONE) return 0;
    int fd = open(path, O_RDONLY);
    if (fd < 0) return 0;
    Elf *elf = elf_begin(fd, ELF_C_READ, NULL);
    if (!elf) { close(fd); return 0; }
    Elf_Scn *scn = NULL;
    while ((scn = elf_nextscn(elf, scn)) != NULL && !result) {
        GElf_Shdr shdr;
        if (!gelf_getshdr(scn, &shdr) || shdr.sh_type != SHT_SYMTAB) continue;
        Elf_Data *data = elf_getdata(scn, NULL);
        if (!data || !shdr.sh_entsize) continue;
        size_t count = shdr.sh_size / shdr.sh_entsize;
        for (size_t i = 0; i < count; ++i) {
            GElf_Sym sym;
            if (!gelf_getsym(data, (int)i, &sym)) continue;
            const char *name = elf_strptr(elf, shdr.sh_link, sym.st_name);
            if (name && strcmp(name, wanted) == 0) {
                uint64_t a = sym.st_value;
                if (a >= 0x800000ULL) a -= 0x800000ULL;
                if (a <= 0xffffULL) result = (uint32_t)a;
                break;
            }
        }
    }
    elf_end(elf);
    close(fd);
    return result;
}

int main(int argc, char **argv)
{
    if (argc != 2) { fprintf(stderr, "usage: %s firmware.elf\n", argv[0]); return 2; }

    elf_firmware_t fw;
    memset(&fw, 0, sizeof(fw));
    if (elf_read_firmware(argv[1], &fw) < 0) return 2;
    avr_t *avr = avr_make_mcu_by_name("atmega1284p");
    if (!avr) return 2;
    avr_init(avr);
    avr_load_firmware(avr, &fw);
    avr->frequency = 8000000;

    uint32_t result_addr = symbol_addr(argv[1], "adc_result");
    if (!result_addr) { fprintf(stderr, "adc_result symbol unavailable\n"); return 2; }

    avr_irq_t *adc0 = avr_io_getirq(avr, AVR_IOCTL_ADC_GETIRQ, ADC_IRQ_ADC0);
    if (!adc0) { fprintf(stderr, "ADC0 IRQ unavailable\n"); return 2; }

    /* simavr's ATmega1284P ADC model uses a 3.3 V AVCC reference unless
       the board harness supplies another reference. 2500 mV therefore
       converts to about 2500/3300 * 1023 = 775. */
    avr_raise_irq(adc0, 2500);

    for (unsigned long i = 0; i < 1000000UL; ++i) {
        avr_run(avr);
        uint16_t value = (uint16_t)avr->data[result_addr] |
                         ((uint16_t)avr->data[result_addr + 1] << 8);
        if (value >= 763 && value <= 787) {
            printf("ADC DATA PATH PASS: ADC0=2500mV result=%u\n", value);
            return 0;
        }
    }

    uint16_t value = (uint16_t)avr->data[result_addr] |
                     ((uint16_t)avr->data[result_addr + 1] << 8);
    fprintf(stderr, "ADC DATA PATH FAIL: ADC0=2500mV result=%u expected ~512\n", value);
    return 1;
}
