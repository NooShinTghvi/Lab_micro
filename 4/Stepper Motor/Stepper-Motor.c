#include <mega16.h>
#include <delay.h>

void main(void)
{
unsigned char step[8]={0x01,0x03,0x02,0x06,0x04,0x0C,0x08,0x09};   
int i ;    

DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (1<<PORTA0);

DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    while (1){ 
            if(PINA.0==1) {          
             for(i=0;i<=7;i++)        
              {
               PORTC=step[i];       
               delay_ms(2);
              }
            }
           
            if(PINA.0==0) {         
             for(i=7;i>=0;i--)       
              {
               PORTC=step[i];      
               delay_ms(2);
              }
            }  
            
          } 
}
