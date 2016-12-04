#include <mega2560.h>
#include <stdio.h>
#include <string.h>
#include <delay.h>
#include <stdlib.h>

#define TXB8 0
#define RXB8 1
#define UPE 2
#define DOR 3
#define FE 4
#define UDRE 5
#define RXC 7
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define STX 0x02
#define ETX 0x03
#define delimiter 0x3A
#define CR 0x0D
#define LF 0x0A
#define DEV_ID 0x3531  //the 16-bit ID for coordinator, taken from the least significant 16-bit of zigbee xbee 64-bit address
#define COORDID1 DEV_ID>>8
#define COORDID2 (char)DEV_ID
#define RX_BUFFER_SIZE0 100
#define RX_BUFFER_SIZE1 100
#define RX_BUFFER_SIZE2 50
#define USART0 0
#define USART1 1
#define USART2 2
#define ADC_VREF_TYPE 0x40
#define _ALTERNATE_GETCHAR_
#define _ALTERNATE_PUTCHAR_

char dev_id_chk[5];
// arbitrary data
float temperature;
float humidity;
unsigned int dustconcentration;
float current3k=0;
float current5k=1.5;
unsigned int voltage3k=0;
unsigned int voltage5k=260;

char rx_buffer0[RX_BUFFER_SIZE0],rx_buffer1[RX_BUFFER_SIZE1],rx_buffer2[RX_BUFFER_SIZE2];
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
unsigned char rx_wr_index2,rx_rd_index2,rx_counter2;
bit rx_buffer_overflow0,rx_buffer_overflow1,rx_buffer_overflow2;
unsigned char poutput;
volatile unsigned long milSecCounter;


// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
    char status,data;
    status=UCSR0A;
    data=UDR0;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
    {
        rx_buffer0[rx_wr_index0]=data;
        if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
        if (++rx_counter0 == RX_BUFFER_SIZE0)
        {
            rx_counter0=0;
            rx_buffer_overflow0=1;
        };
    };
}

// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
    char status,data;
    status=UCSR1A;
    data=UDR1;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
        {
            rx_buffer1[rx_wr_index1]=data;
            if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
            if (++rx_counter1 == RX_BUFFER_SIZE1)
                {
                    rx_counter1=0;
                    rx_buffer_overflow1=1;
                };
        };
}

// USART2 Receiver interrupt service routine
interrupt [USART2_RXC] void usart2_rx_isr(void)
{
    char status,data;
    status=UCSR2A;
    data=UDR2;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
        {
            rx_buffer2[rx_wr_index2]=data;
            if (++rx_wr_index2 == RX_BUFFER_SIZE2) rx_wr_index2=0;
            if (++rx_counter2 == RX_BUFFER_SIZE2)
                {
                    rx_counter2=0;
                    rx_buffer_overflow2=1;
                };
        };
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void) // Timer 0 overflow interrupt service routine, called every 1.024 ms (250 kHz)
{
    milSecCounter++;
}

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
    ADMUX=(adc_input & 0x07) | (ADC_VREF_TYPE & 0xff);
    if (adc_input & 0x08) ADCSRB |= 0x08;
    else ADCSRB &= 0xf7;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=0x40;
    // Wait for the AD conversion to complete
    while ((ADCSRA & 0x10)==0);
    ADCSRA|=0x10;
    return ADCW;
}

// Get a character from the USART Receiver buffer
char getchar(void)
{
    char data;
    switch(poutput)
        {
            case USART0:
                while (rx_counter0==0);
                data=rx_buffer0[rx_rd_index0];
                if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
                #asm("cli")
                --rx_counter0;
                #asm("sei")
                return data;
            break;

            case USART1:
                while (rx_counter1==0);
                data=rx_buffer1[rx_rd_index1];
                if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
                #asm("cli")
                --rx_counter1;
                #asm("sei")
                return data;
            break;

            case USART2:
                while (rx_counter2==0);
                data=rx_buffer2[rx_rd_index2];
                if (++rx_rd_index2 == RX_BUFFER_SIZE2) rx_rd_index2=0;
                #asm("cli")
                --rx_counter2;
                #asm("sei")
                return data;
            break;
        }
}

// Write a character to the USART Transmitter
void putchar(char c)
{
    switch(poutput)
        {
            case USART0:
                while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
                UDR0=c;
            break;

            case USART1:
                while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
                UDR1=c;
            break;

            case USART2:
                while ((UCSR2A & DATA_REGISTER_EMPTY)==0);
                UDR2=c;
            break;
        }
}

unsigned int serialAvailable(void)
{
    switch(poutput)
        {
            case USART0:
                return rx_counter0;
            break;

            case USART1:
                return rx_counter1;
            break;

            case USART2:
                return rx_counter2;
            break;
        }
}

void get_request_and_send_response(void)
{
    unsigned char array_index;
    char received_byte;
    char serial_command[10];
    poutput=USART0;
    if (serialAvailable()>5)
        {
            received_byte=getchar();
            if (received_byte==STX)
                {
                    array_index=0;
                    do
                        {
                            received_byte=getchar();
                            serial_command[array_index]=received_byte;
                            ++array_index;
                        }
                    while (received_byte!=ETX);
                    if (strstr(serial_command,dev_id_chk)!=NULL)
                        {
                            if (strstr(serial_command,":P")!=NULL)  printf("%c%c%cT%+04.1fH%04.1f3V%03uI%03.1f5V%03uI%03.1fD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,voltage3k,current3k,voltage5k,current5k,dustconcentration,ETX,CR,LF);  // periodic data request
                            else if (strstr(serial_command,":ON3K")!=NULL)
                                {
                                    current3k=1.5;
                                    voltage3k=260;
                                }
                            else if (strstr(serial_command,":ON5K")!=NULL)
                                {
                                    current5k=1.5;
                                    voltage5k=260;
                                }
                            else if (strstr(serial_command,":OFF3K")!=NULL)
                                {
                                    current3k=0.0;
                                    voltage3k=0;
                                }
                            else if (strstr(serial_command,":OFF5K")!=NULL)
                                {
                                    current5k=0.0;
                                    voltage5k=0;
                                }
                            else if (strstr(serial_command,":TH")!=NULL) printf("%c%c%cT%+04.1fH%04.1f%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,ETX,CR,LF);
                            else if (strstr(serial_command,":VI")!=NULL) printf("%c%c%c3V%03uI%03.1f5V%03uI%03.1f%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),voltage3k,current3k,voltage5k,current5k,ETX,CR,LF);
                            else if (strstr(serial_command,":D")!=NULL) printf("%c%c%cD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),dustconcentration,ETX,CR,LF);
                            memset(serial_command,0,sizeof(serial_command));
                        }
                    else if (strstr(serial_command,dev_id_chk)==NULL)
                        {
                            memset(serial_command,0,sizeof(serial_command));
                        }
                }
        }
}

void mcuInit(void)
{
    // Crystal Oscillator division factor: 1
    #pragma optsize-
    CLKPR=0x80;
    CLKPR=0x00;
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    TCCR0A=0x00;
    TCCR0B=0x03;
    TCNT0=0x00;
    OCR0A=0x00;
    OCR0B=0x00;
    TIMSK0=0x01;

    // USART0 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART0 Receiver: On
    // USART0 Transmitter: On
    // USART0 Mode: Asynchronous
    // USART0 Baud Rate: 9600
    UCSR0A=0x00;
    UCSR0B=0x98;
    UCSR0C=0x06;
    UBRR0H=0x00;
    UBRR0L=0x67;

    // USART1 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART1 Receiver: On
    // USART1 Transmitter: On
    // USART1 Mode: Asynchronous
    // USART1 Baud Rate: 9600
    UCSR1A=0x00;
    UCSR1B=0x98;
    UCSR1C=0x06;
    UBRR1H=0x00;
    UBRR1L=0x67;

    // USART2 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART2 Receiver: On
    // USART2 Transmitter: On
    // USART2 Mode: Asynchronous
    // USART2 Baud Rate: 9600
    UCSR2A=0x00;
    UCSR2B=0x98;
    UCSR2C=0x06;
    UBRR2H=0x00;
    UBRR2L=0x67;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    ADCSRB=0x00;

    // ADC initialization
    // ADC Clock frequency: 1000.000 kHz
    // ADC Voltage Reference: AVCC pin
    // ADC Auto Trigger Source: Free Running
    // Digital input buffers on ADC0: Off, ADC1: Off, ADC2: Off, ADC3: Off
    // ADC4: On, ADC5: On, ADC6: On, ADC7: On
    DIDR0=0x0F;
    // Digital input buffers on ADC8: On, ADC9: On, ADC10: On, ADC11: On
    // ADC12: On, ADC13: On, ADC14: On, ADC15: On
    DIDR2=0x00;
    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0xA4;
    ADCSRB&=0xF8;

    #asm("sei")
}

void main(void)
{
    unsigned long timecounter;
    int randval;
    mcuInit();
    sprintf(dev_id_chk,"%c%c:",DEV_ID>>8,DEV_ID);
    milSecCounter=0;
    timecounter=milSecCounter;
    while ((milSecCounter-timecounter)<14999);
    while (1)
        {
            if ((milSecCounter-timecounter)>=19999)
                {
                    randval=rand();
                    temperature=((0.6*randval)/32767.0)+6.7; // random from 6.7 to 7.3
                    humidity=5.0*randval/32767.0+55.0; //  random from 55 to 60
                    dustconcentration=5.0*randval/32767.0+65.0; //  random from 65 to 70
                    printf("%c%c%cT%+04.1fH%04.1f3V%03uI%03.1f5V%03uI%03.1fD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,voltage3k,current3k,voltage5k,current5k,dustconcentration,ETX,CR,LF);
                    milSecCounter=0;
                    timecounter=milSecCounter;
                }
            get_request_and_send_response();
        };
}
