/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/22/2018
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>

// Declare your global variables here
  int i = 0;
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
    i++ ;
  if ( i == 4 ) {
  
    i = 0 ;
  }
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=1 Bit2=1 Bit1=1 Bit0=1 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 32.768 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// Global enable interrupts
#asm("sei")

while (1)
      {
      if (i == 0) {
		   PORTB.0 = 0;
		   PORTB.1 = 1;
		   PORTB.2 = 1;
		   PORTB.3 = 1;
		   
		   PORTD.0 = 1;
		   PORTD.1 = 1;
		   PORTD.2 = 1;
		   PORTD.3 = 1;
		   PORTD.4 = 0;
		   PORTD.5 = 1; 
		   PORTD.6 = 1;
       }
       else if( i == 1) {
		   PORTB.0 = 1;
		   PORTB.1 = 0;
		   PORTB.2 = 1;
		   PORTB.3 = 1;
		   
		   PORTD.0 = 1;
		   PORTD.1 = 1;
		   PORTD.2 = 1;
		   PORTD.3 = 1;
		   PORTD.4 = 1;
		   PORTD.5 = 1; 
		   PORTD.6 = 0;
       }
       else if( i == 2) {
		   PORTB.0 = 1;
		   PORTB.1 = 1;
		   PORTB.2 = 0;
		   PORTB.3 = 1;
		   
		   PORTD.0 = 1;
		   PORTD.1 = 1;
		   PORTD.2 = 1;
		   PORTD.3 = 1;
		   PORTD.4 = 1;
		   PORTD.5 = 1; 
		   PORTD.6 = 1;
       }
       else if( i == 3 ) {
		   PORTB.0 = 1;
		   PORTB.1 = 1;
		   PORTB.2 = 1;
		   PORTB.3 = 0; 
		   
		   PORTD.0 = 0;
		   PORTD.1 = 1;
		   PORTD.2 = 1;
		   PORTD.3 = 0;
		   PORTD.4 = 0;
		   PORTD.5 = 0; 
		   PORTD.6 = 0;

       }   

       
 

      }
}
