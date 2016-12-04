
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega2560
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 2048 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega2560
	#pragma AVRPART MEMORY PROG_FLASH 262144
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 8192
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x200

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x74
	.EQU XMCRB=0x75
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R3
	.DEF _rx_rd_index0=R5
	.DEF _rx_counter0=R7
	.DEF _rx_wr_index1=R9
	.DEF _rx_rd_index1=R11
	.DEF _rx_counter1=R13

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart2_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  _usart3_rx_isr
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x30,0x35
_0x4:
	.DB  0x32,0x30,0x32,0x2E,0x33,0x31,0x2E,0x31
	.DB  0x39,0x39,0x2E,0x32,0x31,0x31
_0x5:
	.DB  0x90,0x1F
_0x6:
	.DB  0x30,0x35,0x31,0x35,0x32,0x35,0x33,0x35
_0x7:
	.DB  0x0,0xA2,0x13,0x0,0x0,0xA2,0x13,0x0
	.DB  0x0,0xA2,0x13,0x0,0x0,0xA2,0x13
_0x8:
	.DB  0x72,0x7A,0x8B,0x40,0x2C,0x1D,0x24,0x41
	.DB  0xE1,0xCF,0x8A,0x40,0xE1,0x85,0x8B,0x40
_0x9:
	.DB  0x0,0x0,0xC0,0x3F
_0xA:
	.DB  0x4,0x1
_0x6B:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0
_0x17B:
	.DB  0xAC,0xC5,0xA7,0x38,0xA,0xD7,0x23,0x3C
	.DB  0xA2,0xE7,0x3B,0xB6,0x54,0xE3,0x25,0x3D
	.DB  0x0,0x0,0x80,0xC0
_0x0:
	.DB  0x25,0x63,0x25,0x63,0x3A,0x0,0x25,0x63
	.DB  0x25,0x63,0x25,0x63,0x54,0x25,0x2B,0x30
	.DB  0x34,0x2E,0x31,0x66,0x48,0x25,0x30,0x34
	.DB  0x2E,0x31,0x66,0x33,0x56,0x25,0x30,0x33
	.DB  0x75,0x49,0x25,0x30,0x33,0x2E,0x31,0x66
	.DB  0x35,0x56,0x25,0x30,0x33,0x75,0x49,0x25
	.DB  0x30,0x33,0x2E,0x31,0x66,0x44,0x25,0x30
	.DB  0x33,0x75,0x25,0x63,0x25,0x63,0x25,0x63
	.DB  0x0,0x25,0x30,0x32,0x58,0x0,0x41,0x54
	.DB  0x45,0x30,0xD,0x0,0x4F,0x4B,0x0,0x41
	.DB  0x54,0x2B,0x5A,0x49,0x50,0x43,0x41,0x4C
	.DB  0x4C,0x3D,0x25,0x75,0xD,0x0,0x45,0x52
	.DB  0x52,0x4F,0x52,0x0,0x2B,0x5A,0x49,0x50
	.DB  0x43,0x41,0x4C,0x4C,0x3A,0x20,0x31,0x0
	.DB  0x41,0x54,0x2B,0x5A,0x49,0x50,0x4F,0x50
	.DB  0x45,0x4E,0x3D,0x25,0x75,0x2C,0x25,0x75
	.DB  0x2C,0x25,0x73,0x2C,0x25,0x75,0xD,0x0
	.DB  0x2B,0x5A,0x49,0x50,0x53,0x54,0x41,0x54
	.DB  0x3A,0x20,0x31,0x0,0x41,0x54,0x2B,0x5A
	.DB  0x49,0x50,0x53,0x45,0x4E,0x44,0x3D,0x25
	.DB  0x75,0x2C,0x25,0x73,0xD,0x0,0x2B,0x5A
	.DB  0x49,0x50,0x53,0x45,0x4E,0x44,0x3A,0x0
	.DB  0x5A,0x49,0x50,0x52,0x45,0x43,0x56,0x3A
	.DB  0x0,0x2C,0x30,0x32,0x0,0x2C,0x0,0x3A
	.DB  0x4F,0x4E,0x33,0x4B,0x0,0x3A,0x4F,0x4E
	.DB  0x35,0x4B,0x0,0x3A,0x4F,0x46,0x46,0x33
	.DB  0x4B,0x0,0x3A,0x4F,0x46,0x46,0x35,0x4B
	.DB  0x0,0x3A,0x54,0x48,0x0,0x25,0x63,0x25
	.DB  0x63,0x25,0x63,0x54,0x25,0x2B,0x30,0x34
	.DB  0x2E,0x31,0x66,0x48,0x25,0x30,0x34,0x2E
	.DB  0x31,0x66,0x25,0x63,0x25,0x63,0x25,0x63
	.DB  0x0,0x3A,0x56,0x49,0x0,0x25,0x63,0x25
	.DB  0x63,0x25,0x63,0x33,0x56,0x25,0x30,0x33
	.DB  0x75,0x49,0x25,0x30,0x33,0x2E,0x31,0x66
	.DB  0x35,0x56,0x25,0x30,0x33,0x75,0x49,0x25
	.DB  0x30,0x33,0x2E,0x31,0x66,0x25,0x63,0x25
	.DB  0x63,0x25,0x63,0x0,0x3A,0x44,0x0,0x25
	.DB  0x63,0x25,0x63,0x25,0x63,0x44,0x25,0x30
	.DB  0x33,0x75,0x25,0x63,0x25,0x63,0x25,0x63
	.DB  0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x204005F:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x0E
	.DW  _SERVER_IP
	.DW  _0x4*2

	.DW  0x08
	.DW  _ledID
	.DW  _0x6*2

	.DW  0x0F
	.DW  _led_64bitaddress_high
	.DW  _0x7*2

	.DW  0x10
	.DW  _led_64bitaddress_low
	.DW  _0x8*2

	.DW  0x04
	.DW  _current5k
	.DW  _0x9*2

	.DW  0x02
	.DW  _voltage5k
	.DW  _0xA*2

	.DW  0x03
	.DW  _0x99
	.DW  _0x0*2+76

	.DW  0x06
	.DW  _0xA4
	.DW  _0x0*2+94

	.DW  0x0C
	.DW  _0xA4+6
	.DW  _0x0*2+100

	.DW  0x03
	.DW  _0xA4+18
	.DW  _0x0*2+109

	.DW  0x03
	.DW  _0xA4+21
	.DW  _0x0*2+109

	.DW  0x06
	.DW  _0xA4+24
	.DW  _0x0*2+106

	.DW  0x03
	.DW  _0xA4+30
	.DW  _0x0*2+109

	.DW  0x06
	.DW  _0xC2
	.DW  _0x0*2+130

	.DW  0x0C
	.DW  _0xC2+6
	.DW  _0x0*2+136

	.DW  0x03
	.DW  _0xC2+18
	.DW  _0x0*2+145

	.DW  0x03
	.DW  _0xC2+21
	.DW  _0x0*2+145

	.DW  0x06
	.DW  _0xD7
	.DW  _0x0*2+160

	.DW  0x03
	.DW  _0xD7+6
	.DW  _0x0*2+163

	.DW  0x0A
	.DW  _0xD7+9
	.DW  _0x0*2+166

	.DW  0x0A
	.DW  _0xD7+19
	.DW  _0x0*2+166

	.DW  0x09
	.DW  _0xE8
	.DW  _0x0*2+176

	.DW  0x04
	.DW  _0xE8+9
	.DW  _0x0*2+185

	.DW  0x06
	.DW  _0xF6
	.DW  _0x0*2+191

	.DW  0x06
	.DW  _0xF6+6
	.DW  _0x0*2+197

	.DW  0x07
	.DW  _0xF6+12
	.DW  _0x0*2+203

	.DW  0x07
	.DW  _0xF6+19
	.DW  _0x0*2+210

	.DW  0x04
	.DW  _0xF6+26
	.DW  _0x0*2+217

	.DW  0x04
	.DW  _0xF6+30
	.DW  _0x0*2+249

	.DW  0x03
	.DW  _0xF6+34
	.DW  _0x0*2+292

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x204005F*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRA,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x2000)
	LDI  R25,HIGH(0x2000)
	LDI  R26,LOW(0x200)
	LDI  R27,HIGH(0x200)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

	OUT  EIND,R24

;GPIOR0 INITIALIZATION
	LDI  R30,0x00
	OUT  GPIOR0,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x21FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x21FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0xA00)
	LDI  R29,HIGH(0xA00)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xA00

	.CSEG
;#include <mega2560.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <string.h>
;#include <delay.h>
;#include <stdlib.h>
;
;#define TXB8 0
;#define RXB8 1
;#define UPE 2
;#define DOR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define RX_BUFFER_SIZE0 1000  // USART0 Receiver buffer
;#define RX_BUFFER_SIZE1 1000  // USART1 Receiver buffer
;#define RX_BUFFER_SIZE2 255 // USART2 Receiver buffer
;#define RX_BUFFER_SIZE3 255 // USART3 Receiver buffer
;#define ADC_VREF_TYPE 0x40
;#define _ALTERNATE_GETCHAR_
;#define _ALTERNATE_PUTCHAR_
;#define USART0 0
;#define USART1 1
;#define USART2 2
;#define USART3 3
;#define STX 0x02
;#define ETX 0x03
;#define CR 0x0D
;#define LF 0x0A
;#define delimiter 0x3A
;#define XBEE_START_DELIMITER 0x7E
;#define XBEE_LENGTH_MSB 0x00
;#define XBEE_FRAME_TYPE_TXREQ 0x10
;#define XBEE_FRAME_TYPE_RXPACKET 0x90
;#define XBEE_FRAME_ID 0x00
;#define XBEE_16BIT_ADDRESS 0xFFFE
;#define BROADCAST_RADIUS 0x00
;#define XBEE_TX_OPTIONS 0x00
;
;#define DATA_OUT PORTC.0
;#define DATA_IN PINC.0
;#define SCK PORTC.1
;#define noACK 0
;#define ACK 1
;#define STATUS_REG_W 0x06
;#define STATUS_REG_R 0x07
;#define MEASURE_TEMP 0x03
;#define MEASURE_HUMI 0x05
;#define RESET 0x1E
;
;
;const int DEV_ID=0x3530; //

	.DSEG
;const char SERVER_IP[]="202.31.199.211";  // 202.31.199.211  gandeva   |||  103.236.201.125  siddiq |||   128.199.129.90 yoonsung   |||
;const unsigned int SERVER_PORT=8080;
;char rx_buffer0[RX_BUFFER_SIZE0],rx_buffer1[RX_BUFFER_SIZE1],rx_buffer2[RX_BUFFER_SIZE2],rx_buffer3[RX_BUFFER_SIZE3];
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
;unsigned char rx_wr_index2,rx_rd_index2,rx_counter2;
;unsigned char rx_wr_index3,rx_rd_index3,rx_counter3;
;bit rx_buffer_overflow0,rx_buffer_overflow1,rx_buffer_overflow2,rx_buffer_overflow3;
;unsigned char poutput;
;volatile unsigned long milSecCounter;
;char dev_id_chk[5];
;unsigned int tempervalue[2]={0,0};
;
;typedef union
;    {
;        unsigned int i;
;        float f;
;    }value;
;
;enum {TEMP,HUMI};
;
;const int ledID[]={
;    0x3530,
;    0x3531,
;    0x3532,
;    0x3533,
;};
;
;const long int led_64bitaddress_high[]={
;    0x0013A200,
;    0x0013A200,
;    0x0013A200,
;    0x0013A200,
;};
;
;
;const long int led_64bitaddress_low[]={
;    0x408B7A72,
;    0x41241D2C,
;    0x408ACFE1,
;    0x408B85E1,
;};
;
;// Declare the functions
;#pragma used+
;unsigned int read_adc(unsigned char adc_input); // Read the AD conversion result
;#pragma used-
;char getchar(void); // Get a character from the USART Receiver buffer
;void putchar(char c); // Write a character to the USART Transmitter
;unsigned int serialAvailable(void); // Count available data in serial receive buffer
;void mcuInit(void); // Initialize microcontroller
;void xbeeTransmit(char *packet,int _dataLength,long int address64H,long int address64L);
;unsigned char xbeeReceive(char * recvPacket);
;unsigned char _3gZipCall(unsigned char _state);
;unsigned char _3gZipOpen(unsigned char _socketID,unsigned char _type,char *_remoteIP,unsigned int _remotePort);
;unsigned char _3gZipSend(unsigned char _socketID,char *_data);
;unsigned char _3gZipReceive(char *_data);
;void getRequestFromServerAndRespond(void);
;void getDataFromZigbeeRouterAndForwardToServer(void);
;int hex2int(char c);
;int hex2ascii(char c,char d);
;unsigned char _3gEchoOff(void);
;unsigned int getPM10Concentration(void);
;float Calc_SHT71(float p_humidity ,float *p_temperature);
;char SHT_Measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode);
;char SHT_Write_StatusReg(unsigned char *p_value);
;char SHT_Read_StatusReg(unsigned char *p_value, unsigned char *p_checksum);
;char SHT_SoftRst(void);
;void SHT_ConnectionRest(void);
;void SHT_Transstart(void);
;char SHT_ReadByte(unsigned char ack);
;char SHT_WriteByte(unsigned char bytte);
;
;
;// Declare arbitrary sensor data
;float temperature;
;float humidity;
;unsigned int dustconcentration;
;float current3k=0;
;float current5k=1.5;
;unsigned int voltage3k=0;
;unsigned int voltage5k=260;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 008E {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008F     char status,data;
; 0000 0090     status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0091     data=UDR0;
	LDS  R16,198
; 0000 0092     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xB
; 0000 0093         {
; 0000 0094             rx_buffer0[rx_wr_index0]=data;
	__GETW1R 3,4
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0095             if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	__GETW1R 3,4
	ADIW R30,1
	__PUTW1R 3,4
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0xC
	CLR  R3
	CLR  R4
; 0000 0096             if (++rx_counter0 == RX_BUFFER_SIZE0)
_0xC:
	__GETW1R 7,8
	ADIW R30,1
	__PUTW1R 7,8
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0xD
; 0000 0097                 {
; 0000 0098                     rx_counter0=0;
	CLR  R7
	CLR  R8
; 0000 0099                     rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 009A                 };
_0xD:
; 0000 009B         };
_0xB:
; 0000 009C }
	RJMP _0x182
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 00A0 {
_usart1_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A1     char status,data;
; 0000 00A2     status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,200
; 0000 00A3     data=UDR1;
	LDS  R16,206
; 0000 00A4     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x10
; 0000 00A5         {
; 0000 00A6             rx_buffer1[rx_wr_index1]=data;
	__GETW1R 9,10
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 00A7             if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	__GETW1R 9,10
	ADIW R30,1
	__PUTW1R 9,10
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x11
	CLR  R9
	CLR  R10
; 0000 00A8             if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x11:
	__GETW1R 13,14
	ADIW R30,1
	__PUTW1R 13,14
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x12
; 0000 00A9                 {
; 0000 00AA                     rx_counter1=0;
	CLR  R13
	CLR  R14
; 0000 00AB                     rx_buffer_overflow1=1;
	SBI  0x1E,1
; 0000 00AC                 };
_0x12:
; 0000 00AD         };
_0x10:
; 0000 00AE }
	RJMP _0x182
;
;// USART2 Receiver interrupt service routine
;interrupt [USART2_RXC] void usart2_rx_isr(void)
; 0000 00B2 {
_usart2_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B3     char status,data;
; 0000 00B4     status=UCSR2A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,208
; 0000 00B5     data=UDR2;
	LDS  R16,214
; 0000 00B6     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x15
; 0000 00B7         {
; 0000 00B8             rx_buffer2[rx_wr_index2]=data;
	LDS  R30,_rx_wr_index2
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer2)
	SBCI R31,HIGH(-_rx_buffer2)
	ST   Z,R16
; 0000 00B9             if (++rx_wr_index2 == RX_BUFFER_SIZE2) rx_wr_index2=0;
	LDS  R26,_rx_wr_index2
	SUBI R26,-LOW(1)
	STS  _rx_wr_index2,R26
	CPI  R26,LOW(0xFF)
	BRNE _0x16
	LDI  R30,LOW(0)
	STS  _rx_wr_index2,R30
; 0000 00BA             if (++rx_counter2 == RX_BUFFER_SIZE2)
_0x16:
	LDS  R26,_rx_counter2
	SUBI R26,-LOW(1)
	STS  _rx_counter2,R26
	CPI  R26,LOW(0xFF)
	BRNE _0x17
; 0000 00BB                 {
; 0000 00BC                     rx_counter2=0;
	LDI  R30,LOW(0)
	STS  _rx_counter2,R30
; 0000 00BD                     rx_buffer_overflow2=1;
	SBI  0x1E,2
; 0000 00BE                 };
_0x17:
; 0000 00BF         };
_0x15:
; 0000 00C0 }
	RJMP _0x182
;
;interrupt [USART3_RXC] void usart3_rx_isr(void) // USART3 Receiver interrupt service routine
; 0000 00C3 {
_usart3_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C4     char status,data;
; 0000 00C5     status=UCSR3A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,304
; 0000 00C6     data=UDR3;
	LDS  R16,310
; 0000 00C7     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x1A
; 0000 00C8        {
; 0000 00C9        rx_buffer3[rx_wr_index3]=data;
	LDS  R30,_rx_wr_index3
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer3)
	SBCI R31,HIGH(-_rx_buffer3)
	ST   Z,R16
; 0000 00CA        if (++rx_wr_index3 == RX_BUFFER_SIZE3) rx_wr_index3=0;
	LDS  R26,_rx_wr_index3
	SUBI R26,-LOW(1)
	STS  _rx_wr_index3,R26
	CPI  R26,LOW(0xFF)
	BRNE _0x1B
	LDI  R30,LOW(0)
	STS  _rx_wr_index3,R30
; 0000 00CB        if (++rx_counter3 == RX_BUFFER_SIZE3)
_0x1B:
	LDS  R26,_rx_counter3
	SUBI R26,-LOW(1)
	STS  _rx_counter3,R26
	CPI  R26,LOW(0xFF)
	BRNE _0x1C
; 0000 00CC           {
; 0000 00CD           rx_counter3=0;
	LDI  R30,LOW(0)
	STS  _rx_counter3,R30
; 0000 00CE           rx_buffer_overflow3=1;
	SBI  0x1E,3
; 0000 00CF           };
_0x1C:
; 0000 00D0        };
_0x1A:
; 0000 00D1 }
_0x182:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void) // Timer 0 overflow interrupt service routine, called every 1.024 ms (250 kHz)
; 0000 00D4 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D5     milSecCounter++;
	LDI  R26,LOW(_milSecCounter)
	LDI  R27,HIGH(_milSecCounter)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 00D6 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;void main(void)
; 0000 00D9 {
_main:
; 0000 00DA     unsigned char packindex;
; 0000 00DB     unsigned long timecounter;
; 0000 00DC     char periodicpacket[45],periodicpacket3g[90];
; 0000 00DD     value humi_val,temp_val;
; 0000 00DE     unsigned char error,checksum;
; 0000 00DF     char inp;
; 0000 00E0 
; 0000 00E1     mcuInit();
	SBIW R28,63
	SBIW R28,63
	SBIW R28,21
;	packindex -> R17
;	timecounter -> Y+143
;	periodicpacket -> Y+98
;	periodicpacket3g -> Y+8
;	humi_val -> Y+4
;	temp_val -> Y+0
;	error -> R16
;	checksum -> R19
;	inp -> R18
	RCALL _mcuInit
; 0000 00E2     sprintf(dev_id_chk,"%c%c:",(char)(DEV_ID>>8),(char)(DEV_ID));
	LDI  R30,LOW(_dev_id_chk)
	LDI  R31,HIGH(_dev_id_chk)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x30
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 00E3     memset(periodicpacket,0,sizeof(periodicpacket));
	MOVW R30,R28
	SUBI R30,LOW(-(98))
	SBCI R31,HIGH(-(98))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 00E4     memset(periodicpacket3g,0,sizeof(periodicpacket3g));
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 00E5     timecounter=milSecCounter;
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	__PUTD1SX 143
; 0000 00E6     while ((milSecCounter-timecounter)<15000);
_0x1F:
	__GETD2SX 143
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	CALL __SUBD12
	__CPD1N 0x3A98
	BRLO _0x1F
; 0000 00E7     SHT_SoftRst();
	CALL _SHT_SoftRst
; 0000 00E8     _3gEchoOff();
	CALL __3gEchoOff
; 0000 00E9     _3gZipCall(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL __3gZipCall
; 0000 00EA     _3gZipCall(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __3gZipCall
; 0000 00EB     delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00EC     _3gZipOpen(1,0,SERVER_IP,SERVER_PORT);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_SERVER_IP)
	LDI  R31,HIGH(_SERVER_IP)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8080)
	LDI  R31,HIGH(8080)
	ST   -Y,R31
	ST   -Y,R30
	CALL __3gZipOpen
; 0000 00ED     delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00EE 
; 0000 00EF     timecounter=milSecCounter;
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	__PUTD1SX 143
; 0000 00F0     while (1)
_0x22:
; 0000 00F1         {
; 0000 00F2             if ((milSecCounter-timecounter)>=19999)
	__GETD2SX 143
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	CALL __SUBD12
	__CPD1N 0x4E1F
	BRSH PC+3
	JMP _0x25
; 0000 00F3                 {
; 0000 00F4                     error=0;
	LDI  R16,LOW(0)
; 0000 00F5                     error+=SHT_Measure((unsigned char*)( &humi_val.i),&checksum,HUMI);  //measure humidity
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R19
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _SHT_Measure
	POP  R19
	ADD  R16,R30
; 0000 00F6                     error+=SHT_Measure((unsigned char*) (&temp_val.i),&checksum,TEMP);  //measure temperature
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R19
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _SHT_Measure
	POP  R19
	ADD  R16,R30
; 0000 00F7                     error += SHT_Read_StatusReg(&inp, &checksum);
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R18
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R19
	CALL _SHT_Read_StatusReg
	POP  R19
	POP  R18
	ADD  R16,R30
; 0000 00F8                     if (error!=0) SHT_ConnectionRest();
	CPI  R16,0
	BREQ _0x26
	CALL _SHT_ConnectionRest
; 0000 00F9                     else
	RJMP _0x27
_0x26:
; 0000 00FA                         {
; 0000 00FB                             humi_val.f=(float)tempervalue[1];                   //converts integer to float
	__GETW1MN _tempervalue,2
	CLR  R22
	CLR  R23
	CALL __CDF1
	__PUTD1S 4
; 0000 00FC                             temp_val.f=(float)tempervalue[0];                   //converts integer to float
	LDS  R30,_tempervalue
	LDS  R31,_tempervalue+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTD1S0
; 0000 00FD                             humi_val.f=Calc_SHT71(humi_val.f,&temp_val.f);      //calculate humidity, temperature
	__GETD1S 4
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL _Calc_SHT71
	__PUTD1S 4
; 0000 00FE                         }
_0x27:
; 0000 00FF                     temperature=temp_val.f;
	CALL __GETD1S0
	STS  _temperature,R30
	STS  _temperature+1,R31
	STS  _temperature+2,R22
	STS  _temperature+3,R23
; 0000 0100                     humidity=humi_val.f;
	__GETD1S 4
	STS  _humidity,R30
	STS  _humidity+1,R31
	STS  _humidity+2,R22
	STS  _humidity+3,R23
; 0000 0101                     dustconcentration=getPM10Concentration();
	CALL _getPM10Concentration
	STS  _dustconcentration,R30
	STS  _dustconcentration+1,R31
; 0000 0102 
; 0000 0103                     //for testing only***********
; 0000 0104                     //poutput=USART3;
; 0000 0105                     //printf("%c%c%cT%+04.1fH%04.1f3V%03uI%03.1f5V%03uI%03.1fD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,voltage3k,current3k,voltage5k,current5k,dustconcentration,ETX,CR,LF);
; 0000 0106                     //***************************
; 0000 0107 
; 0000 0108                     sprintf(periodicpacket,"%c%c%cT%+04.1fH%04.1f3V%03uI%03.1f5V%03uI%03.1fD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,voltage3k,current3k,voltage5k,current5k,dustconcentration,ETX,CR,LF);
	MOVW R30,R28
	SUBI R30,LOW(-(98))
	SBCI R31,HIGH(-(98))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x30
	CALL __PUTPARD1
	LDS  R30,_temperature
	LDS  R31,_temperature+1
	LDS  R22,_temperature+2
	LDS  R23,_temperature+3
	CALL __PUTPARD1
	LDS  R30,_humidity
	LDS  R31,_humidity+1
	LDS  R22,_humidity+2
	LDS  R23,_humidity+3
	CALL __PUTPARD1
	LDS  R30,_voltage3k
	LDS  R31,_voltage3k+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current3k
	LDS  R31,_current3k+1
	LDS  R22,_current3k+2
	LDS  R23,_current3k+3
	CALL __PUTPARD1
	LDS  R30,_voltage5k
	LDS  R31,_voltage5k+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current5k
	LDS  R31,_current5k+1
	LDS  R22,_current5k+2
	LDS  R23,_current5k+3
	CALL __PUTPARD1
	LDS  R30,_dustconcentration
	LDS  R31,_dustconcentration+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x3
	CALL __PUTPARD1
	__GETD1N 0xD
	CALL __PUTPARD1
	__GETD1N 0xA
	CALL __PUTPARD1
	LDI  R24,52
	CALL _sprintf
	ADIW R28,56
; 0000 0109                     for (packindex=0;packindex<strlen(periodicpacket);packindex++) sprintf(periodicpacket3g+strlen(periodicpacket3g),"%02X",periodicpacket[packindex]);
	LDI  R17,LOW(0)
_0x29:
	MOVW R30,R28
	SUBI R30,LOW(-(98))
	SBCI R31,HIGH(-(98))
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x2A
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOVW R26,R28
	ADIW R26,8
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,65
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(102))
	SBCI R27,HIGH(-(102))
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	SUBI R17,-1
	RJMP _0x29
_0x2A:
; 0000 010C _3gZipSend(1,periodicpacket3g);
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,9
	ST   -Y,R31
	ST   -Y,R30
	CALL __3gZipSend
; 0000 010D                     memset(periodicpacket,0,sizeof(periodicpacket));
	MOVW R30,R28
	SUBI R30,LOW(-(98))
	SBCI R31,HIGH(-(98))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 010E                     memset(periodicpacket3g,0,sizeof(periodicpacket3g));
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 010F                     milSecCounter=0;
	LDI  R30,LOW(0)
	STS  _milSecCounter,R30
	STS  _milSecCounter+1,R30
	STS  _milSecCounter+2,R30
	STS  _milSecCounter+3,R30
; 0000 0110                     timecounter=milSecCounter;
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	__PUTD1SX 143
; 0000 0111                 }
; 0000 0112             getRequestFromServerAndRespond();
_0x25:
	CALL _getRequestFromServerAndRespond
; 0000 0113             getDataFromZigbeeRouterAndForwardToServer();
	CALL _getDataFromZigbeeRouterAndForwardToServer
; 0000 0114         };
	RJMP _0x22
; 0000 0115 }
_0x2B:
	RJMP _0x2B
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0119 {
; 0000 011A     ADMUX=(adc_input & 0x07) | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 011B     if (adc_input & 0x08) ADCSRB |= 0x08;
; 0000 011C     else ADCSRB &= 0xf7;
; 0000 011D     // Delay needed for the stabilization of the ADC input voltage
; 0000 011E     delay_us(10);
; 0000 011F     // Start the AD conversion
; 0000 0120     ADCSRA|=0x40;
; 0000 0121     // Wait for the AD conversion to complete
; 0000 0122     while ((ADCSRA & 0x10)==0);
; 0000 0123     ADCSRA|=0x10;
; 0000 0124     return ADCW;
; 0000 0125 }
;
;// Get a character from the USART Receiver buffer
;char getchar(void)
; 0000 0129 {
_getchar:
; 0000 012A     char data;
; 0000 012B     switch(poutput)
	ST   -Y,R17
;	data -> R17
	LDS  R30,_poutput
	LDI  R31,0
; 0000 012C         {
; 0000 012D             case USART0:
	SBIW R30,0
	BRNE _0x34
; 0000 012E                 while (rx_counter0==0);
_0x35:
	MOV  R0,R7
	OR   R0,R8
	BREQ _0x35
; 0000 012F                 data=rx_buffer0[rx_rd_index0];
	LDI  R26,LOW(_rx_buffer0)
	LDI  R27,HIGH(_rx_buffer0)
	ADD  R26,R5
	ADC  R27,R6
	LD   R17,X
; 0000 0130                 if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	__GETW1R 5,6
	ADIW R30,1
	__PUTW1R 5,6
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x38
	CLR  R5
	CLR  R6
; 0000 0131                 #asm("cli")
_0x38:
	cli
; 0000 0132                 --rx_counter0;
	__GETW1R 7,8
	SBIW R30,1
	__PUTW1R 7,8
; 0000 0133                 #asm("sei")
	sei
; 0000 0134                 return data;
	MOV  R30,R17
	RJMP _0x20A0011
; 0000 0135             break;
; 0000 0136 
; 0000 0137             case USART1:
_0x34:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x39
; 0000 0138                 while (rx_counter1==0);
_0x3A:
	MOV  R0,R13
	OR   R0,R14
	BREQ _0x3A
; 0000 0139                 data=rx_buffer1[rx_rd_index1];
	LDI  R26,LOW(_rx_buffer1)
	LDI  R27,HIGH(_rx_buffer1)
	ADD  R26,R11
	ADC  R27,R12
	LD   R17,X
; 0000 013A                 if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
	__GETW1R 11,12
	ADIW R30,1
	__PUTW1R 11,12
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x3D
	CLR  R11
	CLR  R12
; 0000 013B                 #asm("cli")
_0x3D:
	cli
; 0000 013C                 --rx_counter1;
	__GETW1R 13,14
	SBIW R30,1
	__PUTW1R 13,14
; 0000 013D                 #asm("sei")
	sei
; 0000 013E                 return data;
	MOV  R30,R17
	RJMP _0x20A0011
; 0000 013F             break;
; 0000 0140 
; 0000 0141             case USART2:
_0x39:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3E
; 0000 0142                 while (rx_counter2==0);
_0x3F:
	LDS  R30,_rx_counter2
	CPI  R30,0
	BREQ _0x3F
; 0000 0143                 data=rx_buffer2[rx_rd_index2];
	LDS  R30,_rx_rd_index2
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer2)
	SBCI R31,HIGH(-_rx_buffer2)
	LD   R17,Z
; 0000 0144                 if (++rx_rd_index2 == RX_BUFFER_SIZE2) rx_rd_index2=0;
	LDS  R26,_rx_rd_index2
	SUBI R26,-LOW(1)
	STS  _rx_rd_index2,R26
	CPI  R26,LOW(0xFF)
	BRNE _0x42
	LDI  R30,LOW(0)
	STS  _rx_rd_index2,R30
; 0000 0145                 #asm("cli")
_0x42:
	cli
; 0000 0146                 --rx_counter2;
	LDS  R30,_rx_counter2
	SUBI R30,LOW(1)
	STS  _rx_counter2,R30
; 0000 0147                 #asm("sei")
	sei
; 0000 0148                 return data;
	MOV  R30,R17
	RJMP _0x20A0011
; 0000 0149             break;
; 0000 014A 
; 0000 014B             case USART3:
_0x3E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x33
; 0000 014C                 while (rx_counter3==0);
_0x44:
	LDS  R30,_rx_counter3
	CPI  R30,0
	BREQ _0x44
; 0000 014D                 data=rx_buffer3[rx_rd_index3];
	LDS  R30,_rx_rd_index3
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer3)
	SBCI R31,HIGH(-_rx_buffer3)
	LD   R17,Z
; 0000 014E                 if (++rx_rd_index3 == RX_BUFFER_SIZE3) rx_rd_index3=0;
	LDS  R26,_rx_rd_index3
	SUBI R26,-LOW(1)
	STS  _rx_rd_index3,R26
	CPI  R26,LOW(0xFF)
	BRNE _0x47
	LDI  R30,LOW(0)
	STS  _rx_rd_index3,R30
; 0000 014F                 #asm("cli")
_0x47:
	cli
; 0000 0150                 --rx_counter3;
	LDS  R30,_rx_counter3
	SUBI R30,LOW(1)
	STS  _rx_counter3,R30
; 0000 0151                 #asm("sei")
	sei
; 0000 0152                 return data;
	MOV  R30,R17
; 0000 0153             break;
; 0000 0154         }
_0x33:
; 0000 0155 }
_0x20A0011:
	LD   R17,Y+
	RET
;
;// Write a character to the USART Transmitter
;void putchar(char c)
; 0000 0159 {
_putchar:
; 0000 015A     switch(poutput)
;	c -> Y+0
	LDS  R30,_poutput
	LDI  R31,0
; 0000 015B         {
; 0000 015C             case USART0:
	SBIW R30,0
	BRNE _0x4B
; 0000 015D                 while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
_0x4C:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x4C
; 0000 015E                 UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 015F             break;
	RJMP _0x4A
; 0000 0160 
; 0000 0161             case USART1:
_0x4B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4F
; 0000 0162                 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
_0x50:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x50
; 0000 0163                 UDR1=c;
	LD   R30,Y
	STS  206,R30
; 0000 0164             break;
	RJMP _0x4A
; 0000 0165 
; 0000 0166             case USART2:
_0x4F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x53
; 0000 0167                 while ((UCSR2A & DATA_REGISTER_EMPTY)==0);
_0x54:
	LDS  R30,208
	ANDI R30,LOW(0x20)
	BREQ _0x54
; 0000 0168                 UDR2=c;
	LD   R30,Y
	STS  214,R30
; 0000 0169             break;
	RJMP _0x4A
; 0000 016A 
; 0000 016B             case USART3:
_0x53:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4A
; 0000 016C                 while ((UCSR3A & DATA_REGISTER_EMPTY)==0);
_0x58:
	LDS  R30,304
	ANDI R30,LOW(0x20)
	BREQ _0x58
; 0000 016D                 UDR3=c;
	LD   R30,Y
	STS  310,R30
; 0000 016E             break;
; 0000 016F         }
_0x4A:
; 0000 0170 }
	ADIW R28,1
	RET
;
;// Count available data in serial receive buffer
;unsigned int serialAvailable(void)
; 0000 0174 {
_serialAvailable:
; 0000 0175     switch(poutput)
	LDS  R30,_poutput
	LDI  R31,0
; 0000 0176         {
; 0000 0177             case USART0:
	SBIW R30,0
	BRNE _0x5E
; 0000 0178                 return rx_counter0;
	__GETW1R 7,8
	RET
; 0000 0179             break;
	RJMP _0x5D
; 0000 017A 
; 0000 017B             case USART1:
_0x5E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5F
; 0000 017C                 return rx_counter1;
	__GETW1R 13,14
	RET
; 0000 017D             break;
	RJMP _0x5D
; 0000 017E 
; 0000 017F             case USART2:
_0x5F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x60
; 0000 0180                 return rx_counter2;
	LDS  R30,_rx_counter2
	RJMP _0x20A0010
; 0000 0181             break;
; 0000 0182 
; 0000 0183             case USART3:
_0x60:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5D
; 0000 0184                 return rx_counter3;
	LDS  R30,_rx_counter3
_0x20A0010:
	LDI  R31,0
	RET
; 0000 0185             break;
; 0000 0186         }
_0x5D:
; 0000 0187 }
	RET
;
;// Initialize microcontroller
;void mcuInit(void)
; 0000 018B {
_mcuInit:
; 0000 018C     // Crystal Oscillator division factor: 1
; 0000 018D     #pragma optsize-
; 0000 018E     CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 018F     CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0190     #ifdef _OPTIMIZE_SIZE_
; 0000 0191     #pragma optsize+
; 0000 0192     #endif
; 0000 0193 
; 0000 0194     DDRC=0x00;
	OUT  0x7,R30
; 0000 0195     PORTC=0x00;
	OUT  0x8,R30
; 0000 0196 
; 0000 0197     TCCR0A=0x00;
	OUT  0x24,R30
; 0000 0198     TCCR0B=0x03;
	LDI  R30,LOW(3)
	OUT  0x25,R30
; 0000 0199     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 019A     OCR0A=0x00;
	OUT  0x27,R30
; 0000 019B     OCR0B=0x00;
	OUT  0x28,R30
; 0000 019C     TIMSK0=0x01;
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 019D     // USART0 initialization
; 0000 019E     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 019F     // USART0 Receiver: On
; 0000 01A0     // USART0 Transmitter: On
; 0000 01A1     // USART0 Mode: Asynchronous
; 0000 01A2     // USART0 Baud Rate: 9600
; 0000 01A3     UCSR0A=0x00;
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 01A4     UCSR0B=0x98;
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 01A5     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 01A6     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 01A7     UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 01A8 
; 0000 01A9     // USART1 initialization
; 0000 01AA     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01AB     // USART1 Receiver: On
; 0000 01AC     // USART1 Transmitter: On
; 0000 01AD     // USART1 Mode: Asynchronous
; 0000 01AE     // USART1 Baud Rate: 9600
; 0000 01AF     UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  200,R30
; 0000 01B0     UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  201,R30
; 0000 01B1     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  202,R30
; 0000 01B2     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  205,R30
; 0000 01B3     UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  204,R30
; 0000 01B4 
; 0000 01B5     // USART2 initialization
; 0000 01B6     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01B7     // USART2 Receiver: On
; 0000 01B8     // USART2 Transmitter: On
; 0000 01B9     // USART2 Mode: Asynchronous
; 0000 01BA     // USART2 Baud Rate: 9600
; 0000 01BB     UCSR2A=0x00;
	LDI  R30,LOW(0)
	STS  208,R30
; 0000 01BC     UCSR2B=0x98;
	LDI  R30,LOW(152)
	STS  209,R30
; 0000 01BD     UCSR2C=0x06;
	LDI  R30,LOW(6)
	STS  210,R30
; 0000 01BE     UBRR2H=0x00;
	LDI  R30,LOW(0)
	STS  213,R30
; 0000 01BF     UBRR2L=0x67;
	LDI  R30,LOW(103)
	STS  212,R30
; 0000 01C0 
; 0000 01C1      // USART3 initialization
; 0000 01C2     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01C3     // USART3 Receiver: On
; 0000 01C4     // USART3 Transmitter: On
; 0000 01C5     // USART3 Mode: Asynchronous
; 0000 01C6     // USART3 Baud Rate: 9600
; 0000 01C7     UCSR3A=0x00;
	LDI  R30,LOW(0)
	STS  304,R30
; 0000 01C8     UCSR3B=0x98;
	LDI  R30,LOW(152)
	STS  305,R30
; 0000 01C9     UCSR3C=0x06;
	LDI  R30,LOW(6)
	STS  306,R30
; 0000 01CA     UBRR3H=0x00;
	LDI  R30,LOW(0)
	STS  309,R30
; 0000 01CB     UBRR3L=0x67;
	LDI  R30,LOW(103)
	STS  308,R30
; 0000 01CC 
; 0000 01CD     // Analog Comparator initialization
; 0000 01CE     // Analog Comparator: Off
; 0000 01CF     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01D0     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 01D1     ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 01D2 
; 0000 01D3     // ADC initialization
; 0000 01D4     // ADC Clock frequency: 1000.000 kHz
; 0000 01D5     // ADC Voltage Reference: AVCC pin
; 0000 01D6     // ADC Auto Trigger Source: Free Running
; 0000 01D7     // Digital input buffers on ADC0: Off, ADC1: Off, ADC2: Off, ADC3: Off
; 0000 01D8     // ADC4: On, ADC5: On, ADC6: On, ADC7: On
; 0000 01D9     DIDR0=0x0F;
	LDI  R30,LOW(15)
	STS  126,R30
; 0000 01DA     // Digital input buffers on ADC8: On, ADC9: On, ADC10: On, ADC11: On
; 0000 01DB     // ADC12: On, ADC13: On, ADC14: On, ADC15: On
; 0000 01DC     DIDR2=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 01DD     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 01DE     ADCSRA=0xA4;
	LDI  R30,LOW(164)
	STS  122,R30
; 0000 01DF     ADCSRB&=0xF8;
	LDS  R30,123
	ANDI R30,LOW(0xF8)
	STS  123,R30
; 0000 01E0 
; 0000 01E1     // Global enable interrupts
; 0000 01E2     #asm("sei")
	sei
; 0000 01E3 }
	RET
;
;void xbeeTransmit(char *packet,int _dataLength,long int address64H,long int address64L)
; 0000 01E6 {
_xbeeTransmit:
; 0000 01E7     long int i;
; 0000 01E8     char checkSum,destByte,locaddH,locaddL;
; 0000 01E9     int length=0;
; 0000 01EA     int dataLength=_dataLength;
; 0000 01EB //    static char frameID=0x01;
; 0000 01EC //    frameID++;
; 0000 01ED //    if (frameID==0x00) frameID=0x01;
; 0000 01EE     locaddL=XBEE_16BIT_ADDRESS;
	SBIW R28,6
	CALL __SAVELOCR6
;	*packet -> Y+22
;	_dataLength -> Y+20
;	address64H -> Y+16
;	address64L -> Y+12
;	i -> Y+8
;	checkSum -> R17
;	destByte -> R16
;	locaddH -> R19
;	locaddL -> R18
;	length -> R20,R21
;	dataLength -> Y+6
	__GETWRN 20,21,0
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R18,LOW(254)
; 0000 01EF     locaddH=XBEE_16BIT_ADDRESS>>8;
	LDI  R19,LOW(255)
; 0000 01F0     checkSum=0xFF;
	LDI  R17,LOW(255)
; 0000 01F1     length=dataLength+14;
	ADIW R30,14
	MOVW R20,R30
; 0000 01F2     checkSum-=XBEE_FRAME_TYPE_TXREQ;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,16
	MOV  R17,R30
; 0000 01F3     checkSum-=XBEE_FRAME_ID; // checkSum-=frameID;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	MOV  R17,R30
; 0000 01F4     checkSum-=locaddL;
	MOV  R26,R17
	CLR  R27
	MOV  R30,R18
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R17,R30
; 0000 01F5     checkSum-=locaddH;
	MOV  R26,R17
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R17,R30
; 0000 01F6     checkSum-=BROADCAST_RADIUS;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	MOV  R17,R30
; 0000 01F7     checkSum-= XBEE_TX_OPTIONS;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	MOV  R17,R30
; 0000 01F8     poutput=USART0;
	LDI  R30,LOW(0)
	STS  _poutput,R30
; 0000 01F9     putchar(XBEE_START_DELIMITER);
	LDI  R30,LOW(126)
	ST   -Y,R30
	RCALL _putchar
; 0000 01FA     putchar(XBEE_LENGTH_MSB);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _putchar
; 0000 01FB     putchar(length);
	ST   -Y,R20
	RCALL _putchar
; 0000 01FC     putchar(XBEE_FRAME_TYPE_TXREQ);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _putchar
; 0000 01FD     putchar(XBEE_FRAME_ID); // putchar(frameID);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _putchar
; 0000 01FE     for (i=4;i>0;i--)
	__GETD1N 0x4
	__PUTD1S 8
_0x63:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x64
; 0000 01FF         {
; 0000 0200             destByte=address64H>>(8*(i-1));
	__GETD1S 8
	__SUBD1N 1
	LSL  R30
	LSL  R30
	LSL  R30
	__GETD2S 16
	CALL __ASRD12
	MOV  R16,R30
; 0000 0201             putchar(destByte);
	ST   -Y,R16
	RCALL _putchar
; 0000 0202             checkSum-=destByte;
	MOV  R26,R17
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R17,R30
; 0000 0203         }
	__GETD1S 8
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 8
	RJMP _0x63
_0x64:
; 0000 0204     for (i=4;i>0;i--)
	__GETD1N 0x4
	__PUTD1S 8
_0x66:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x67
; 0000 0205         {
; 0000 0206             destByte=address64L>>(8*(i-1));
	__GETD1S 8
	__SUBD1N 1
	LSL  R30
	LSL  R30
	LSL  R30
	__GETD2S 12
	CALL __ASRD12
	MOV  R16,R30
; 0000 0207             putchar(destByte);
	ST   -Y,R16
	RCALL _putchar
; 0000 0208             checkSum-=destByte;
	MOV  R26,R17
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R17,R30
; 0000 0209         }
	__GETD1S 8
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 8
	RJMP _0x66
_0x67:
; 0000 020A     putchar(locaddH);
	ST   -Y,R19
	RCALL _putchar
; 0000 020B     putchar(locaddL);
	ST   -Y,R18
	RCALL _putchar
; 0000 020C     putchar(BROADCAST_RADIUS);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _putchar
; 0000 020D     putchar(XBEE_TX_OPTIONS);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _putchar
; 0000 020E     for (i=0;i<dataLength;i++)
	LDI  R30,LOW(0)
	__CLRD1S 8
_0x69:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2S 8
	CALL __CWD1
	CALL __CPD21
	BRGE _0x6A
; 0000 020F         {
; 0000 0210             putchar(packet[i]);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _putchar
; 0000 0211             checkSum-=packet[i];
	MOV  R0,R17
	CLR  R1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CLR  R27
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	MOV  R17,R30
; 0000 0212         }
	__GETD1S 8
	__SUBD1N -1
	__PUTD1S 8
	RJMP _0x69
_0x6A:
; 0000 0213     putchar(checkSum);
	ST   -Y,R17
	RCALL _putchar
; 0000 0214 }
	CALL __LOADLOCR6
	ADIW R28,24
	RET
;
;unsigned char xbeeReceive(char * recvPacket)
; 0000 0217 {
_xbeeReceive:
; 0000 0218     char temp=0,lengthMSB=0,lengthLSB=0,index,_64sourceAddress[10]="",_16sourceAddress[4]="",rxOptions=0,_checkSum=0xFF,_recvCheckSum=0;
; 0000 0219     int packetLength=0;
; 0000 021A     poutput=USART0;
	SBIW R28,17
	LDI  R24,17
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x6B*2)
	LDI  R31,HIGH(_0x6B*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	*recvPacket -> Y+23
;	temp -> R17
;	lengthMSB -> R16
;	lengthLSB -> R19
;	index -> R18
;	_64sourceAddress -> Y+13
;	_16sourceAddress -> Y+9
;	rxOptions -> R21
;	_checkSum -> R20
;	_recvCheckSum -> Y+8
;	packetLength -> Y+6
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R21,0
	LDI  R20,255
	LDI  R30,LOW(0)
	STS  _poutput,R30
; 0000 021B     if (serialAvailable())
	RCALL _serialAvailable
	SBIW R30,0
	BRNE PC+3
	JMP _0x6C
; 0000 021C         {
; 0000 021D             temp=getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 021E             if (temp==XBEE_START_DELIMITER)
	CPI  R17,126
	BREQ PC+3
	JMP _0x6D
; 0000 021F                 {
; 0000 0220                     while (serialAvailable()<2);
_0x6E:
	RCALL _serialAvailable
	SBIW R30,2
	BRLO _0x6E
; 0000 0221                     lengthMSB=getchar();
	RCALL _getchar
	MOV  R16,R30
; 0000 0222                     lengthLSB=getchar();
	RCALL _getchar
	MOV  R19,R30
; 0000 0223                     packetLength=(lengthMSB<<8)+lengthLSB;
	MOV  R31,R16
	LDI  R30,LOW(0)
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0224                     if (packetLength>12)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,13
	BRGE PC+3
	JMP _0x71
; 0000 0225                         {
; 0000 0226                             temp=getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 0227                             if (temp==XBEE_FRAME_TYPE_RXPACKET)
	CPI  R17,144
	BREQ PC+3
	JMP _0x72
; 0000 0228                                 {
; 0000 0229                                     _checkSum-=XBEE_FRAME_TYPE_RXPACKET;
	MOV  R30,R20
	LDI  R31,0
	SUBI R30,LOW(144)
	SBCI R31,HIGH(144)
	MOV  R20,R30
; 0000 022A                                     while (serialAvailable()<8);
_0x73:
	RCALL _serialAvailable
	SBIW R30,8
	BRLO _0x73
; 0000 022B                                     for (index=0;index<8;index++)
	LDI  R18,LOW(0)
_0x77:
	CPI  R18,8
	BRSH _0x78
; 0000 022C                                         {
; 0000 022D                                             temp=getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 022E                                             _64sourceAddress[index]=temp;
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,13
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 022F                                             _checkSum-=temp;
	MOV  R26,R20
	CLR  R27
	MOV  R30,R17
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R20,R30
; 0000 0230                                         }
	SUBI R18,-1
	RJMP _0x77
_0x78:
; 0000 0231                                     while (serialAvailable()<2);
_0x79:
	RCALL _serialAvailable
	SBIW R30,2
	BRLO _0x79
; 0000 0232                                     for (index=0;index<2;index++)
	LDI  R18,LOW(0)
_0x7D:
	CPI  R18,2
	BRSH _0x7E
; 0000 0233                                         {
; 0000 0234                                             temp=getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 0235                                             _16sourceAddress[index]=temp;
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,9
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 0236                                             _checkSum-=temp;
	MOV  R26,R20
	CLR  R27
	MOV  R30,R17
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R20,R30
; 0000 0237                                         }
	SUBI R18,-1
	RJMP _0x7D
_0x7E:
; 0000 0238                                     while (serialAvailable()<1);
_0x7F:
	RCALL _serialAvailable
	SBIW R30,1
	BRLO _0x7F
; 0000 0239                                     rxOptions=getchar();
	RCALL _getchar
	MOV  R21,R30
; 0000 023A                                     _checkSum-=rxOptions;
	MOV  R26,R20
	CLR  R27
	MOV  R30,R21
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R20,R30
; 0000 023B                                     while (serialAvailable()<12);
_0x82:
	RCALL _serialAvailable
	SBIW R30,12
	BRLO _0x82
; 0000 023C                                     for (index=0;index<(packetLength-12);index++)
	LDI  R18,LOW(0)
_0x86:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,12
	MOV  R26,R18
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x87
; 0000 023D                                         {
; 0000 023E                                             temp=getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 023F                                             recvPacket[index]=temp;
	MOV  R30,R18
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 0240                                             _checkSum-=temp;
	MOV  R26,R20
	CLR  R27
	MOV  R30,R17
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R20,R30
; 0000 0241                                         }
	SUBI R18,-1
	RJMP _0x86
_0x87:
; 0000 0242                                     while (serialAvailable()<1);
_0x88:
	RCALL _serialAvailable
	SBIW R30,1
	BRLO _0x88
; 0000 0243                                     _recvCheckSum=getchar();
	RCALL _getchar
	STD  Y+8,R30
; 0000 0244                                     if (_recvCheckSum!=_checkSum)
	LDD  R26,Y+8
	CP   R20,R26
	BREQ _0x8B
; 0000 0245                                         {
; 0000 0246                                             memset(recvPacket,0,sizeof(recvPacket));
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0247                                             return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A000F
; 0000 0248                                         }
; 0000 0249                                     else return 1;
_0x8B:
	LDI  R30,LOW(1)
	RJMP _0x20A000F
; 0000 024A                                 }
; 0000 024B                             else return 0;
_0x72:
	LDI  R30,LOW(0)
	RJMP _0x20A000F
; 0000 024C                         }
; 0000 024D                     else return 0;
_0x71:
	LDI  R30,LOW(0)
	RJMP _0x20A000F
; 0000 024E                 }
; 0000 024F             else return 0;
_0x6D:
	LDI  R30,LOW(0)
	RJMP _0x20A000F
; 0000 0250         }
_0x8F:
; 0000 0251     else return 0;
	RJMP _0x90
_0x6C:
	LDI  R30,LOW(0)
; 0000 0252 
; 0000 0253 }
_0x90:
_0x20A000F:
	CALL __LOADLOCR6
	ADIW R28,25
	RET
;
;unsigned char _3gEchoOff(void)
; 0000 0256 {
__3gEchoOff:
; 0000 0257     char temp=0x00, index=0;
; 0000 0258     char _3gRespond[10];
; 0000 0259     memset(_3gRespond,0,sizeof(_3gRespond));
	SBIW R28,10
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R17
;	index -> R16
;	_3gRespond -> Y+2
	LDI  R17,0
	LDI  R16,0
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 025A     poutput=USART1;
	LDI  R30,LOW(1)
	STS  _poutput,R30
; 0000 025B     printf("ATE0\r");
	__POINTW1FN _0x0,70
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 025C     while (temp!=LF) temp=getchar();
_0x91:
	CPI  R17,10
	BREQ _0x93
	RCALL _getchar
	MOV  R17,R30
	RJMP _0x91
_0x93:
; 0000 025D temp=getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 025E     while (temp!=LF) // while the read character is not <LF>
_0x94:
	CPI  R17,10
	BREQ _0x96
; 0000 025F         {
; 0000 0260             _3gRespond[index]=temp; // put temp value to _3gRespond array
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 0261             index++; // increment index
	SUBI R16,-1
; 0000 0262             temp=getchar(); // read a character
	RCALL _getchar
	MOV  R17,R30
; 0000 0263             if (index==9) break; // if index reach the last element of _3gRespond array
	CPI  R16,9
	BRNE _0x94
; 0000 0264         }
_0x96:
; 0000 0265     if (strstr(_3gRespond,"OK")!=NULL)  return 1;
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x99,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0x98
	LDI  R30,LOW(1)
	RJMP _0x20A000E
; 0000 0266     else return 0;
_0x98:
	LDI  R30,LOW(0)
; 0000 0267 }
_0x20A000E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET

	.DSEG
_0x99:
	.BYTE 0x3
;
;unsigned char _3gZipCall(unsigned char _state)
; 0000 026A {

	.CSEG
__3gZipCall:
; 0000 026B     char _3gRespond[70];
; 0000 026C     char temp=0x00, index=0;
; 0000 026D     memset(_3gRespond,0,sizeof(_3gRespond));
	SBIW R28,63
	SBIW R28,7
	ST   -Y,R17
	ST   -Y,R16
;	_state -> Y+72
;	_3gRespond -> Y+2
;	temp -> R17
;	index -> R16
	LDI  R17,0
	LDI  R16,0
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 026E     poutput=USART1;
	LDI  R30,LOW(1)
	STS  _poutput,R30
; 0000 026F     printf("AT+ZIPCALL=%u\r",_state); // send zipcall command
	__POINTW1FN _0x0,79
	ST   -Y,R31
	ST   -Y,R30
	__GETB1SX 74
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 0270     //while (serialAvailable()<13); // wait until serial available or 2500 ms passed IF command ATE1 activated
; 0000 0271     //for (index=0;index<13;index++) temp=getchar(); // get the same command string that was sent earlier IF command ATE1 activated
; 0000 0272     //temp=0x00; // reset temp var
; 0000 0273     while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
_0x9B:
	CPI  R17,10
	BREQ _0x9D
	RCALL _getchar
	MOV  R17,R30
	RJMP _0x9B
_0x9D:
; 0000 0275 if (_state==1)
	__GETB2SX 72
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x9E
; 0000 0276         {
; 0000 0277             temp=getchar(); // read 1 character from serial
	RCALL _getchar
	MOV  R17,R30
; 0000 0278             while (temp!=LF) // while the read character is not <LF>
_0x9F:
	CPI  R17,10
	BREQ _0xA1
; 0000 0279                 {
; 0000 027A                     _3gRespond[index]=temp; // put temp value to _3gRespond array
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 027B                     index++; // increment index
	SUBI R16,-1
; 0000 027C                     temp=getchar(); // read a character
	RCALL _getchar
	MOV  R17,R30
; 0000 027D                     if (index==69) break; // if index reach the last element of _3gRespond array
	CPI  R16,69
	BRNE _0x9F
; 0000 027E                 }
_0xA1:
; 0000 027F             if (strstr(_3gRespond,"ERROR")!=NULL) // if the  _3gRespond array contains "ERROR",
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA4,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xA3
; 0000 0280                 {
; 0000 0281                     memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0282                     return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A000D
; 0000 0283                 }
; 0000 0284             else if (strstr(_3gRespond,"+ZIPCALL: 1")!=NULL) // else if _3gRespond array contains "+ZIPCALL: 1",
_0xA3:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA4,6
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0xA6
; 0000 0285                 {
; 0000 0286                     memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0287                     temp=0x00; // reset temp var
	LDI  R17,LOW(0)
; 0000 0288                     while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
_0xA7:
	CPI  R17,10
	BREQ _0xA9
	RCALL _getchar
	MOV  R17,R30
	RJMP _0xA7
_0xA9:
; 0000 0289 index=0;
	LDI  R16,LOW(0)
; 0000 028A                     temp=getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 028B                     while (temp!=LF)
_0xAA:
	CPI  R17,10
	BREQ _0xAC
; 0000 028C                         {
; 0000 028D                             _3gRespond[index]=temp; // put temp value to _3gRespond array
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 028E                             index++; // increment index
	SUBI R16,-1
; 0000 028F                             temp=getchar(); // read a character
	RCALL _getchar
	MOV  R17,R30
; 0000 0290                             if (index==69) break; // if index reach the last element of _3gRespond array
	CPI  R16,69
	BRNE _0xAA
; 0000 0291                         }
_0xAC:
; 0000 0292                     if (strstr(_3gRespond,"OK")!=NULL) // if the  _3gRespond array contains "OK",
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA4,18
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xAE
; 0000 0293                         {
; 0000 0294                             memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0295                             return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A000D
; 0000 0296                         }
; 0000 0297                     else if (strstr(_3gRespond,"OK")==NULL)
_0xAE:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA4,21
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE _0xB0
; 0000 0298                         {
; 0000 0299                             memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 029A                             return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A000D
; 0000 029B                         }
; 0000 029C                 }
_0xB0:
; 0000 029D         }
_0xA6:
; 0000 029E     else if (_state==0)
	RJMP _0xB1
_0x9E:
	__GETB1SX 72
	CPI  R30,0
	BREQ PC+3
	JMP _0xB2
; 0000 029F         {
; 0000 02A0             temp=getchar(); // read 1 character from serial
	RCALL _getchar
	MOV  R17,R30
; 0000 02A1             while (temp!=LF) // while the read character is not <LF>
_0xB3:
	CPI  R17,10
	BREQ _0xB5
; 0000 02A2                 {
; 0000 02A3                     _3gRespond[index]=temp; // put temp value to _3gRespond array
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 02A4                     index++; // increment index
	SUBI R16,-1
; 0000 02A5                     temp=getchar(); // read a character
	RCALL _getchar
	MOV  R17,R30
; 0000 02A6                     if (index==69) break; // if index reach the last element of _3gRespond array
	CPI  R16,69
	BRNE _0xB3
; 0000 02A7                 }
_0xB5:
; 0000 02A8             if (strstr(_3gRespond,"ERROR")!=NULL) // if the  _3gRespond array contains "ERROR",
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA4,24
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xB7
; 0000 02A9                 {
; 0000 02AA                     memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 02AB                     return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A000D
; 0000 02AC                 }
; 0000 02AD             else if (strstr(_3gRespond,"OK")!=NULL) // else if _3gRespond array contains "+ZIPCALL: 1",
_0xB7:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA4,30
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xB9
; 0000 02AE                 {
; 0000 02AF                     memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 02B0                     return 1;
	LDI  R30,LOW(1)
; 0000 02B1                 }
; 0000 02B2         }
_0xB9:
; 0000 02B3 }
_0xB2:
_0xB1:
_0x20A000D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,63
	ADIW R28,10
	RET

	.DSEG
_0xA4:
	.BYTE 0x21
;
;unsigned char _3gZipOpen(unsigned char _socketID,unsigned char _type,char *_remoteIP,unsigned int _remotePort)
; 0000 02B6 {

	.CSEG
__3gZipOpen:
; 0000 02B7     char _3gRespond[70];
; 0000 02B8     char temp=0x00, index=0;
; 0000 02B9     memset(_3gRespond,0,sizeof(_3gRespond));
	SBIW R28,63
	SBIW R28,7
	ST   -Y,R17
	ST   -Y,R16
;	_socketID -> Y+77
;	_type -> Y+76
;	*_remoteIP -> Y+74
;	_remotePort -> Y+72
;	_3gRespond -> Y+2
;	temp -> R17
;	index -> R16
	LDI  R17,0
	LDI  R16,0
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 02BA     poutput=USART1;
	LDI  R30,LOW(1)
	STS  _poutput,R30
; 0000 02BB     printf("AT+ZIPOPEN=%u,%u,%s,%u\r",_socketID,_type,_remoteIP,_remotePort); // send zipcall command
	__POINTW1FN _0x0,112
	ST   -Y,R31
	ST   -Y,R30
	__GETB1SX 79
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1SX 82
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETW1SX 84
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETW1SX 86
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,16
	CALL _printf
	ADIW R28,18
; 0000 02BC     //while (serialAvailable()<32); // wait until serial available or 2500 ms passed, IF command ATE1 activated
; 0000 02BD     //for (index=0;index<32;index++) temp=getchar(); // get the same command string that was sent earlier, IF command ATE1 activated
; 0000 02BE     temp=0x00; // reset temp var
	LDI  R17,LOW(0)
; 0000 02BF     while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
_0xBA:
	CPI  R17,10
	BREQ _0xBC
	CALL _getchar
	MOV  R17,R30
	RJMP _0xBA
_0xBC:
; 0000 02C0 index=0;
	LDI  R16,LOW(0)
; 0000 02C1     temp=getchar(); // read 1 character from serial
	CALL _getchar
	MOV  R17,R30
; 0000 02C2     while (temp!=LF) // while the read character is not <LF>
_0xBD:
	CPI  R17,10
	BREQ _0xBF
; 0000 02C3         {
; 0000 02C4             _3gRespond[index]=temp; // put temp value to _3gRespond array
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 02C5             index++; // increment index
	SUBI R16,-1
; 0000 02C6             temp=getchar(); // read a character
	CALL _getchar
	MOV  R17,R30
; 0000 02C7             if (index==69) break; // if index reach the last element of _3gRespond array
	CPI  R16,69
	BRNE _0xBD
; 0000 02C8         }
_0xBF:
; 0000 02C9     if (strstr(_3gRespond,"ERROR")!=NULL) // if the  _3gRespond array contains "ERROR",
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xC2,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xC1
; 0000 02CA         {
; 0000 02CB             memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 02CC             return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 02CD         }
; 0000 02CE     else if (strstr(_3gRespond,"+ZIPSTAT: 1")!=NULL) // else if _3gRespond array contains "+ZIPCALL: 1",
_0xC1:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xC2,6
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0xC4
; 0000 02CF         {
; 0000 02D0             memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 02D1             temp=0x00; // reset temp var
	LDI  R17,LOW(0)
; 0000 02D2             while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
_0xC5:
	CPI  R17,10
	BREQ _0xC7
	CALL _getchar
	MOV  R17,R30
	RJMP _0xC5
_0xC7:
; 0000 02D3 index=0;
	LDI  R16,LOW(0)
; 0000 02D4             temp=getchar();
	CALL _getchar
	MOV  R17,R30
; 0000 02D5             while (temp!=LF)
_0xC8:
	CPI  R17,10
	BREQ _0xCA
; 0000 02D6                 {
; 0000 02D7                     _3gRespond[index]=temp; // put temp value to _3gRespond array
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 02D8                     index++; // increment index
	SUBI R16,-1
; 0000 02D9                     temp=getchar(); // read a character
	CALL _getchar
	MOV  R17,R30
; 0000 02DA                     if (index==69) break; // if index reach the last element of _3gRespond array
	CPI  R16,69
	BRNE _0xC8
; 0000 02DB                 }
_0xCA:
; 0000 02DC             if (strstr(_3gRespond,"OK")!=NULL) // if the  _3gRespond array contains "OK",
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xC2,18
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xCC
; 0000 02DD                 {
; 0000 02DE                     memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 02DF                     return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A000C
; 0000 02E0                 }
; 0000 02E1             else if (strstr(_3gRespond,"OK")==NULL)
_0xCC:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xC2,21
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE _0xCE
; 0000 02E2                 {
; 0000 02E3                     memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 02E4                     return 0;
	LDI  R30,LOW(0)
; 0000 02E5                 }
; 0000 02E6         }
_0xCE:
; 0000 02E7 }
_0xC4:
_0x20A000C:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,63
	ADIW R28,15
	RET

	.DSEG
_0xC2:
	.BYTE 0x18
;
;unsigned char _3gZipSend(unsigned char _socketID,char *_data)
; 0000 02EA {

	.CSEG
__3gZipSend:
; 0000 02EB     char _3gRespond[70];
; 0000 02EC     char temp=0x00, index=0;
; 0000 02ED     memset(_3gRespond,0,sizeof(_3gRespond));
	SBIW R28,63
	SBIW R28,7
	ST   -Y,R17
	ST   -Y,R16
;	_socketID -> Y+74
;	*_data -> Y+72
;	_3gRespond -> Y+2
;	temp -> R17
;	index -> R16
	LDI  R17,0
	LDI  R16,0
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 02EE     poutput=USART1;
	LDI  R30,LOW(1)
	STS  _poutput,R30
; 0000 02EF     printf("AT+ZIPSEND=%u,%s\r",_socketID,_data); // send zipcall command
	__POINTW1FN _0x0,148
	ST   -Y,R31
	ST   -Y,R30
	__GETB1SX 76
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETW1SX 78
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
; 0000 02F0     //while (serialAvailable()<30); // wait until serial available or 2500 ms passed, IF command ATE1 activated
; 0000 02F1     //for (index=0;index<(14+strlen(_data));index++) temp=getchar(); // get the same command string that was sent earliear, IF command ATE1 activated
; 0000 02F2     temp=0x00; // reset temp var
	LDI  R17,LOW(0)
; 0000 02F3     while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
_0xCF:
	CPI  R17,10
	BREQ _0xD1
	CALL _getchar
	MOV  R17,R30
	RJMP _0xCF
_0xD1:
; 0000 02F4 index=0;
	LDI  R16,LOW(0)
; 0000 02F5     temp=getchar(); // read 1 character from serial
	CALL _getchar
	MOV  R17,R30
; 0000 02F6     while (temp!=LF) // while the read character is not <LF>
_0xD2:
	CPI  R17,10
	BREQ _0xD4
; 0000 02F7         {
; 0000 02F8             _3gRespond[index]=temp; // put temp value to _3gRespond array
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 02F9             index++; // increment index
	SUBI R16,-1
; 0000 02FA             temp=getchar(); // read a character
	CALL _getchar
	MOV  R17,R30
; 0000 02FB             if (index==69) break; // if index reach the last element of _3gRespond array
	CPI  R16,69
	BRNE _0xD2
; 0000 02FC         }
_0xD4:
; 0000 02FD     if (strstr(_3gRespond,"ERROR")!=NULL) // if the  _3gRespond array contains "ERROR",
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xD7,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xD6
; 0000 02FE         {
; 0000 02FF             memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0300             return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A000B
; 0000 0301         }
; 0000 0302     else if (strstr(_3gRespond,"OK")!=NULL) // else if _3gRespond array contains "+ZIPCALL: 1",
_0xD6:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xD7,6
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0xD9
; 0000 0303         {
; 0000 0304             memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0305             temp=0x00; // reset temp var
	LDI  R17,LOW(0)
; 0000 0306             while (temp!=LF) temp=getchar(); // read the next character from serial until we get <LF>
_0xDA:
	CPI  R17,10
	BREQ _0xDC
	CALL _getchar
	MOV  R17,R30
	RJMP _0xDA
_0xDC:
; 0000 0307 index=0;
	LDI  R16,LOW(0)
; 0000 0308             temp=getchar();
	CALL _getchar
	MOV  R17,R30
; 0000 0309             while (temp!=LF)
_0xDD:
	CPI  R17,10
	BREQ _0xDF
; 0000 030A                 {
; 0000 030B                     _3gRespond[index]=temp; // put temp value to _3gRespond array
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 030C                     index++; // increment index
	SUBI R16,-1
; 0000 030D                     temp=getchar(); // read a character
	CALL _getchar
	MOV  R17,R30
; 0000 030E                     if (index==69) break; // if index reach the last element of _3gRespond array
	CPI  R16,69
	BRNE _0xDD
; 0000 030F                 }
_0xDF:
; 0000 0310             if (strstr(_3gRespond,"+ZIPSEND:")!=NULL) // if the  _3gRespond array contains "OK",
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xD7,9
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xE1
; 0000 0311                 {
; 0000 0312                     memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0313                     return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A000B
; 0000 0314                 }
; 0000 0315             else if (strstr(_3gRespond,"+ZIPSEND:")==NULL)
_0xE1:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xD7,19
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE _0xE3
; 0000 0316                 {
; 0000 0317                     memset(_3gRespond,0,sizeof(_3gRespond)); // reset the array
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0318                     return 0;
	LDI  R30,LOW(0)
; 0000 0319                 }
; 0000 031A         }
_0xE3:
; 0000 031B }
_0xD9:
_0x20A000B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,63
	ADIW R28,12
	RET

	.DSEG
_0xD7:
	.BYTE 0x1D
;
;int hex2int(char c)
; 0000 031E {

	.CSEG
_hex2int:
; 0000 031F     int first=c/16-3;
; 0000 0320     int second=c%16;
; 0000 0321     int result=first*10+second;
; 0000 0322     if (result>9) result--;
	CALL __SAVELOCR6
;	c -> Y+6
;	first -> R16,R17
;	second -> R18,R19
;	result -> R20,R21
	LDD  R26,Y+6
	LDI  R27,0
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL __DIVW21
	SBIW R30,3
	MOVW R16,R30
	LDD  R26,Y+6
	CLR  R27
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL __MODW21
	MOVW R18,R30
	MOVW R30,R16
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R18
	ADC  R31,R19
	MOVW R20,R30
	__CPWRN 20,21,10
	BRLT _0xE4
	__SUBWRN 20,21,1
; 0000 0323     return result;
_0xE4:
	MOVW R30,R20
	CALL __LOADLOCR6
	ADIW R28,7
	RET
; 0000 0324 }
;
;int hex2ascii(char c,char d)
; 0000 0327 {
_hex2ascii:
; 0000 0328     int high=hex2int(c)*16;
; 0000 0329     int low=hex2int(d);
; 0000 032A     return high+low;
	CALL __SAVELOCR4
;	c -> Y+5
;	d -> Y+4
;	high -> R16,R17
;	low -> R18,R19
	LDD  R30,Y+5
	ST   -Y,R30
	RCALL _hex2int
	CALL __LSLW4
	MOVW R16,R30
	LDD  R30,Y+4
	ST   -Y,R30
	RCALL _hex2int
	MOVW R18,R30
	MOVW R30,R18
	ADD  R30,R16
	ADC  R31,R17
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; 0000 032B }
;
;unsigned char _3gZipReceive(char *_data)
; 0000 032E {
__3gZipReceive:
; 0000 032F     unsigned char index=0,index1=0;
; 0000 0330     char _dataLength=0,buf=0;
; 0000 0331     char temp;
; 0000 0332     char _3gRespond[100],_dataLengthStr[3],*_3gRespond1;
; 0000 0333     memset(_3gRespond,0,sizeof(_3gRespond));
	SBIW R28,63
	SBIW R28,42
	CALL __SAVELOCR6
;	*_data -> Y+111
;	index -> R17
;	index1 -> R16
;	_dataLength -> R19
;	buf -> R18
;	temp -> R21
;	_3gRespond -> Y+11
;	_dataLengthStr -> Y+8
;	*_3gRespond1 -> Y+6
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0334     memset(_dataLengthStr,0,sizeof(_dataLengthStr));
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0335     poutput=USART1;
	LDI  R30,LOW(1)
	STS  _poutput,R30
; 0000 0336     if (serialAvailable())
	RCALL _serialAvailable
	SBIW R30,0
	BRNE PC+3
	JMP _0xE5
; 0000 0337         {
; 0000 0338             temp=getchar();
	CALL _getchar
	MOV  R21,R30
; 0000 0339             if (temp=='+')
	CPI  R21,43
	BREQ PC+3
	JMP _0xE6
; 0000 033A                 {
; 0000 033B                     memset(_3gRespond,0,sizeof(_3gRespond));
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 033C                     gets(_3gRespond,sizeof(_3gRespond)-1);
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   -Y,R31
	ST   -Y,R30
	CALL _gets
; 0000 033D                     if ((strstr(_3gRespond,"ZIPRECV:")!=NULL)&&(strstr(_3gRespond,",02")!=NULL))
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xE8,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xE9
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xE8,9
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE _0xEA
_0xE9:
	RJMP _0xE7
_0xEA:
; 0000 033E                         {
; 0000 033F                             _3gRespond1=strtok(_3gRespond,",");
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,189
	ST   -Y,R31
	ST   -Y,R30
	CALL _strtok
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0340                             _3gRespond1=strtok(NULL,",");
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,189
	ST   -Y,R31
	ST   -Y,R30
	CALL _strtok
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0341                             _3gRespond1=strtok(NULL,",");
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,189
	ST   -Y,R31
	ST   -Y,R30
	CALL _strtok
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0342                             _dataLength=strlen(_3gRespond1);
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R19,R30
; 0000 0343                             for (index=0;index<_dataLength;index++)
	LDI  R17,LOW(0)
_0xEC:
	CP   R17,R19
	BRSH _0xED
; 0000 0344                                 {
; 0000 0345                                     if ((index%2)!=0)
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	SBIW R30,0
	BREQ _0xEE
; 0000 0346                                         {
; 0000 0347                                             _data[index1]=hex2ascii(buf,_3gRespond1[index]);
	MOV  R30,R16
	__GETW2SX 111
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	RCALL _hex2ascii
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0348                                             index1++;
	SUBI R16,-1
; 0000 0349                                         }
; 0000 034A                                     else buf=_3gRespond1[index];
	RJMP _0xEF
_0xEE:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R18,X
; 0000 034B                                 }
_0xEF:
	SUBI R17,-1
	RJMP _0xEC
_0xED:
; 0000 034C                             _data[index1]=0;
	__GETW2SX 111
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	ST   X,R30
; 0000 034D                             return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A000A
; 0000 034E                         }
; 0000 034F                     else return 0;
_0xE7:
	LDI  R30,LOW(0)
	RJMP _0x20A000A
; 0000 0350                 }
; 0000 0351             else return 0;
_0xE6:
	LDI  R30,LOW(0)
	RJMP _0x20A000A
; 0000 0352         }
; 0000 0353     else return 0;
_0xE5:
	LDI  R30,LOW(0)
; 0000 0354 }
_0x20A000A:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,50
	RET

	.DSEG
_0xE8:
	.BYTE 0xD
;
;void getRequestFromServerAndRespond(void)  // no prob
; 0000 0357 {

	.CSEG
_getRequestFromServerAndRespond:
; 0000 0358     char request[20],_devid[3],_coordresp[40],_coordResponse[80];
; 0000 0359     unsigned char index=0,indic1=0;
; 0000 035A     int _devID;
; 0000 035B     memset(request,0,sizeof(request));
	SBIW R28,63
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR4
;	request -> Y+127
;	_devid -> Y+124
;	_coordresp -> Y+84
;	_coordResponse -> Y+4
;	index -> R17
;	indic1 -> R16
;	_devID -> R18,R19
	LDI  R17,0
	LDI  R16,0
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 035C     memset(_devid,0,sizeof(_devid));
	MOVW R30,R28
	SUBI R30,LOW(-(124))
	SBCI R31,HIGH(-(124))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 035D     memset(_coordresp,0,sizeof(_coordresp));
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 035E     memset(_coordResponse,0,sizeof(_coordResponse));
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 035F     indic1=_3gZipReceive(request);
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	RCALL __3gZipReceive
	MOV  R16,R30
; 0000 0360 
; 0000 0361     if (indic1==1)
	CPI  R16,1
	BREQ PC+3
	JMP _0xF3
; 0000 0362         {
; 0000 0363             if (strstr(request,dev_id_chk)!=NULL) // if the serial_command contains this device's ID
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_dev_id_chk)
	LDI  R31,HIGH(_dev_id_chk)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0xF4
; 0000 0364                 {
; 0000 0365                     if (strstr(request,":ON3K")!=NULL)  //  if the request is to turn on LED 3K
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xF6,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xF5
; 0000 0366                         {
; 0000 0367                             current3k=1.5;
	__GETD1N 0x3FC00000
	STS  _current3k,R30
	STS  _current3k+1,R31
	STS  _current3k+2,R22
	STS  _current3k+3,R23
; 0000 0368                             voltage3k=260;
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	STS  _voltage3k,R30
	STS  _voltage3k+1,R31
; 0000 0369                         }
; 0000 036A                     else if (strstr(request,":ON5K")!=NULL)  //  if the request is to turn on LED 5K
	RJMP _0xF7
_0xF5:
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xF6,6
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xF8
; 0000 036B                         {
; 0000 036C                             current5k=1.5;
	__GETD1N 0x3FC00000
	STS  _current5k,R30
	STS  _current5k+1,R31
	STS  _current5k+2,R22
	STS  _current5k+3,R23
; 0000 036D                             voltage5k=260;
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	STS  _voltage5k,R30
	STS  _voltage5k+1,R31
; 0000 036E                         }
; 0000 036F                     else if (strstr(request,":OFF3K")!=NULL)  //  if the request is to turn off LED 3K
	RJMP _0xF9
_0xF8:
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xF6,12
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xFA
; 0000 0370                         {
; 0000 0371                             current3k=0.0;
	LDI  R30,LOW(0)
	STS  _current3k,R30
	STS  _current3k+1,R30
	STS  _current3k+2,R30
	STS  _current3k+3,R30
; 0000 0372                             voltage3k=0;
	STS  _voltage3k,R30
	STS  _voltage3k+1,R30
; 0000 0373                         }
; 0000 0374                     else if (strstr(request,":OFF5K")!=NULL)  //  if the request is to turn off LED 5K
	RJMP _0xFB
_0xFA:
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xF6,19
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0xFC
; 0000 0375                         {
; 0000 0376                             current5k=0.0;
	LDI  R30,LOW(0)
	STS  _current5k,R30
	STS  _current5k+1,R30
	STS  _current5k+2,R30
	STS  _current5k+3,R30
; 0000 0377                             voltage5k=0;
	STS  _voltage5k,R30
	STS  _voltage5k+1,R30
; 0000 0378                         }
; 0000 0379                     else if (strstr(request,":TH")!=NULL)  //  if the request is to send temperature and humidity value
	RJMP _0xFD
_0xFC:
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xF6,26
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0xFE
; 0000 037A                         {
; 0000 037B                             sprintf(_coordresp,"%c%c%cT%+04.1fH%04.1f%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,ETX,CR,LF);
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,221
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x30
	CALL __PUTPARD1
	LDS  R30,_temperature
	LDS  R31,_temperature+1
	LDS  R22,_temperature+2
	LDS  R23,_temperature+3
	CALL __PUTPARD1
	LDS  R30,_humidity
	LDS  R31,_humidity+1
	LDS  R22,_humidity+2
	LDS  R23,_humidity+3
	CALL __PUTPARD1
	__GETD1N 0x3
	CALL __PUTPARD1
	__GETD1N 0xD
	CALL __PUTPARD1
	__GETD1N 0xA
	CALL __PUTPARD1
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
; 0000 037C                             for (index=0;index<strlen(_coordresp);index++) sprintf(_coordResponse+strlen(_coordResponse),"%02X",_coordresp[index]);
	LDI  R17,LOW(0)
_0x100:
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x101
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,65
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(88))
	SBCI R27,HIGH(-(88))
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	SUBI R17,-1
	RJMP _0x100
_0x101:
; 0000 037E _3gZipSend(1,_coordResponse);
	RJMP _0x17F
; 0000 037F                         }
; 0000 0380                     else if (strstr(request,":VI")!=NULL)  //  if the request is to send voltage and current value
_0xFE:
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xF6,30
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0x103
; 0000 0381                         {
; 0000 0382                             sprintf(_coordresp,"%c%c%c3V%03uI%03.1f5V%03uI%03.1f%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),voltage3k,current3k,voltage5k,current5k,ETX,CR,LF);
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,253
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x30
	CALL __PUTPARD1
	LDS  R30,_voltage3k
	LDS  R31,_voltage3k+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current3k
	LDS  R31,_current3k+1
	LDS  R22,_current3k+2
	LDS  R23,_current3k+3
	CALL __PUTPARD1
	LDS  R30,_voltage5k
	LDS  R31,_voltage5k+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current5k
	LDS  R31,_current5k+1
	LDS  R22,_current5k+2
	LDS  R23,_current5k+3
	CALL __PUTPARD1
	__GETD1N 0x3
	CALL __PUTPARD1
	__GETD1N 0xD
	CALL __PUTPARD1
	__GETD1N 0xA
	CALL __PUTPARD1
	LDI  R24,40
	CALL _sprintf
	ADIW R28,44
; 0000 0383                             for (index=0;index<strlen(_coordresp);index++) sprintf(_coordResponse+strlen(_coordResponse),"%02X",_coordresp[index]);
	LDI  R17,LOW(0)
_0x105:
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x106
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,65
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(88))
	SBCI R27,HIGH(-(88))
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	SUBI R17,-1
	RJMP _0x105
_0x106:
; 0000 0385 _3gZipSend(1,_coordResponse);
	RJMP _0x17F
; 0000 0386                         }
; 0000 0387                     else if (strstr(request,":D")!=NULL)    //  if the request is to send dust concentration value
_0x103:
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xF6,34
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0x108
; 0000 0388                         {
; 0000 0389                             sprintf(_coordresp,"%c%c%cD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),dustconcentration,ETX,CR,LF);
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,295
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x30
	CALL __PUTPARD1
	LDS  R30,_dustconcentration
	LDS  R31,_dustconcentration+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x3
	CALL __PUTPARD1
	__GETD1N 0xD
	CALL __PUTPARD1
	__GETD1N 0xA
	CALL __PUTPARD1
	LDI  R24,28
	CALL _sprintf
	ADIW R28,32
; 0000 038A                             for (index=0;index<strlen(_coordresp);index++) sprintf(_coordResponse+strlen(_coordResponse),"%02X",_coordresp[index]);
	LDI  R17,LOW(0)
_0x10A:
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x10B
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,65
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(88))
	SBCI R27,HIGH(-(88))
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	SUBI R17,-1
	RJMP _0x10A
_0x10B:
; 0000 038C _3gZipSend(1,_coordResponse);
_0x17F:
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	RCALL __3gZipSend
; 0000 038D                         };
_0x108:
_0xFD:
_0xFB:
_0xF9:
_0xF7:
; 0000 038E                     memset(request,0,sizeof(request)); // reset serial_command array
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 038F                 }
; 0000 0390             else if (strstr(request,dev_id_chk)==NULL)// if the serial_command doesn't contain this device's ID
	RJMP _0x10C
_0xF4:
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_dev_id_chk)
	LDI  R31,HIGH(_dev_id_chk)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ PC+3
	JMP _0x10D
; 0000 0391                 {
; 0000 0392                     //for (index=1;index<3;index++) _devid[index-1]=request[index];
; 0000 0393                     //_devID=atoi(_devid);
; 0000 0394                     _devID=(request[1]<<8)+request[2];
	__LSLW8SX 128
	MOVW R26,R30
	__GETB1SX 129
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
; 0000 0395                     for (index=0;index<sizeof(ledID);index++)
	LDI  R17,LOW(0)
_0x10F:
	CPI  R17,8
	BRSH _0x110
; 0000 0396                         {
; 0000 0397                             if (_devID==ledID[index]) break;
	MOV  R30,R17
	LDI  R26,LOW(_ledID)
	LDI  R27,HIGH(_ledID)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x110
; 0000 0398                         }
	SUBI R17,-1
	RJMP _0x10F
_0x110:
; 0000 0399                     xbeeTransmit(request,strlen(request),led_64bitaddress_high[index],led_64bitaddress_low[index]);
	MOVW R30,R28
	SUBI R30,LOW(-(127))
	SBCI R31,HIGH(-(127))
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(129))
	SBCI R31,HIGH(-(129))
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	LDI  R26,LOW(_led_64bitaddress_high)
	LDI  R27,HIGH(_led_64bitaddress_high)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	CALL __PUTPARD1
	MOV  R30,R17
	LDI  R26,LOW(_led_64bitaddress_low)
	LDI  R27,HIGH(_led_64bitaddress_low)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	CALL __PUTPARD1
	CALL _xbeeTransmit
; 0000 039A                 }
; 0000 039B         }
_0x10D:
_0x10C:
; 0000 039C }
_0xF3:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,63
	ADIW R28,21
	RET

	.DSEG
_0xF6:
	.BYTE 0x25
;
;void getDataFromZigbeeRouterAndForwardToServer(void)
; 0000 039F {

	.CSEG
_getDataFromZigbeeRouterAndForwardToServer:
; 0000 03A0     char receivedPacket[40],_3gPacket[80];
; 0000 03A1     unsigned char index,indic1;
; 0000 03A2     memset(receivedPacket,0,sizeof(receivedPacket));
	SBIW R28,63
	SBIW R28,57
	ST   -Y,R17
	ST   -Y,R16
;	receivedPacket -> Y+82
;	_3gPacket -> Y+2
;	index -> R17
;	indic1 -> R16
	MOVW R30,R28
	SUBI R30,LOW(-(82))
	SBCI R31,HIGH(-(82))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 03A3     memset(_3gPacket,0,sizeof(_3gPacket));
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 03A4     indic1=xbeeReceive(receivedPacket);
	MOVW R30,R28
	SUBI R30,LOW(-(82))
	SBCI R31,HIGH(-(82))
	ST   -Y,R31
	ST   -Y,R30
	CALL _xbeeReceive
	MOV  R16,R30
; 0000 03A5     if (indic1==1)
	CPI  R16,1
	BRNE _0x112
; 0000 03A6         {
; 0000 03A7             for (index=0;index<strlen(receivedPacket);index++) sprintf(_3gPacket+strlen(_3gPacket),"%02X",receivedPacket[index]);
	LDI  R17,LOW(0)
_0x114:
	MOVW R30,R28
	SUBI R30,LOW(-(82))
	SBCI R31,HIGH(-(82))
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x115
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,65
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(86))
	SBCI R27,HIGH(-(86))
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	SUBI R17,-1
	RJMP _0x114
_0x115:
; 0000 03A9 _3gZipSend(1,_3gPacket);
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	RCALL __3gZipSend
; 0000 03AA         }
; 0000 03AB }
_0x112:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,63
	ADIW R28,59
	RET
;
;unsigned int getPM10Concentration(void)
; 0000 03AE {
_getPM10Concentration:
; 0000 03AF     unsigned char i;
; 0000 03B0     unsigned long d[14],measuredValue;
; 0000 03B1     unsigned int CAI; // comprehensive air-quality index (korean AQI)
; 0000 03B2     float pm10Conc;
; 0000 03B3     poutput=USART2;
	SBIW R28,63
	SBIW R28,1
	CALL __SAVELOCR4
;	i -> R17
;	d -> Y+12
;	measuredValue -> Y+8
;	CAI -> R18,R19
;	pm10Conc -> Y+4
	LDI  R30,LOW(2)
	STS  _poutput,R30
; 0000 03B4     putchar(0x11);
	LDI  R30,LOW(17)
	ST   -Y,R30
	CALL _putchar
; 0000 03B5     putchar(0x01);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 03B6     putchar(0x01);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 03B7     putchar(0xED);
	LDI  R30,LOW(237)
	ST   -Y,R30
	CALL _putchar
; 0000 03B8     if (getchar()==0x16)
	CALL _getchar
	CPI  R30,LOW(0x16)
	BRNE _0x116
; 0000 03B9         {
; 0000 03BA             if (getchar()==0x0D)
	CALL _getchar
	CPI  R30,LOW(0xD)
	BRNE _0x117
; 0000 03BB                 {
; 0000 03BC                     if (getchar()==0x01)
	CALL _getchar
	CPI  R30,LOW(0x1)
	BRNE _0x118
; 0000 03BD                         {
; 0000 03BE                             for (i=0;i<13;i++) d[i]=getchar();
	LDI  R17,LOW(0)
_0x11A:
	CPI  R17,13
	BRSH _0x11B
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,12
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTDP1
	SUBI R17,-1
	RJMP _0x11A
_0x11B:
; 0000 03BF }
; 0000 03C0                 }
_0x118:
; 0000 03C1         }
_0x117:
; 0000 03C2     measuredValue=d[0]<<24|d[1]<<16|d[2]<<8|d[3]; //arrange the value
_0x116:
	__GETD2S 12
	LDI  R30,LOW(24)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 16
	CALL __LSLD16
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 20
	LDI  R30,LOW(8)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	__GETD2S 24
	CALL __ORD12
	__PUTD1S 8
; 0000 03C3     pm10Conc=measuredValue*0.03528;
	CALL __CDF1U
	__GETD2N 0x3D1081C3
	CALL __MULF12
	__PUTD1S 4
; 0000 03C4     if (pm10Conc>600.0) pm10Conc=600.0; //set 600 as highest concentration value, for CAI conversion purposes
	__GETD2S 4
	__GETD1N 0x44160000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11C
	__PUTD1S 4
; 0000 03C5 
; 0000 03C6     // PM10 to CAI conversion, see http://www.airkorea.or.kr/eng/cai/cai1
; 0000 03C7     if ((0.0<=pm10Conc)&&(pm10Conc<31.0)) CAI=(unsigned int)(pm10Conc*5/3);
_0x11C:
	LDD  R30,Y+7
	TST  R30
	BRMI _0x11E
	__GETD2S 4
	__GETD1N 0x41F80000
	CALL __CMPF12
	BRLO _0x11F
_0x11E:
	RJMP _0x11D
_0x11F:
	__GETD2S 4
	__GETD1N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40400000
	CALL __DIVF21
	RJMP _0x180
; 0000 03C8     else if ((31.0<=pm10Conc)&&(pm10Conc<81.0)) CAI=(unsigned int)(pm10Conc+20);
_0x11D:
	__GETD1S 4
	__GETD2N 0x41F80000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x122
	__GETD2S 4
	__GETD1N 0x42A20000
	CALL __CMPF12
	BRLO _0x123
_0x122:
	RJMP _0x121
_0x123:
	__GETD1S 4
	__GETD2N 0x41A00000
	RJMP _0x181
; 0000 03C9     else if ((81.0<=pm10Conc)&&(pm10Conc<151.0)) CAI=(unsigned int)((pm10Conc-81)*149/69+101);
_0x121:
	__GETD1S 4
	__GETD2N 0x42A20000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x126
	__GETD2S 4
	__GETD1N 0x43170000
	CALL __CMPF12
	BRLO _0x127
_0x126:
	RJMP _0x125
_0x127:
	__GETD1S 4
	__GETD2N 0x42A20000
	CALL __SUBF12
	__GETD2N 0x43150000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x428A0000
	CALL __DIVF21
	__GETD2N 0x42CA0000
	RJMP _0x181
; 0000 03CA     else if ((151.0<=pm10Conc)&&(pm10Conc<=600.0)) CAI=(unsigned int)((pm10Conc-151)*249/449+251);
_0x125:
	__GETD1S 4
	__GETD2N 0x43170000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x12A
	__GETD2S 4
	__GETD1N 0x44160000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x12A
	RJMP _0x12B
_0x12A:
	RJMP _0x129
_0x12B:
	__GETD1S 4
	__GETD2N 0x43170000
	CALL __SUBF12
	__GETD2N 0x43790000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43E08000
	CALL __DIVF21
	__GETD2N 0x437B0000
_0x181:
	CALL __ADDF12
_0x180:
	CALL __CFD1U
	MOVW R18,R30
; 0000 03CB     return CAI;
_0x129:
	MOVW R30,R18
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,5
	RET
; 0000 03CC 
; 0000 03CD     //return (unsigned int)(measuredValue*0.03528); // pm10 concentration in ug/mm3
; 0000 03CE }
;
;char SHT_WriteByte(unsigned char bytte)
; 0000 03D1 {
_SHT_WriteByte:
; 0000 03D2     unsigned char i,error=0;
; 0000 03D3     DDRC = 0b00000011;    //
	ST   -Y,R17
	ST   -Y,R16
;	bytte -> Y+2
;	i -> R17
;	error -> R16
	LDI  R16,0
	LDI  R30,LOW(3)
	OUT  0x7,R30
; 0000 03D4     for (i=0x80;i>0;i/=2) //shift bit for masking
	LDI  R17,LOW(128)
_0x12D:
	CPI  R17,1
	BRLO _0x12E
; 0000 03D5         {
; 0000 03D6             if (i & bytte)
	LDD  R30,Y+2
	AND  R30,R17
	BREQ _0x12F
; 0000 03D7             DATA_OUT=1; //masking value with i , write to SENSI-BUS
	SBI  0x8,0
; 0000 03D8             else DATA_OUT=0;
	RJMP _0x132
_0x12F:
	CBI  0x8,0
; 0000 03D9             SCK=1;      //clk for SENSI-BUS
_0x132:
	SBI  0x8,1
; 0000 03DA             delay_us(5); //pulswith approx. 5 us
	__DELAY_USB 27
; 0000 03DB             SCK=0;
	CBI  0x8,1
; 0000 03DC         }
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOV  R17,R30
	RJMP _0x12D
_0x12E:
; 0000 03DD     DATA_OUT=1;            //release dataline
	SBI  0x8,0
; 0000 03DE     DDRC = 0b00000010;    // DATA is Output
	LDI  R30,LOW(2)
	OUT  0x7,R30
; 0000 03DF     SCK=1;                //clk #9 for ack
	SBI  0x8,1
; 0000 03E0     delay_us(2);
	__DELAY_USB 11
; 0000 03E1     error=DATA_IN;       //check ack (DATA will be pulled down by SHT11)
	LDI  R30,0
	SBIC 0x6,0
	LDI  R30,1
	MOV  R16,R30
; 0000 03E2     delay_us(2);
	__DELAY_USB 11
; 0000 03E3     SCK=0;
	CBI  0x8,1
; 0000 03E4     return error;       //error=1 in case of no acknowledge
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0008
; 0000 03E5 }
;
;char SHT_ReadByte(unsigned char ack)
; 0000 03E8 {
_SHT_ReadByte:
; 0000 03E9     unsigned char i,val=0;
; 0000 03EA     DDRC = 0b00000010;    // DATA is Input
	ST   -Y,R17
	ST   -Y,R16
;	ack -> Y+2
;	i -> R17
;	val -> R16
	LDI  R16,0
	LDI  R30,LOW(2)
	OUT  0x7,R30
; 0000 03EB     for (i=0x80;i>0;i/=2)             //shift bit for masking
	LDI  R17,LOW(128)
_0x140:
	CPI  R17,1
	BRLO _0x141
; 0000 03EC         {
; 0000 03ED             SCK=1;                          //clk for SENSI-BUS
	SBI  0x8,1
; 0000 03EE             delay_us(2);
	__DELAY_USB 11
; 0000 03EF             if (DATA_IN) val=(val | i);        //read bit
	SBIC 0x6,0
	OR   R16,R17
; 0000 03F0             delay_us(2);
	__DELAY_USB 11
; 0000 03F1             SCK=0;
	CBI  0x8,1
; 0000 03F2         }
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOV  R17,R30
	RJMP _0x140
_0x141:
; 0000 03F3     DDRC = 0b00000011;    // DATA is Output
	LDI  R30,LOW(3)
	OUT  0x7,R30
; 0000 03F4     DATA_OUT=!ack;        //in case of "ack==1" pull down DATA-Line
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x147
	CBI  0x8,0
	RJMP _0x148
_0x147:
	SBI  0x8,0
_0x148:
; 0000 03F5     SCK=1;                //clk #9 for ack
	SBI  0x8,1
; 0000 03F6     delay_us(5);          //pulswith approx. 5 us
	__DELAY_USB 27
; 0000 03F7     SCK=0;
	CBI  0x8,1
; 0000 03F8     DATA_OUT=1;           //release DATA-line  //ADD BY LUBING
	SBI  0x8,0
; 0000 03F9     return val;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0008
; 0000 03FA }
;
;void SHT_Transstart(void)
; 0000 03FD {
_SHT_Transstart:
; 0000 03FE     DDRC = 0b00000011;    // DATA is Output
	LDI  R30,LOW(3)
	OUT  0x7,R30
; 0000 03FF     DATA_OUT=1; SCK=0;   //Initial state
	SBI  0x8,0
	CBI  0x8,1
; 0000 0400     delay_us(2);
	__DELAY_USB 11
; 0000 0401     SCK=1;
	SBI  0x8,1
; 0000 0402     delay_us(2);
	__DELAY_USB 11
; 0000 0403     DATA_OUT=0;
	CBI  0x8,0
; 0000 0404     delay_us(2);
	__DELAY_USB 11
; 0000 0405     SCK=0;
	CBI  0x8,1
; 0000 0406     delay_us(5);
	__DELAY_USB 27
; 0000 0407     SCK=1;
	SBI  0x8,1
; 0000 0408     delay_us(2);
	__DELAY_USB 11
; 0000 0409     DATA_OUT=1;
	SBI  0x8,0
; 0000 040A     delay_us(2);
	__DELAY_USB 11
; 0000 040B     SCK=0;
	CBI  0x8,1
; 0000 040C     DDRC = 0b00000010;    // DATA is Input
	LDI  R30,LOW(2)
	OUT  0x7,R30
; 0000 040D }
	RET
;
;void SHT_ConnectionRest(void)
; 0000 0410 {
_SHT_ConnectionRest:
; 0000 0411     unsigned char i;
; 0000 0412     DDRC = 0b00000011;    // DATA is output
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(3)
	OUT  0x7,R30
; 0000 0413     DATA_OUT=1; SCK=0;                    //Initial state
	SBI  0x8,0
	CBI  0x8,1
; 0000 0414     for(i=0;i<9;i++)                  //9 SCK cycles
	LDI  R17,LOW(0)
_0x164:
	CPI  R17,9
	BRSH _0x165
; 0000 0415         {
; 0000 0416             SCK=1;
	SBI  0x8,1
; 0000 0417             delay_us(1);
	__DELAY_USB 5
; 0000 0418             SCK=0;
	CBI  0x8,1
; 0000 0419             delay_us(1);
	__DELAY_USB 5
; 0000 041A         }
	SUBI R17,-1
	RJMP _0x164
_0x165:
; 0000 041B     SHT_Transstart();                   //transmission start
	RCALL _SHT_Transstart
; 0000 041C     DDRC = 0b00000010;    // DATA is Input
	LDI  R30,LOW(2)
	OUT  0x7,R30
; 0000 041D }
	RJMP _0x20A0009
;
;char SHT_SoftRst(void)
; 0000 0420 {
_SHT_SoftRst:
; 0000 0421     unsigned char error=0;
; 0000 0422     SHT_ConnectionRest();              //reset communication
	ST   -Y,R17
;	error -> R17
	LDI  R17,0
	RCALL _SHT_ConnectionRest
; 0000 0423     error+=SHT_WriteByte(RESET);       //send RESET-command to sensor
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL _SHT_WriteByte
	ADD  R17,R30
; 0000 0424     return error;                     //error=1 in case of no response form the sensor
	MOV  R30,R17
_0x20A0009:
	LD   R17,Y+
	RET
; 0000 0425 }
;
;char SHT_Read_StatusReg(unsigned char *p_value, unsigned char *p_checksum)
; 0000 0428 {
_SHT_Read_StatusReg:
; 0000 0429     unsigned char error=0;
; 0000 042A     SHT_Transstart();                   //transmission start
	ST   -Y,R17
;	*p_value -> Y+3
;	*p_checksum -> Y+1
;	error -> R17
	LDI  R17,0
	RCALL _SHT_Transstart
; 0000 042B     error=SHT_WriteByte(STATUS_REG_R); //send command to sensor
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SHT_WriteByte
	MOV  R17,R30
; 0000 042C     *p_value=SHT_ReadByte(ACK);        //read status register (8-bit)
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SHT_ReadByte
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ST   X,R30
; 0000 042D     *p_checksum=SHT_ReadByte(noACK);   //read checksum (8-bit)
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SHT_ReadByte
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
; 0000 042E     return error;                     //error=1 in case of no response form the sensor
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x20A0005
; 0000 042F }
;
;char SHT_Write_StatusReg(unsigned char *p_value)
; 0000 0432 {
; 0000 0433     unsigned char error=0;
; 0000 0434     SHT_Transstart();                   //transmission start
;	*p_value -> Y+1
;	error -> R17
; 0000 0435     error+=SHT_WriteByte(STATUS_REG_W);//send command to sensor
; 0000 0436     error+=SHT_WriteByte(*p_value);    //send value of status register
; 0000 0437     return error;                     //error>=1 in case of no response form the sensor
; 0000 0438 }
;
;char SHT_Measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode)
; 0000 043B {
_SHT_Measure:
; 0000 043C     unsigned error=0;
; 0000 043D     unsigned int temp=0;
; 0000 043E     SHT_Transstart();                   //transmission start
	CALL __SAVELOCR4
;	*p_value -> Y+7
;	*p_checksum -> Y+5
;	mode -> Y+4
;	error -> R16,R17
;	temp -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RCALL _SHT_Transstart
; 0000 043F     switch(mode)
	LDD  R30,Y+4
	LDI  R31,0
; 0000 0440         {                     //send command to sensor
; 0000 0441             case TEMP : error+=SHT_WriteByte(MEASURE_TEMP); break;
	SBIW R30,0
	BRNE _0x16D
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _SHT_WriteByte
	LDI  R31,0
	__ADDWRR 16,17,30,31
	RJMP _0x16C
; 0000 0442             case HUMI : error+=SHT_WriteByte(MEASURE_HUMI); break;
_0x16D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x16F
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _SHT_WriteByte
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 0443             default      : break;
_0x16F:
; 0000 0444         }
_0x16C:
; 0000 0445     DDRC = 0b00000010;    // DATA is input
	LDI  R30,LOW(2)
	OUT  0x7,R30
; 0000 0446     while (1)
_0x170:
; 0000 0447         {
; 0000 0448             if(DATA_IN==0) break; //wait until sensor has finished the measurement
	SBIS 0x6,0
	RJMP _0x172
; 0000 0449         }
	RJMP _0x170
_0x172:
; 0000 044A     if(DATA_IN) error+=1;                // or timeout (~2 sec.) is reached
	SBIS 0x6,0
	RJMP _0x174
	__ADDWRN 16,17,1
; 0000 044B     switch(mode)
_0x174:
	LDD  R30,Y+4
	LDI  R31,0
; 0000 044C         {                     //send command to sensor
; 0000 044D             case TEMP : temp=0;
	SBIW R30,0
	BRNE _0x178
	__GETWRN 18,19,0
; 0000 044E                                 temp=SHT_ReadByte(ACK);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SHT_ReadByte
	MOV  R18,R30
	CLR  R19
; 0000 044F                                 temp<<=8;
	MOV  R19,R18
	CLR  R18
; 0000 0450                                 tempervalue[0]=temp;
	__PUTWMRN _tempervalue,0,18,19
; 0000 0451                                 temp=0;
	__GETWRN 18,19,0
; 0000 0452                                 temp=SHT_ReadByte(ACK);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SHT_ReadByte
	MOV  R18,R30
	CLR  R19
; 0000 0453                                 tempervalue[0]|=temp;
	MOVW R30,R18
	LDS  R26,_tempervalue
	LDS  R27,_tempervalue+1
	OR   R30,R26
	OR   R31,R27
	STS  _tempervalue,R30
	STS  _tempervalue+1,R31
; 0000 0454                                 break;
	RJMP _0x177
; 0000 0455             case HUMI : temp=0;
_0x178:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x17A
	__GETWRN 18,19,0
; 0000 0456                                 temp=SHT_ReadByte(ACK);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SHT_ReadByte
	MOV  R18,R30
	CLR  R19
; 0000 0457                                 temp<<=8;
	MOV  R19,R18
	CLR  R18
; 0000 0458                                 tempervalue[1]=temp;
	__POINTW1MN _tempervalue,2
	ST   Z,R18
	STD  Z+1,R19
; 0000 0459                                 temp=0;
	__GETWRN 18,19,0
; 0000 045A                                 temp=SHT_ReadByte(ACK);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SHT_ReadByte
	MOV  R18,R30
	CLR  R19
; 0000 045B                                 tempervalue[1]|=temp;
	__GETW1MN _tempervalue,2
	OR   R30,R18
	OR   R31,R19
	__PUTW1MN _tempervalue,2
; 0000 045C                                 break;
; 0000 045D             default      : break;
_0x17A:
; 0000 045E         }
_0x177:
; 0000 045F     *p_checksum =SHT_ReadByte(noACK);  //read checksum
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SHT_ReadByte
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ST   X,R30
; 0000 0460     return error;
	MOV  R30,R16
	CALL __LOADLOCR4
	ADIW R28,9
	RET
; 0000 0461 }
;
;float Calc_SHT71(float p_humidity ,float *p_temperature)
; 0000 0464 {
_Calc_SHT71:
; 0000 0465     const float C1=-4.0;              // for 12 Bit
; 0000 0466     const float C2=+0.0405;           // for 12 Bit
; 0000 0467     const float C3=-0.0000028;        // for 12 Bit
; 0000 0468     const float T1=+0.01;             // for 14 Bit @ 5V
; 0000 0469     const float T2=+0.00008;           // for 14 Bit @ 5V
; 0000 046A     float rh_lin;                     // rh_lin:  Humidity linear
; 0000 046B     float rh_true;                    // rh_true: Temperature compensated humidity
; 0000 046C     float t=*p_temperature;           // t:       Temperature [Ticks] 14 Bit
; 0000 046D     float rh=p_humidity;             // rh:      Humidity [Ticks] 12 Bit
; 0000 046E     float t_C;                        // t_C   :  Temperature [?]
; 0000 046F     t_C=t*0.01 - 40;                  //calc. temperature from ticks to [?]
	SBIW R28,40
	LDI  R24,20
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	LDI  R30,LOW(_0x17B*2)
	LDI  R31,HIGH(_0x17B*2)
	CALL __INITLOCB
;	p_humidity -> Y+42
;	*p_temperature -> Y+40
;	C1 -> Y+36
;	C2 -> Y+32
;	C3 -> Y+28
;	T1 -> Y+24
;	T2 -> Y+20
;	rh_lin -> Y+16
;	rh_true -> Y+12
;	t -> Y+8
;	rh -> Y+4
;	t_C -> Y+0
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	CALL __GETD1P
	__PUTD1S 8
	__GETD1S 42
	__PUTD1S 4
	__GETD2S 8
	__GETD1N 0x3C23D70A
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42200000
	CALL __SWAPD12
	CALL __SUBF12
	CALL __PUTD1S0
; 0000 0470     rh_lin=C3*rh*rh + C2*rh + C1;     //calc. humidity from ticks to [%RH]
	__GETD1S 4
	__GETD2N 0xB63BE7A2
	CALL __MULF12
	__GETD2S 4
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 4
	__GETD2N 0x3D25E354
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	__GETD2N 0xC0800000
	CALL __ADDF12
	__PUTD1S 16
; 0000 0471     rh_true=(t_C-25)*(T1+T2*rh)+rh_lin;   //calc. temperature compensated humidity [%RH]
	CALL __GETD1S0
	__GETD2N 0x41C80000
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 4
	__GETD2N 0x38A7C5AC
	CALL __MULF12
	__GETD2N 0x3C23D70A
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	__GETD2S 16
	CALL __ADDF12
	__PUTD1S 12
; 0000 0472     if(rh_true>100)rh_true=100;       //cut if the value is outside of
	__GETD2S 12
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x17C
	__PUTD1S 12
; 0000 0473     if(rh_true<0.1)rh_true=0.1;       //the physical possible range
_0x17C:
	__GETD2S 12
	__GETD1N 0x3DCCCCCD
	CALL __CMPF12
	BRSH _0x17D
	__PUTD1S 12
; 0000 0474     *p_temperature=t_C;               //return temperature [?]
_0x17D:
	CALL __GETD1S0
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	CALL __PUTDP1
; 0000 0475     return rh_true;
	__GETD1S 12
	ADIW R28,46
	RET
; 0000 0476 }
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_gets:
	CALL __SAVELOCR6
	__GETWRS 16,17,6
	__GETWRS 18,19,8
_0x2000009:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x200000B
_0x200000C:
	CALL _getchar
	MOV  R21,R30
	CPI  R21,8
	BRNE _0x200000D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R16,R26
	CPC  R17,R27
	BRSH _0x200000E
	__SUBWRN 18,19,1
	__ADDWRN 16,17,1
_0x200000E:
	RJMP _0x200000C
_0x200000D:
	CPI  R21,10
	BREQ _0x200000B
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOV  R30,R21
	POP  R26
	POP  R27
	ST   X,R30
	__SUBWRN 16,17,1
	RJMP _0x2000009
_0x200000B:
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LOADLOCR6
	ADIW R28,10
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20A0008:
	ADIW R28,3
	RET
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0005
__ftoe_G100:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20A0007
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20A0007
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
_0x2000022:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRLO _0x2000024
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRSH _0x2000028
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
_0x2000025:
	__GETD1S 12
	__GETD2N 0x3F000000
	CALL __ADDF12
	__PUTD1S 12
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRLO _0x2000029
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRSH PC+3
	JMP _0x200002C
	__GETD2S 4
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	__GETD2S 12
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	__GETD2S 12
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 12
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BREQ _0x200002D
	RJMP _0x200002A
_0x200002D:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x200002E:
	CPI  R19,10
	BRLT _0x200002F
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0x200002F:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0007:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G100:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x200010E
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	__GETW2SX 90
	CALL __GETD1P
	__PUTD1S 10
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	RJMP _0x200005E
_0x200005B:
	__GETD1S 10
	CALL __ANEGF1
	__PUTD1S 10
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x200005F
	LDD  R30,Y+21
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2000060
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000060:
_0x200005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000062
	__GETD1S 10
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2000063
_0x2000062:
	__GETD1S 10
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G100
_0x2000063:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000064
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000066
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0x70)
	BRNE _0x2000069
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006B
	CP   R20,R17
	BRLO _0x200006C
_0x200006B:
	RJMP _0x200006A
_0x200006C:
	MOV  R17,R20
_0x200006A:
_0x2000064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006D
_0x2000069:
	CPI  R30,LOW(0x64)
	BREQ _0x2000070
	CPI  R30,LOW(0x69)
	BRNE _0x2000071
_0x2000070:
	ORI  R16,LOW(4)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0x75)
	BRNE _0x2000073
_0x2000072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000074
	__GETD1N 0x3B9ACA00
	__PUTD1S 16
	LDI  R17,LOW(10)
	RJMP _0x2000075
_0x2000074:
	__GETD1N 0x2710
	__PUTD1S 16
	LDI  R17,LOW(5)
	RJMP _0x2000075
_0x2000073:
	CPI  R30,LOW(0x58)
	BRNE _0x2000077
	ORI  R16,LOW(8)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000B6
_0x2000078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007A
	__GETD1N 0x10000000
	__PUTD1S 16
	LDI  R17,LOW(8)
	RJMP _0x2000075
_0x200007A:
	__GETD1N 0x1000
	__PUTD1S 16
	LDI  R17,LOW(4)
_0x2000075:
	CPI  R20,0
	BREQ _0x200007B
	ANDI R16,LOW(127)
	RJMP _0x200007C
_0x200007B:
	LDI  R20,LOW(1)
_0x200007C:
	SBRS R16,1
	RJMP _0x200007D
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x200010F
_0x200007D:
	SBRS R16,2
	RJMP _0x200007F
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x200010F
_0x200007F:
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x200010F:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000082
	__GETD1S 10
	CALL __ANEGD1
	__PUTD1S 10
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000084
_0x2000083:
	ANDI R16,LOW(251)
_0x2000084:
_0x2000081:
	MOV  R19,R20
_0x200006D:
	SBRC R16,0
	RJMP _0x2000085
_0x2000086:
	CP   R17,R21
	BRSH _0x2000089
	CP   R19,R21
	BRLO _0x200008A
_0x2000089:
	RJMP _0x2000088
_0x200008A:
	SBRS R16,7
	RJMP _0x200008B
	SBRS R16,2
	RJMP _0x200008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008D
_0x200008C:
	LDI  R18,LOW(48)
_0x200008D:
	RJMP _0x200008E
_0x200008B:
	LDI  R18,LOW(32)
_0x200008E:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x2000086
_0x2000088:
_0x2000085:
_0x200008F:
	CP   R17,R20
	BRSH _0x2000091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000092
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	BREQ _0x2000093
	SUBI R21,LOW(1)
_0x2000093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x2000094
	SUBI R21,LOW(1)
_0x2000094:
	SUBI R20,LOW(1)
	RJMP _0x200008F
_0x2000091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000095
_0x2000096:
	CPI  R19,0
	BREQ _0x2000098
	SBRS R16,3
	RJMP _0x2000099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009A
_0x2000099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009A:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R19,LOW(1)
	RJMP _0x2000096
_0x2000098:
	RJMP _0x200009C
_0x2000095:
_0x200009E:
	__GETD1S 16
	__GETD2S 10
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	SUBI R18,-LOW(55)
	RJMP _0x20000A2
_0x20000A1:
	SUBI R18,-LOW(87)
_0x20000A2:
	RJMP _0x20000A3
_0x20000A0:
	SUBI R18,-LOW(48)
_0x20000A3:
	SBRC R16,4
	RJMP _0x20000A5
	CPI  R18,49
	BRSH _0x20000A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A6
_0x20000A7:
	RJMP _0x20000A9
_0x20000A6:
	CP   R20,R19
	BRSH _0x2000110
	CP   R21,R19
	BRLO _0x20000AC
	SBRS R16,0
	RJMP _0x20000AD
_0x20000AC:
	RJMP _0x20000AB
_0x20000AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000AE
_0x2000110:
	LDI  R18,LOW(48)
_0x20000A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000AF
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	BREQ _0x20000B0
	SUBI R21,LOW(1)
_0x20000B0:
_0x20000AF:
_0x20000AE:
_0x20000A5:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x20000B1
	SUBI R21,LOW(1)
_0x20000B1:
_0x20000AB:
	SUBI R19,LOW(1)
	__GETD1S 16
	__GETD2S 10
	CALL __MODD21U
	__PUTD1S 10
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 16
	CALL __CPD10
	BREQ _0x200009F
	RJMP _0x200009E
_0x200009F:
_0x200009C:
	SBRS R16,0
	RJMP _0x20000B2
_0x20000B3:
	CPI  R21,0
	BREQ _0x20000B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x20000B3
_0x20000B5:
_0x20000B2:
_0x20000B6:
_0x2000054:
_0x200010E:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0006
_0x20000B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0006:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG
_memset:
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x20A0005:
	ADIW R28,5
	RET
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
_strpbrkf:
    ldd  r27,y+3
    ldd  r26,y+2
strpbrkf0:
    ld   r22,x
    tst  r22
    breq strpbrkf2
    ldd  r31,y+1
    ld   r30,y
strpbrkf1:
	lpm
    tst  r0
    breq strpbrkf3
    adiw r30,1
    cp   r22,r0
    brne strpbrkf1
    movw r30,r26
    rjmp strpbrkf4
strpbrkf3:
    adiw r26,1
    rjmp strpbrkf0
strpbrkf2:
    clr  r30
    clr  r31
strpbrkf4:
	JMP  _0x20A0001
_strstr:
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
	JMP  _0x20A0001
_strspnf:
    ldd  r27,y+3
    ldd  r26,y+2
    clr  r24
    clr  r25
strspnf0:
    ld   r22,x+
    tst  r22
    breq strspnf2
    ldd  r31,y+1
    ld   r30,y
strspnf1:
	lpm  r0,z+
    tst  r0
    breq strspnf2
    cp   r22,r0
    brne strspnf1
    adiw r24,1
    rjmp strspnf0
strspnf2:
    movw r30,r24
	JMP  _0x20A0001
_strtok:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x2020003
	LDS  R30,_p_S1010024000
	LDS  R31,_p_S1010024000+1
	SBIW R30,0
	BRNE _0x2020004
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0004
_0x2020004:
	LDS  R30,_p_S1010024000
	LDS  R31,_p_S1010024000+1
	STD  Y+4,R30
	STD  Y+4+1,R31
_0x2020003:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strspnf
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x2020005
	LDI  R30,LOW(0)
	STS  _p_S1010024000,R30
	STS  _p_S1010024000+1,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0004
_0x2020005:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strpbrkf
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020006
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2020006:
	__PUTWMRN _p_S1010024000,0,16,17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
_0x20A0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x204000D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2040000,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20A0003
_0x204000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x204000C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2040000,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20A0003
_0x204000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x204000F
	__GETD1S 9
	CALL __ANEGF1
	__PUTD1S 9
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(45)
	ST   X,R30
_0x204000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2040010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2040010:
	LDD  R17,Y+8
_0x2040011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2040013
	__GETD2S 2
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 2
	RJMP _0x2040011
_0x2040013:
	__GETD1S 2
	__GETD2S 9
	CALL __ADDF12
	__PUTD1S 9
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	__PUTD1S 2
_0x2040014:
	__GETD1S 2
	__GETD2S 9
	CALL __CMPF12
	BRLO _0x2040016
	__GETD2S 2
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 2
	SUBI R17,-LOW(1)
	RJMP _0x2040014
_0x2040016:
	CPI  R17,0
	BRNE _0x2040017
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2040018
_0x2040017:
_0x2040019:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x204001B
	__GETD2S 2
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 2
	__GETD2S 9
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	__GETD2S 2
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	__GETD2S 9
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RJMP _0x2040019
_0x204001B:
_0x2040018:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x204001C
	RJMP _0x20A0002
_0x204001C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
_0x204001D:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x204001F
	__GETD2S 9
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 9
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	__GETD2S 9
	CALL __CWD1
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RJMP _0x204001D
_0x204001F:
_0x20A0002:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.CSEG

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL __GETD1S0
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20A0001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20A0001:
	ADIW R28,4
	RET

	.DSEG
_SERVER_IP:
	.BYTE 0xF
_rx_buffer0:
	.BYTE 0x3E8
_rx_buffer1:
	.BYTE 0x3E8
_rx_buffer2:
	.BYTE 0xFF
_rx_buffer3:
	.BYTE 0xFF
_rx_wr_index2:
	.BYTE 0x1
_rx_rd_index2:
	.BYTE 0x1
_rx_counter2:
	.BYTE 0x1
_rx_wr_index3:
	.BYTE 0x1
_rx_rd_index3:
	.BYTE 0x1
_rx_counter3:
	.BYTE 0x1
_poutput:
	.BYTE 0x1
_milSecCounter:
	.BYTE 0x4
_dev_id_chk:
	.BYTE 0x5
_tempervalue:
	.BYTE 0x4
_ledID:
	.BYTE 0x8
_led_64bitaddress_high:
	.BYTE 0x10
_led_64bitaddress_low:
	.BYTE 0x10
_temperature:
	.BYTE 0x4
_humidity:
	.BYTE 0x4
_dustconcentration:
	.BYTE 0x2
_current3k:
	.BYTE 0x4
_current5k:
	.BYTE 0x4
_voltage3k:
	.BYTE 0x2
_voltage5k:
	.BYTE 0x2
_p_S1010024000:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
