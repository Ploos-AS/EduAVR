#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "sim_avr.h"
#include "sim_elf.h"
#include "avr_twi.h"
#include <fcntl.h>
#include <unistd.h>
#include <libelf.h>
#include <gelf.h>

typedef struct {
    avr_t *avr;
    avr_irq_t *input;
    unsigned selected;
    unsigned index;
    uint8_t reg;
    uint8_t mem[256];
    unsigned saw_start, saw_addr, saw_write, saw_read, saw_stop;
} peer_t;

static void peer_out(struct avr_irq_t *irq, uint32_t value, void *param)
{
    (void)irq;
    peer_t *p = param;
    avr_twi_msg_irq_t v;
    v.u.v = value;

    if (v.u.twi.msg & TWI_COND_START) {
        p->saw_start++;
        if ((v.u.twi.addr & 0xfe) == 0xa0 || v.u.twi.addr == 0x50) {
            p->selected = 1;
            p->index = 0;
            p->saw_addr++;
            avr_raise_irq(p->input, avr_twi_irq_msg(TWI_COND_ACK, v.u.twi.addr, 1));
        }
    }
    if (v.u.twi.msg & TWI_COND_WRITE) {
        if (!p->selected) return;
        p->saw_write++;
        if (p->index++ == 0) p->reg = v.u.twi.data;
        else p->mem[p->reg++] = v.u.twi.data;
        avr_raise_irq(p->input, avr_twi_irq_msg(TWI_COND_ACK, v.u.twi.addr, 1));
    }
    if (v.u.twi.msg & TWI_COND_READ) {
        if (!p->selected) return;
        p->saw_read++;
        avr_raise_irq(p->input, avr_twi_irq_msg(TWI_COND_READ, v.u.twi.addr, p->mem[p->reg++]));
    }
    if (v.u.twi.msg & TWI_COND_STOP) {
        p->saw_stop++;
        p->selected = 0;
    }
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

    uint32_t readback_addr = 0;
    if (elf_version(EV_CURRENT) == EV_NONE) return 2;
    int fd = open(argv[1], O_RDONLY);
    if (fd < 0) return 2;
    Elf *elf = elf_begin(fd, ELF_C_READ, NULL);
    if (!elf) { close(fd); return 2; }
    Elf_Scn *scn = NULL;
    while ((scn = elf_nextscn(elf, scn)) != NULL && !readback_addr) {
        GElf_Shdr shdr;
        if (!gelf_getshdr(scn, &shdr) || shdr.sh_type != SHT_SYMTAB) continue;
        Elf_Data *data = elf_getdata(scn, NULL);
        if (!data || !shdr.sh_entsize) continue;
        size_t count = shdr.sh_size / shdr.sh_entsize;
        for (size_t i = 0; i < count; ++i) {
            GElf_Sym sym;
            if (!gelf_getsym(data, (int)i, &sym)) continue;
            const char *name = elf_strptr(elf, shdr.sh_link, sym.st_name);
            if (name && strcmp(name, "twi_readback") == 0) {
                uint64_t addr = sym.st_value;
                if (addr >= 0x800000ULL) addr -= 0x800000ULL;
                if (addr <= 0xffffULL) readback_addr = (uint32_t)addr;
                break;
            }
        }
    }
    elf_end(elf);
    close(fd);
    if (!readback_addr) { fprintf(stderr, "twi_readback symbol unavailable\n"); return 2; }

    peer_t p;
    memset(&p, 0, sizeof(p));
    p.avr = avr;
    p.input = avr_io_getirq(avr, AVR_IOCTL_TWI_GETIRQ(0), TWI_IRQ_INPUT);
    avr_irq_t *output = avr_io_getirq(avr, AVR_IOCTL_TWI_GETIRQ(0), TWI_IRQ_OUTPUT);
    if (!p.input || !output) { fprintf(stderr, "TWI IRQ unavailable\n"); return 2; }
    avr_irq_register_notify(output, peer_out, &p);

    for (unsigned long i = 0; i < 4000000UL && !(p.saw_read && p.saw_stop >= 2); ++i)
        avr_run(avr);

    uint8_t firmware_readback = avr->data[readback_addr];
    if (p.saw_start < 3 || p.saw_addr < 3 || p.saw_write < 3 || !p.saw_read || p.saw_stop < 2 || p.mem[0x10] != 0x55 || firmware_readback != 0x55) {
        fprintf(stderr, "TWI DATA PATH FAIL: start=%u addr=%u writes=%u reads=%u stop=%u mem[10]=0x%02x\\n",
                p.saw_start, p.saw_addr, p.saw_write, p.saw_read, p.saw_stop, p.mem[0x10]);
        fprintf(stderr, "firmware twi_readback=0x%02x expected=0x55\\n", firmware_readback);
        return 1;
    }
    printf("TWI DATA PATH PASS: EEPROM[0x10]=0x55 firmware twi_readback=0x%02x\\n", firmware_readback);
    return 0;
}
