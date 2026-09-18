#include <avr/io.h>
#include <stdint.h>
typedef enum { UART_PARITY_NONE, UART_PARITY_EVEN, UART_PARITY_ODD } uart_parity_t;
typedef struct { uint32_t baud; uint8_t data_bits, stop_bits; uart_parity_t parity; } uart_config_t;
typedef struct { volatile uint16_t rx_bytes, tx_bytes, frame_errors, overrun_errors, parity_errors, dropped_bytes; } uart_stats_t;
uart_stats_t uart0_stats;
static uint16_t ubrr_for(uint32_t baud){ return (uint16_t)((8000000UL/(16UL*baud))-1UL); }
uint8_t uart0_configure(const uart_config_t *c){
 if(!c||!c->baud||c->data_bits<5||c->data_bits>8||(c->stop_bits!=1&&c->stop_bits!=2))return 0;
 uint16_t u=ubrr_for(c->baud); UBRR0H=(uint8_t)(u>>8);UBRR0L=(uint8_t)u;UCSR0A=0;
 uint8_t x=0; if(c->stop_bits==2)x|=_BV(USBS0);
 if(c->parity==UART_PARITY_EVEN)x|=_BV(UPM01);else if(c->parity==UART_PARITY_ODD)x|=_BV(UPM01)|_BV(UPM00);else if(c->parity!=UART_PARITY_NONE)return 0;
 switch(c->data_bits){case 6:x|=_BV(UCSZ00);break;case 7:x|=_BV(UCSZ01);break;case 8:x|=_BV(UCSZ01)|_BV(UCSZ00);break;default:break;}
 UCSR0C=x;UCSR0B=_BV(RXEN0)|_BV(TXEN0);return 1;
}
uint8_t uart0_receive(uint8_t *v){
 if(!(UCSR0A&_BV(RXC0)))return 0; uint8_t s=UCSR0A;uint8_t d=UDR0;uart0_stats.rx_bytes++;
 if(s&_BV(FE0))uart0_stats.frame_errors++;if(s&_BV(DOR0))uart0_stats.overrun_errors++;if(s&_BV(UPE0))uart0_stats.parity_errors++;*v=d;return 1;
}
uint8_t uart0_send(uint8_t v){if(!(UCSR0A&_BV(UDRE0)))return 0;UDR0=v;uart0_stats.tx_bytes++;return 1;}
void uart_robust_ready(void)__attribute__((noinline,used));void uart_robust_ready(void){__asm__ __volatile__("":::"memory");}
int main(void){uart_config_t c={9600,8,1,UART_PARITY_NONE};uint8_t v;if(!uart0_configure(&c))for(;;){}uart_robust_ready();for(;;)if(uart0_receive(&v))while(!uart0_send(v)){}}
