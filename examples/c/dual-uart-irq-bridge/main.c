#include <avr/interrupt.h>
#include <avr/io.h>
#include <stdint.h>
#ifndef F_CPU
#define F_CPU 8000000UL
#endif
#define BAUD 9600UL
#define UBRR_VALUE ((F_CPU/(16UL*BAUD))-1UL)
#define N 32
#define M (N-1)
typedef struct { volatile uint8_t b[N],h,t; } rb_t;
static rb_t rx0,rx1,tx0,tx1;
static uint8_t put(rb_t *r,uint8_t v){uint8_t n=(r->h+1)&M;if(n==r->t)return 0;r->b[r->h]=v;r->h=n;return 1;}
static uint8_t get(rb_t *r,uint8_t *v){if(r->t==r->h)return 0;*v=r->b[r->t];r->t=(r->t+1)&M;return 1;}
ISR(USART0_RX_vect){uint8_t v=UDR0;(void)put(&rx0,v);}
ISR(USART1_RX_vect){uint8_t v=UDR1;(void)put(&rx1,v);}
ISR(USART0_UDRE_vect){uint8_t v;if(get(&tx0,&v))UDR0=v;else UCSR0B&=(uint8_t)~_BV(UDRIE0);}
ISR(USART1_UDRE_vect){uint8_t v;if(get(&tx1,&v))UDR1=v;else UCSR1B&=(uint8_t)~_BV(UDRIE1);}
static void init(void){
 UBRR0H=(uint8_t)(UBRR_VALUE>>8);UBRR0L=(uint8_t)UBRR_VALUE;UCSR0A=0;UCSR0B=_BV(RXEN0)|_BV(TXEN0)|_BV(RXCIE0);UCSR0C=_BV(UCSZ01)|_BV(UCSZ00);
 UBRR1H=(uint8_t)(UBRR_VALUE>>8);UBRR1L=(uint8_t)UBRR_VALUE;UCSR1A=0;UCSR1B=_BV(RXEN1)|_BV(TXEN1)|_BV(RXCIE1);UCSR1C=_BV(UCSZ11)|_BV(UCSZ10);
}
void dual_uart_irq_ready(void)__attribute__((noinline,used));void dual_uart_irq_ready(void){__asm__ __volatile__("":::"memory");}
int main(void){uint8_t v;init();sei();dual_uart_irq_ready();for(;;){
 if(get(&rx0,&v)){while(!put(&tx1,v)){}UCSR1B|=_BV(UDRIE1);}
 if(get(&rx1,&v)){while(!put(&tx0,v)){}UCSR0B|=_BV(UDRIE0);}
}}
