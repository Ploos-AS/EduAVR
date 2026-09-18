#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "sim_avr.h"
#include "sim_elf.h"
#include "avr_uart.h"

static const uint8_t msg0[]="UART0-to-UART1";
static const uint8_t msg1[]="UART1-to-UART0";
static uint8_t out0[sizeof(msg1)-1],out1[sizeof(msg0)-1];
static size_t n0,n1;
static void tx0(struct avr_irq_t *i,uint32_t v,void*p){(void)i;(void)p;if(n0<sizeof out0)out0[n0++]=(uint8_t)v;}
static void tx1(struct avr_irq_t *i,uint32_t v,void*p){(void)i;(void)p;if(n1<sizeof out1)out1[n1++]=(uint8_t)v;}
int main(int argc,char **argv){
 elf_firmware_t fw; avr_t *a; avr_irq_t *rx0,*rx1,*t0,*t1,*x0,*x1; size_t s0=0,s1=0; uint64_t lim;
 if(argc!=2){fprintf(stderr,"usage: %s firmware.elf\n",argv[0]);return 2;}
 memset(&fw,0,sizeof fw); elf_read_firmware(argv[1],&fw); if(!fw.mmcu[0])strcpy(fw.mmcu,"atmega1284p"); if(!fw.frequency)fw.frequency=8000000;
 a=avr_make_mcu_by_name(fw.mmcu); if(!a)return 2; avr_init(a); avr_load_firmware(a,&fw);
 for(char u='0';u<='1';u++){uint32_t f=0;avr_ioctl(a,AVR_IOCTL_UART_GET_FLAGS(u),&f);f&=~AVR_UART_FLAG_STDIO;avr_ioctl(a,AVR_IOCTL_UART_SET_FLAGS(u),&f);}
 rx0=avr_io_getirq(a,AVR_IOCTL_UART_GETIRQ('0'),UART_IRQ_INPUT); rx1=avr_io_getirq(a,AVR_IOCTL_UART_GETIRQ('1'),UART_IRQ_INPUT);
 t0=avr_io_getirq(a,AVR_IOCTL_UART_GETIRQ('0'),UART_IRQ_OUTPUT); t1=avr_io_getirq(a,AVR_IOCTL_UART_GETIRQ('1'),UART_IRQ_OUTPUT);
 x0=avr_io_getirq(a,AVR_IOCTL_UART_GETIRQ('0'),UART_IRQ_OUT_XON); x1=avr_io_getirq(a,AVR_IOCTL_UART_GETIRQ('1'),UART_IRQ_OUT_XON);
 if(!rx0||!rx1||!t0||!t1)return 2; avr_irq_register_notify(t0,tx0,NULL);avr_irq_register_notify(t1,tx1,NULL);
 lim=a->cycle+(uint64_t)a->frequency*4;
 while(a->cycle<lim&&(n0<sizeof out0||n1<sizeof out1)){int st=avr_run(a);if(st==cpu_Done||st==cpu_Crashed)return 1;
  if(s0<sizeof(msg0)-1&&(!x0||x0->value))avr_raise_irq(rx0,msg0[s0++]);
  if(s1<sizeof(msg1)-1&&(!x1||x1->value))avr_raise_irq(rx1,msg1[s1++]);
 }
 if(s0!=sizeof(msg0)-1||s1!=sizeof(msg1)-1||n1!=sizeof out1||n0!=sizeof out0||memcmp(msg0,out1,sizeof out1)||memcmp(msg1,out0,sizeof out0)){
  fprintf(stderr,"DUAL UART BRIDGE FAIL: sent0=%zu out1=%zu sent1=%zu out0=%zu\n",s0,n1,s1,n0);return 1;}
 puts("DUAL UART BRIDGE PASS: UART0 <-> UART1");return 0;
}
