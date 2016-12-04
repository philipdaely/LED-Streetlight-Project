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
#define RX_BUFFER_SIZE0 1000  // USART0 Receiver buffer
#define RX_BUFFER_SIZE1 1000  // USART1 Receiver buffer
#define RX_BUFFER_SIZE2 255 // USART2 Receiver buffer
#define RX_BUFFER_SIZE3 255 // USART3 Receiver buffer
#define ADC_VREF_TYPE 0x40
#define _ALTERNATE_GETCHAR_
#define _ALTERNATE_PUTCHAR_
#define USART0 0
#define USART1 1
#define USART2 2
#define USART3 3
#define STX 0x02
#define ETX 0x03
#define CR 0x0D
#define LF 0x0A
#define delimiter 0x3A
#define XBEE_START_DELIMITER 0x7E
#define XBEE_LENGTH_MSB 0x00
#define XBEE_FRAME_TYPE_TXREQ 0x10
#define XBEE_FRAME_TYPE_RXPACKET 0x90
#define XBEE_FRAME_ID 0x00
#define XBEE_16BIT_ADDRESS 0xFFFE
#define BROADCAST_RADIUS 0x00
#define XBEE_TX_OPTIONS 0x00

#define DATA_OUT PORTC.0
#define DATA_IN PINC.0
#define SCK PORTC.1
#define noACK 0
#define ACK 1
#define STATUS_REG_W 0x06
#define STATUS_REG_R 0x07
#define MEASURE_TEMP 0x03
#define MEASURE_HUMI 0x05
#define RESET 0x1E


const int DEV_ID=0x3530; //
const char SERVER_IP[]="202.31.199.211";  // 202.31.199.211  gandeva   |||  103.236.201.125  siddiq |||   128.199.129.90 yoonsung   |||
const unsigned int SERVER_PORT=8080;
char rx_buffer0[RX_BUFFER_SIZE0],rx_buffer1[RX_BUFFER_SIZE1],rx_buffer2[RX_BUFFER_SIZE2],rx_buffer3[RX_BUFFER_SIZE3];
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
unsigned char rx_wr_index2,rx_rd_index2,rx_counter2;
unsigned char rx_wr_index3,rx_rd_index3,rx_counter3;
bit rx_buffer_overflow0,rx_buffer_overflow1,rx_buffer_overflow2,rx_buffer_overflow3;
unsigned char poutput;
volatile unsigned long milSecCounter;
char dev_id_chk[5];
unsigned int tempervalue[2]={0,0};

typedef union
    {
        unsigned int i;
        float f;
    }value;

enum {TEMP,HUMI};

const int ledID[]={
    0x3530,
    0x3531,
    0x3532,
    0x3533,
};

const long int led_64bitaddress_high[]={
    0x0013A200,
    0x0013A200,
    0x0013A200,
    0x0013A200,
};


const long int led_64bitaddress_low[]={
    0x408B7A72,
    0x41241D2C,
    0x408ACFE1,
    0x408B85E1,
};

// Declare the functions
#pragma used+
unsigned int read_adc(unsigned char adc_input); // Read the AD conversion result
#pragma used-
char getchar(void); // Get a character from the USART Receiver buffer
void putchar(char c); // Write a character to the USART Transmitter
unsigned int serialAvailable(void); // Count available data in serial receive buffer
void mcuInit(void); // Initialize microcontroller
void xbeeTransmit(char *packet,int _dataLength,long int address64H,long int address64L);
unsigned char xbeeReceive(char * recvPacket);
unsigned char _3gZipCall(unsigned char _state);
unsigned char _3gZipOpen(unsigned char _socketID,unsigned char _type,char *_remoteIP,unsigned int _remotePort);
unsigned char _3gZipSend(unsigned char _socketID,char *_data);
unsigned char _3gZipReceive(char *_data);
void getRequestFromServerAndRespond(void);
void getDataFromZigbeeRouterAndForwardToServer(void);
int hex2int(char c);
int hex2ascii(char c,char d);
unsigned char _3gEchoOff(void);
unsigned int getPM10Concentration(void);
float Calc_SHT71(float p_humidity ,float *p_temperature);
char SHT_Measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode);
char SHT_Write_StatusReg(unsigned char *p_value);
char SHT_Read_StatusReg(unsigned char *p_value, unsigned char *p_checksum);
char SHT_SoftRst(void);
void SHT_ConnectionRest(void);
void SHT_Transstart(void);
char SHT_ReadByte(unsigned char ack);
char SHT_WriteByte(unsigned char bytte);


// Declare arbitrary sensor data
float temperature;
float humidity;
unsigned int dustconcentration;
float current3k=0;
float current5k=1.5;
unsigned int voltage3k=0;
unsigned int voltage5k=260;

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

interrupt [USART3_RXC] void usart3_rx_isr(void) // USART3 Receiver interrupt service routine
{
    char status,data;
    status=UCSR3A;
    data=UDR3;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
       {
       rx_buffer3[rx_wr_index3]=data;
       if (++rx_wr_index3 == RX_BUFFER_SIZE3) rx_wr_index3=0;
       if (++rx_counter3 == RX_BUFFER_SIZE3)
          {
          rx_counter3=0;
          rx_buffer_overflow3=1;
          };
       };
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void) // Timer 0 overflow interrupt service routine, called every 1.024 ms (250 kHz)
{
    milSecCounter++;
}

void main(void)
{
    unsigned char packindex;
    unsigned long timecounter;
    char periodicpacket[45],periodicpacket3g[90];
    value humi_val,temp_val;
    unsigned char error,checksum;
    char inp;

    mcuInit();
    sprintf(dev_id_chk,"%c%c:",(char)(DEV_ID>>8),(char)(DEV_ID));
    memset(periodicpacket,0,sizeof(periodicpacket));
    memset(periodicpacket3g,0,sizeof(periodicpacket3g));
    timecounter=milSecCounter;
    while ((milSecCounter-timecounter)<15000);
    SHT_SoftRst();
    _3gEchoOff();
    _3gZipCall(0);
    _3gZipCall(1);
    delay_ms(2000);
    _3gZipOpen(1,0,SERVER_IP,SERVER_PORT);
    delay_ms(2000);

    timecounter=milSecCounter;
    while (1)
        {
            if ((milSecCounter-timecounter)>=19999)
                {
                    error=0;
                    error+=SHT_Measure((unsigned char*)( &humi_val.i),&checksum,HUMI);  //measure humidity
                    error+=SHT_Measure((unsigned char*) (&temp_val.i),&checksum,TEMP);  //measure temperature
                    error += SHT_Read_StatusReg(&inp, &checksum);
                    if (error!=0) SHT_ConnectionRest();
                    else
                        {
                            humi_val.f=(float)tempervalue[1];                   //converts integer to float
                            temp_val.f=(float)tempervalue[0];                   //converts integer to float
                            humi_val.f=Calc_SHT71(humi_val.f,&temp_val.f);      //calculate humidity, temperature
                        }
                    temperature=temp_val.f;
                    humidity=humi_val.f;
                    dustconcentration=getPM10Concentration();

                    //for testing only***********
                    //poutput=USART3;
                    //printf("%c%c%cT%+04.1fH%04.1f3V%03uI%03.1f5V%03uI%03.1fD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,voltage3k,current3k,voltage5k,current5k,dustconcentration,ETX,CR,LF);
                    //***************************

                    sprintf(periodicpacket,"%c%c%cT%+04.1fH%04.1f3V%03uI%03.1f5V%03uI%03.1fD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,voltage3k,current3k,voltage5k,current5k,dustconcentration,ETX,CR,LF);
                    for (packindex=0;packindex<strlen(periodicpacket);packindex++) sprintf(periodicpacket3g+strlen(periodicpacket3g),"%02X",periodicpacket[packindex]);
//                    _3gZipOpen(1,0,SERVER_IP,SERVER_PORT);
//                    delay_ms(2000);
                    _3gZipSend(1,periodicpacket3g);
                    memset(periodicpacket,0,sizeof(periodicpacket));
                    memset(periodicpacket3g,0,sizeof(periodicpacket3g));
                    milSecCounter=0;
                    timecounter=milSecCounter;
                }
            getRequestFromServerAndRespond();
            getDataFromZigbeeRouterAndForwardToServer();
        };
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

            case USART3:
                while (rx_counter3==0);
                data=rx_buffer3[rx_rd_index3];
                if (++rx_rd_index3 == RX_BUFFER_SIZE3) rx_rd_index3=0;
                #asm("cli")
                --rx_counter3;
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

            case USART3:
                while ((UCSR3A & DATA_REGISTER_EMPTY)==0);
                UDR3=c;
            break;
        }
}

// Count available data in serial receive buffer
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

            case USART3:
                return rx_counter3;
            break;
        }
}

// Initialize microcontroller
void mcuInit(void)
{
    // Crystal Oscillator division factor: 1
    #pragma optsize-
    CLKPR=0x80;
    CLKPR=0x00;
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    DDRC=0x00;
    PORTC=0x00;

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

     // USART3 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART3 Receiver: On
    // USART3 Transmitter: On
    // USART3 Mode: Asynchronous
    // USART3 Baud Rate: 9600
    UCSR3A=0x00;
    UCSR3B=0x98;
    UCSR3C=0x06;
    UBRR3H=0x00;
    UBRR3L=0x67;

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

    // Global enable interrupts
    #asm("sei")
}

void xbeeTransmit(char *packet,int _dataLength,long int address64H,long int address64L)
{
    long int i;
    char checkSum,destByte,locaddH,locaddL;
    int length=0;
    int dataLength=_dataLength;
//    static char frameID=0x01;
//    frameID++;
//    if (frameID==0x00) frameID=0x01;
    locaddL=XBEE_16BIT_ADDRESS;
    locaddH=XBEE_16BIT_ADDRESS>>8;
    checkSum=0xFF;
    length=dataLength+14;
    checkSum-=XBEE_FRAME_TYPE_TXREQ;
    checkSum-=XBEE_FRAME_ID; // checkSum-=frameID;
    checkSum-=locaddL;
    checkSum-=locaddH;
    checkSum-=BROADCAST_RADIUS;
    checkSum-= XBEE_TX_OPTIONS;
    poutput=USART0;
    putchar(XBEE_START_DELIMITER);
    putchar(XBEE_LENGTH_MSB);
    putchar(length);
    putchar(XBEE_FRAME_TYPE_TXREQ);
    putchar(XBEE_FRAME_ID); // putchar(frameID);
    for (i=4;i>0;i--)
        {
            destByte=address64H>>(8*(i-1));
            putchar(destByte);
            checkSum-=destByte;
        }
    for (i=4;i>0;i--)
        {
            destByte=address64L>>(8*(i-1));
            putchar(destByte);
            checkSum-=destByte;
        }
    putchar(locaddH);
    putchar(locaddL);
    putchar(BROADCAST_RADIUS);
    putchar(XBEE_TX_OPTIONS);
    for (i=0;i<dataLength;i++)
        {
            putchar(packet[i]);
            checkSum-=packet[i];
        }
    putchar(checkSum);
}

unsigned char xbeeReceive(char * recvPacket)
{
    char temp=0,lengthMSB=0,lengthLSB=0,index,_64sourceAddress[10]="",_16sourceAddress[4]="",rxOptions=0,_checkSum=0xFF,_recvCheckSum=0;
    int packetLength=0;
    poutput=USART0;
    if (serialAvailable())
        {
            temp=getchar();
            if (temp==XBEE_START_DELIMITER)
                {
                    while (serialAvailable()<2);
                    lengthMSB=getchar();
                    lengthLSB=getchar();
                    packetLength=(lengthMSB<<8)+lengthLSB;
                    if (packetLength>12)
                        {
                            temp=getchar();
                            if (temp==XBEE_FRAME_TYPE_RXPACKET)
                                {
                                    _checkSum-=XBEE_FRAME_TYPE_RXPACKET;
                                    while (serialAvailable()<8);
                                    for (index=0;index<8;index++)
                                        {
                                            temp=getchar();
                                            _64sourceAddress[index]=temp;
                                            _checkSum-=temp;
                                        }
                                    while (serialAvailable()<2);
                                    for (index=0;index<2;index++)
                                        {
                                            temp=getchar();
                                            _16sourceAddress[index]=temp;
                                            _checkSum-=temp;
                                        }
                                    while (serialAvailable()<1);
                                    rxOptions=getchar();
                                    _checkSum-=rxOptions;
                                    while (serialAvailable()<12);
                                    for (index=0;index<(packetLength-12);index++)
                                        {
                                            temp=getchar();
                                            recvPacket[index]=temp;
                                            _checkSum-=temp;
                                        }
                                    while (serialAvailable()<1);
                                    _recvCheckSum=getchar();
                                    if (_recvCheckSum!=_checkSum)
                                        {
                                            memset(recvPacket,0,sizeof(recvPacket));
                                            return 0;
                                        }
                                    else return 1;
                                }
                            else return 0;
                        }
                    else return 0;
                }
            else return 0;
        }
    else return 0;

}

unsigned char _3gEchoOff(void)
{
    char temp=0x00, index=0;
    char _3gRespond[10];
    memset(_3gRespond,0,sizeof(_3gRespond));
    poutput=USART1;
    printf("ATE0\r");
    while (temp!=LF) temp=getchar();
    temp=getchar(); // read 1 character from serial
    while (temp!=LF) // while the read character is not <LF>
        {
            _3gRespond[index]=temp; // put temp value to _3gRespond array
            index++; // increment index
            temp=getchar(); // read a character
            if (index==9) break; // if index reach the last element of _3gRespond array
        }
    if (strstr(_3gRespond,"OK")!=NULL)  return 1;
    else return 0;
}

unsigned char _3gZipCall(unsigned char _state)
{
    char _3gRespond[70];
    char temp=0x00, index=0;
    memset(_3gRespond,0,sizeof(_3gRespond));
    poutput=USART1;
    printf("AT+ZIPCALL=%u\r",_state); // send zipcall command
    //while (serialAvailable()<13); // wait until serial available or 2500 ms passed IF command ATE1 activated
    //for (index=0;index<13;index++) temp=getchar(); // get the same command string that was sent earlier IF command ATE1 activated
    //temp=0x00; // reset temp var
    while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
    //index=0; // reset index var
    if (_state==1)
        {
            temp=getchar(); // read 1 character from serial
            while (temp!=LF) // while the read character is not <LF>
                {
                    _3gRespond[index]=temp; // put temp value to _3gRespond array
                    index++; // increment index
                    temp=getchar(); // read a character
                    if (index==69) break; // if index reach the last element of _3gRespond array
                }
            if (strstr(_3gRespond,"ERROR")!=NULL) // if the  _3gRespond array contains "ERROR",
                {
                    memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                    return 0;
                }
            else if (strstr(_3gRespond,"+ZIPCALL: 1")!=NULL) // else if _3gRespond array contains "+ZIPCALL: 1",
                {
                    memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                    temp=0x00; // reset temp var
                    while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
                    index=0;
                    temp=getchar();
                    while (temp!=LF)
                        {
                            _3gRespond[index]=temp; // put temp value to _3gRespond array
                            index++; // increment index
                            temp=getchar(); // read a character
                            if (index==69) break; // if index reach the last element of _3gRespond array
                        }
                    if (strstr(_3gRespond,"OK")!=NULL) // if the  _3gRespond array contains "OK",
                        {
                            memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                            return 1;
                        }
                    else if (strstr(_3gRespond,"OK")==NULL)
                        {
                            memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                            return 0;
                        }
                }
        }
    else if (_state==0)
        {
            temp=getchar(); // read 1 character from serial
            while (temp!=LF) // while the read character is not <LF>
                {
                    _3gRespond[index]=temp; // put temp value to _3gRespond array
                    index++; // increment index
                    temp=getchar(); // read a character
                    if (index==69) break; // if index reach the last element of _3gRespond array
                }
            if (strstr(_3gRespond,"ERROR")!=NULL) // if the  _3gRespond array contains "ERROR",
                {
                    memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                    return 0;
                }
            else if (strstr(_3gRespond,"OK")!=NULL) // else if _3gRespond array contains "+ZIPCALL: 1",
                {
                    memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                    return 1;
                }
        }
}

unsigned char _3gZipOpen(unsigned char _socketID,unsigned char _type,char *_remoteIP,unsigned int _remotePort)
{
    char _3gRespond[70];
    char temp=0x00, index=0;
    memset(_3gRespond,0,sizeof(_3gRespond));
    poutput=USART1;
    printf("AT+ZIPOPEN=%u,%u,%s,%u\r",_socketID,_type,_remoteIP,_remotePort); // send zipcall command
    //while (serialAvailable()<32); // wait until serial available or 2500 ms passed, IF command ATE1 activated
    //for (index=0;index<32;index++) temp=getchar(); // get the same command string that was sent earlier, IF command ATE1 activated
    temp=0x00; // reset temp var
    while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
    index=0; // reset index var
    temp=getchar(); // read 1 character from serial
    while (temp!=LF) // while the read character is not <LF>
        {
            _3gRespond[index]=temp; // put temp value to _3gRespond array
            index++; // increment index
            temp=getchar(); // read a character
            if (index==69) break; // if index reach the last element of _3gRespond array
        }
    if (strstr(_3gRespond,"ERROR")!=NULL) // if the  _3gRespond array contains "ERROR",
        {
            memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
            return 0;
        }
    else if (strstr(_3gRespond,"+ZIPSTAT: 1")!=NULL) // else if _3gRespond array contains "+ZIPCALL: 1",
        {
            memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
            temp=0x00; // reset temp var
            while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
            index=0;
            temp=getchar();
            while (temp!=LF)
                {
                    _3gRespond[index]=temp; // put temp value to _3gRespond array
                    index++; // increment index
                    temp=getchar(); // read a character
                    if (index==69) break; // if index reach the last element of _3gRespond array
                }
            if (strstr(_3gRespond,"OK")!=NULL) // if the  _3gRespond array contains "OK",
                {
                    memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                    return 1;
                }
            else if (strstr(_3gRespond,"OK")==NULL)
                {
                    memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                    return 0;
                }
        }
}

unsigned char _3gZipSend(unsigned char _socketID,char *_data)
{
    char _3gRespond[70];
    char temp=0x00, index=0;
    memset(_3gRespond,0,sizeof(_3gRespond));
    poutput=USART1;
    printf("AT+ZIPSEND=%u,%s\r",_socketID,_data); // send zipcall command
    //while (serialAvailable()<30); // wait until serial available or 2500 ms passed, IF command ATE1 activated
    //for (index=0;index<(14+strlen(_data));index++) temp=getchar(); // get the same command string that was sent earliear, IF command ATE1 activated
    temp=0x00; // reset temp var
    while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
    index=0; // reset index var
    temp=getchar(); // read 1 character from serial
    while (temp!=LF) // while the read character is not <LF>
        {
            _3gRespond[index]=temp; // put temp value to _3gRespond array
            index++; // increment index
            temp=getchar(); // read a character
            if (index==69) break; // if index reach the last element of _3gRespond array
        }
    if (strstr(_3gRespond,"ERROR")!=NULL) // if the  _3gRespond array contains "ERROR",
        {
            memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
            return 0;
        }
    else if (strstr(_3gRespond,"OK")!=NULL) // else if _3gRespond array contains "+ZIPCALL: 1",
        {
            memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
            temp=0x00; // reset temp var
            while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
            index=0;
            temp=getchar();
            while (temp!=LF)
                {
                    _3gRespond[index]=temp; // put temp value to _3gRespond array
                    index++; // increment index
                    temp=getchar(); // read a character
                    if (index==69) break; // if index reach the last element of _3gRespond array
                }
            if (strstr(_3gRespond,"+ZIPSEND:")!=NULL) // if the  _3gRespond array contains "OK",
                {
                    memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                    return 1;
                }
            else if (strstr(_3gRespond,"+ZIPSEND:")==NULL)
                {
                    memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
                    return 0;
                }
        }
}

int hex2int(char c)
{
    int first=c/16-3;
    int second=c%16;
    int result=first*10+second;
    if (result>9) result--;
    return result;
}

int hex2ascii(char c,char d)
{
    int high=hex2int(c)*16;
    int low=hex2int(d);
    return high+low;
}

unsigned char _3gZipReceive(char *_data)
{
    unsigned char index=0,index1=0;
    char _dataLength=0,buf=0;
    char temp;
    char _3gRespond[100],_dataLengthStr[3],*_3gRespond1;
    memset(_3gRespond,0,sizeof(_3gRespond));
    memset(_dataLengthStr,0,sizeof(_dataLengthStr));
    poutput=USART1;
    if (serialAvailable())
        {
            temp=getchar();
            if (temp=='+')
                {
                    memset(_3gRespond,0,sizeof(_3gRespond));
                    gets(_3gRespond,sizeof(_3gRespond)-1);
                    if ((strstr(_3gRespond,"ZIPRECV:")!=NULL)&&(strstr(_3gRespond,",02")!=NULL))
                        {
                            _3gRespond1=strtok(_3gRespond,",");
                            _3gRespond1=strtok(NULL,",");
                            _3gRespond1=strtok(NULL,",");
                            _dataLength=strlen(_3gRespond1);
                            for (index=0;index<_dataLength;index++)
                                {
                                    if ((index%2)!=0)
                                        {
                                            _data[index1]=hex2ascii(buf,_3gRespond1[index]);
                                            index1++;
                                        }
                                    else buf=_3gRespond1[index];
                                }
                            _data[index1]=0;
                            return 1;
                        }
                    else return 0;
                }
            else return 0;
        }
    else return 0;
}

void getRequestFromServerAndRespond(void)  // no prob
{
    char request[20],_devid[3],_coordresp[40],_coordResponse[80];
    unsigned char index=0,indic1=0;
    int _devID;
    memset(request,0,sizeof(request));
    memset(_devid,0,sizeof(_devid));
    memset(_coordresp,0,sizeof(_coordresp));
    memset(_coordResponse,0,sizeof(_coordResponse));
    indic1=_3gZipReceive(request);

    if (indic1==1)
        {
            if (strstr(request,dev_id_chk)!=NULL) // if the serial_command contains this device's ID
                {
                    if (strstr(request,":ON3K")!=NULL)  //  if the request is to turn on LED 3K
                        {
                            current3k=1.5;
                            voltage3k=260;
                        }
                    else if (strstr(request,":ON5K")!=NULL)  //  if the request is to turn on LED 5K
                        {
                            current5k=1.5;
                            voltage5k=260;
                        }
                    else if (strstr(request,":OFF3K")!=NULL)  //  if the request is to turn off LED 3K
                        {
                            current3k=0.0;
                            voltage3k=0;
                        }
                    else if (strstr(request,":OFF5K")!=NULL)  //  if the request is to turn off LED 5K
                        {
                            current5k=0.0;
                            voltage5k=0;
                        }
                    else if (strstr(request,":TH")!=NULL)  //  if the request is to send temperature and humidity value
                        {
                            sprintf(_coordresp,"%c%c%cT%+04.1fH%04.1f%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,ETX,CR,LF);
                            for (index=0;index<strlen(_coordresp);index++) sprintf(_coordResponse+strlen(_coordResponse),"%02X",_coordresp[index]);
                            //_3gZipOpen(1,0,SERVER_IP,SERVER_PORT);
                            _3gZipSend(1,_coordResponse);
                        }
                    else if (strstr(request,":VI")!=NULL)  //  if the request is to send voltage and current value
                        {
                            sprintf(_coordresp,"%c%c%c3V%03uI%03.1f5V%03uI%03.1f%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),voltage3k,current3k,voltage5k,current5k,ETX,CR,LF);
                            for (index=0;index<strlen(_coordresp);index++) sprintf(_coordResponse+strlen(_coordResponse),"%02X",_coordresp[index]);
                            //_3gZipOpen(1,0,SERVER_IP,SERVER_PORT);
                            _3gZipSend(1,_coordResponse);
                        }
                    else if (strstr(request,":D")!=NULL)    //  if the request is to send dust concentration value
                        {
                            sprintf(_coordresp,"%c%c%cD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),dustconcentration,ETX,CR,LF);
                            for (index=0;index<strlen(_coordresp);index++) sprintf(_coordResponse+strlen(_coordResponse),"%02X",_coordresp[index]);
                            //_3gZipOpen(1,0,SERVER_IP,SERVER_PORT);
                            _3gZipSend(1,_coordResponse);
                        };
                    memset(request,0,sizeof(request)); // reset serial_command array
                }
            else if (strstr(request,dev_id_chk)==NULL)// if the serial_command doesn't contain this device's ID
                {
                    //for (index=1;index<3;index++) _devid[index-1]=request[index];
                    //_devID=atoi(_devid);
                    _devID=(request[1]<<8)+request[2];
                    for (index=0;index<sizeof(ledID);index++)
                        {
                            if (_devID==ledID[index]) break;
                        }
                    xbeeTransmit(request,strlen(request),led_64bitaddress_high[index],led_64bitaddress_low[index]);
                }
        }
}

void getDataFromZigbeeRouterAndForwardToServer(void)
{
    char receivedPacket[40],_3gPacket[80];
    unsigned char index,indic1;
    memset(receivedPacket,0,sizeof(receivedPacket));
    memset(_3gPacket,0,sizeof(_3gPacket));
    indic1=xbeeReceive(receivedPacket);
    if (indic1==1)
        {
            for (index=0;index<strlen(receivedPacket);index++) sprintf(_3gPacket+strlen(_3gPacket),"%02X",receivedPacket[index]);
            //_3gZipOpen(1,0,SERVER_IP,SERVER_PORT);
            _3gZipSend(1,_3gPacket);
        }
}

unsigned int getPM10Concentration(void)
{
    unsigned char i;
    unsigned long d[14],measuredValue;
    unsigned int CAI; // comprehensive air-quality index (korean AQI)
    float pm10Conc;
    poutput=USART2;
    putchar(0x11);
    putchar(0x01);
    putchar(0x01);
    putchar(0xED);
    if (getchar()==0x16)
        {
            if (getchar()==0x0D)
                {
                    if (getchar()==0x01)
                        {
                            for (i=0;i<13;i++) d[i]=getchar();
                        }
                }
        }
    measuredValue=d[0]<<24|d[1]<<16|d[2]<<8|d[3]; //arrange the value
    pm10Conc=measuredValue*0.03528;
    if (pm10Conc>600.0) pm10Conc=600.0; //set 600 as highest concentration value, for CAI conversion purposes

    // PM10 to CAI conversion, see http://www.airkorea.or.kr/eng/cai/cai1
    if ((0.0<=pm10Conc)&&(pm10Conc<31.0)) CAI=(unsigned int)(pm10Conc*5/3);
    else if ((31.0<=pm10Conc)&&(pm10Conc<81.0)) CAI=(unsigned int)(pm10Conc+20);
    else if ((81.0<=pm10Conc)&&(pm10Conc<151.0)) CAI=(unsigned int)((pm10Conc-81)*149/69+101);
    else if ((151.0<=pm10Conc)&&(pm10Conc<=600.0)) CAI=(unsigned int)((pm10Conc-151)*249/449+251);
    return CAI;

    //return (unsigned int)(measuredValue*0.03528); // pm10 concentration in ug/mm3
}

char SHT_WriteByte(unsigned char bytte)
{
    unsigned char i,error=0;
    DDRC = 0b00000011;    //
    for (i=0x80;i>0;i/=2) //shift bit for masking
        {
            if (i & bytte)
            DATA_OUT=1; //masking value with i , write to SENSI-BUS
            else DATA_OUT=0;
            SCK=1;      //clk for SENSI-BUS
            delay_us(5); //pulswith approx. 5 us
            SCK=0;
        }
    DATA_OUT=1;            //release dataline
    DDRC = 0b00000010;    // DATA is Output
    SCK=1;                //clk #9 for ack
    delay_us(2);
    error=DATA_IN;       //check ack (DATA will be pulled down by SHT11)
    delay_us(2);
    SCK=0;
    return error;       //error=1 in case of no acknowledge
}

char SHT_ReadByte(unsigned char ack)
{
    unsigned char i,val=0;
    DDRC = 0b00000010;    // DATA is Input
    for (i=0x80;i>0;i/=2)             //shift bit for masking
        {
            SCK=1;                          //clk for SENSI-BUS
            delay_us(2);
            if (DATA_IN) val=(val | i);        //read bit
            delay_us(2);
            SCK=0;
        }
    DDRC = 0b00000011;    // DATA is Output
    DATA_OUT=!ack;        //in case of "ack==1" pull down DATA-Line
    SCK=1;                //clk #9 for ack
    delay_us(5);          //pulswith approx. 5 us
    SCK=0;
    DATA_OUT=1;           //release DATA-line  //ADD BY LUBING
    return val;
}

void SHT_Transstart(void)
{
    DDRC = 0b00000011;    // DATA is Output
    DATA_OUT=1; SCK=0;   //Initial state
    delay_us(2);
    SCK=1;
    delay_us(2);
    DATA_OUT=0;
    delay_us(2);
    SCK=0;
    delay_us(5);
    SCK=1;
    delay_us(2);
    DATA_OUT=1;
    delay_us(2);
    SCK=0;
    DDRC = 0b00000010;    // DATA is Input
}

void SHT_ConnectionRest(void)
{
    unsigned char i;
    DDRC = 0b00000011;    // DATA is output
    DATA_OUT=1; SCK=0;                    //Initial state
    for(i=0;i<9;i++)                  //9 SCK cycles
        {
            SCK=1;
            delay_us(1);
            SCK=0;
            delay_us(1);
        }
    SHT_Transstart();                   //transmission start
    DDRC = 0b00000010;    // DATA is Input
}

char SHT_SoftRst(void)
{
    unsigned char error=0;
    SHT_ConnectionRest();              //reset communication
    error+=SHT_WriteByte(RESET);       //send RESET-command to sensor
    return error;                     //error=1 in case of no response form the sensor
}

char SHT_Read_StatusReg(unsigned char *p_value, unsigned char *p_checksum)
{
    unsigned char error=0;
    SHT_Transstart();                   //transmission start
    error=SHT_WriteByte(STATUS_REG_R); //send command to sensor
    *p_value=SHT_ReadByte(ACK);        //read status register (8-bit)
    *p_checksum=SHT_ReadByte(noACK);   //read checksum (8-bit)
    return error;                     //error=1 in case of no response form the sensor
}

char SHT_Write_StatusReg(unsigned char *p_value)
{
    unsigned char error=0;
    SHT_Transstart();                   //transmission start
    error+=SHT_WriteByte(STATUS_REG_W);//send command to sensor
    error+=SHT_WriteByte(*p_value);    //send value of status register
    return error;                     //error>=1 in case of no response form the sensor
}

char SHT_Measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode)
{
    unsigned error=0;
    unsigned int temp=0;
    SHT_Transstart();                   //transmission start
    switch(mode)
        {                     //send command to sensor
            case TEMP : error+=SHT_WriteByte(MEASURE_TEMP); break;
            case HUMI : error+=SHT_WriteByte(MEASURE_HUMI); break;
            default      : break;
        }
    DDRC = 0b00000010;    // DATA is input
    while (1)
        {
            if(DATA_IN==0) break; //wait until sensor has finished the measurement
        }
    if(DATA_IN) error+=1;                // or timeout (~2 sec.) is reached
    switch(mode)
        {                     //send command to sensor
            case TEMP : temp=0;
                                temp=SHT_ReadByte(ACK);
                                temp<<=8;
                                tempervalue[0]=temp;
                                temp=0;
                                temp=SHT_ReadByte(ACK);
                                tempervalue[0]|=temp;
                                break;
            case HUMI : temp=0;
                                temp=SHT_ReadByte(ACK);
                                temp<<=8;
                                tempervalue[1]=temp;
                                temp=0;
                                temp=SHT_ReadByte(ACK);
                                tempervalue[1]|=temp;
                                break;
            default      : break;
        }
    *p_checksum =SHT_ReadByte(noACK);  //read checksum
    return error;
}

float Calc_SHT71(float p_humidity ,float *p_temperature)
{
    const float C1=-4.0;              // for 12 Bit
    const float C2=+0.0405;           // for 12 Bit
    const float C3=-0.0000028;        // for 12 Bit
    const float T1=+0.01;             // for 14 Bit @ 5V
    const float T2=+0.00008;           // for 14 Bit @ 5V
    float rh_lin;                     // rh_lin:  Humidity linear
    float rh_true;                    // rh_true: Temperature compensated humidity
    float t=*p_temperature;           // t:       Temperature [Ticks] 14 Bit
    float rh=p_humidity;             // rh:      Humidity [Ticks] 12 Bit
    float t_C;                        // t_C   :  Temperature [?]
    t_C=t*0.01 - 40;                  //calc. temperature from ticks to [?]
    rh_lin=C3*rh*rh + C2*rh + C1;     //calc. humidity from ticks to [%RH]
    rh_true=(t_C-25)*(T1+T2*rh)+rh_lin;   //calc. temperature compensated humidity [%RH]
    if(rh_true>100)rh_true=100;       //cut if the value is outside of
    if(rh_true<0.1)rh_true=0.1;       //the physical possible range
    *p_temperature=t_C;               //return temperature [?]
    return rh_true;
}


