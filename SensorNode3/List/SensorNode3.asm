
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
	.DEF _dustconcentration=R3
	.DEF _voltage3k=R5
	.DEF _voltage5k=R7
	.DEF _rx_wr_index0=R10
	.DEF _rx_rd_index0=R9
	.DEF _rx_counter0=R12
	.DEF _rx_wr_index1=R11
	.DEF _rx_rd_index1=R14
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
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x0,0x0,0xC0,0x3F
_0x62:
	.DB  0x0,0x0,0x4,0x1
_0x0:
	.DB  0x3A,0x50,0x0,0x25,0x63,0x25,0x63,0x25
	.DB  0x63,0x54,0x25,0x2B,0x30,0x34,0x2E,0x31
	.DB  0x66,0x48,0x25,0x30,0x34,0x2E,0x31,0x66
	.DB  0x33,0x56,0x25,0x30,0x33,0x75,0x49,0x25
	.DB  0x30,0x33,0x2E,0x31,0x66,0x35,0x56,0x25
	.DB  0x30,0x33,0x75,0x49,0x25,0x30,0x33,0x2E
	.DB  0x31,0x66,0x44,0x25,0x30,0x33,0x75,0x25
	.DB  0x63,0x25,0x63,0x25,0x63,0x0,0x3A,0x4F
	.DB  0x4E,0x33,0x4B,0x0,0x3A,0x4F,0x4E,0x35
	.DB  0x4B,0x0,0x3A,0x4F,0x46,0x46,0x33,0x4B
	.DB  0x0,0x3A,0x4F,0x46,0x46,0x35,0x4B,0x0
	.DB  0x3A,0x54,0x48,0x0,0x25,0x63,0x25,0x63
	.DB  0x25,0x63,0x54,0x25,0x2B,0x30,0x34,0x2E
	.DB  0x31,0x66,0x48,0x25,0x30,0x34,0x2E,0x31
	.DB  0x66,0x25,0x63,0x25,0x63,0x25,0x63,0x0
	.DB  0x3A,0x56,0x49,0x0,0x25,0x63,0x25,0x63
	.DB  0x25,0x63,0x33,0x56,0x25,0x30,0x33,0x75
	.DB  0x49,0x25,0x30,0x33,0x2E,0x31,0x66,0x35
	.DB  0x56,0x25,0x30,0x33,0x75,0x49,0x25,0x30
	.DB  0x33,0x2E,0x31,0x66,0x25,0x63,0x25,0x63
	.DB  0x25,0x63,0x0,0x3A,0x44,0x0,0x25,0x63
	.DB  0x25,0x63,0x25,0x63,0x44,0x25,0x30,0x33
	.DB  0x75,0x25,0x63,0x25,0x63,0x25,0x63,0x0
	.DB  0x25,0x63,0x25,0x63,0x3A,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x204005F:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _current5k
	.DW  _0x3*2

	.DW  0x03
	.DW  _0x46
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x46+3
	.DW  _0x0*2+62

	.DW  0x06
	.DW  _0x46+9
	.DW  _0x0*2+68

	.DW  0x07
	.DW  _0x46+15
	.DW  _0x0*2+74

	.DW  0x07
	.DW  _0x46+22
	.DW  _0x0*2+81

	.DW  0x04
	.DW  _0x46+29
	.DW  _0x0*2+88

	.DW  0x04
	.DW  _0x46+33
	.DW  _0x0*2+120

	.DW  0x03
	.DW  _0x46+37
	.DW  _0x0*2+163

	.DW  0x04
	.DW  0x05
	.DW  _0x62*2

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
;#define STX 0x02
;#define ETX 0x03
;#define delimiter 0x3A
;#define CR 0x0D
;#define LF 0x0A
;#define DEV_ID 0x3531  //the 16-bit ID for coordinator, taken from the least significant 16-bit of zigbee xbee 64-bit address
;#define COORDID1 DEV_ID>>8
;#define COORDID2 (char)DEV_ID
;#define RX_BUFFER_SIZE0 100
;#define RX_BUFFER_SIZE1 100
;#define RX_BUFFER_SIZE2 50
;#define USART0 0
;#define USART1 1
;#define USART2 2
;#define ADC_VREF_TYPE 0x40
;#define _ALTERNATE_GETCHAR_
;#define _ALTERNATE_PUTCHAR_
;
;char dev_id_chk[5];
;// arbitrary data
;float temperature;
;float humidity;
;unsigned int dustconcentration;
;float current3k=0;
;float current5k=1.5;

	.DSEG
;unsigned int voltage3k=0;
;unsigned int voltage5k=260;
;
;char rx_buffer0[RX_BUFFER_SIZE0],rx_buffer1[RX_BUFFER_SIZE1],rx_buffer2[RX_BUFFER_SIZE2];
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
;unsigned char rx_wr_index2,rx_rd_index2,rx_counter2;
;bit rx_buffer_overflow0,rx_buffer_overflow1,rx_buffer_overflow2;
;unsigned char poutput;
;volatile unsigned long milSecCounter;
;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 003A {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003B     char status,data;
; 0000 003C     status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 003D     data=UDR0;
	LDS  R16,198
; 0000 003E     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x4
; 0000 003F     {
; 0000 0040         rx_buffer0[rx_wr_index0]=data;
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0041         if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	INC  R10
	LDI  R30,LOW(100)
	CP   R30,R10
	BRNE _0x5
	CLR  R10
; 0000 0042         if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x5:
	INC  R12
	LDI  R30,LOW(100)
	CP   R30,R12
	BRNE _0x6
; 0000 0043         {
; 0000 0044             rx_counter0=0;
	CLR  R12
; 0000 0045             rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 0046         };
_0x6:
; 0000 0047     };
_0x4:
; 0000 0048 }
	RJMP _0x61
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 004C {
_usart1_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004D     char status,data;
; 0000 004E     status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,200
; 0000 004F     data=UDR1;
	LDS  R16,206
; 0000 0050     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x9
; 0000 0051         {
; 0000 0052             rx_buffer1[rx_wr_index1]=data;
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 0053             if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	INC  R11
	LDI  R30,LOW(100)
	CP   R30,R11
	BRNE _0xA
	CLR  R11
; 0000 0054             if (++rx_counter1 == RX_BUFFER_SIZE1)
_0xA:
	INC  R13
	LDI  R30,LOW(100)
	CP   R30,R13
	BRNE _0xB
; 0000 0055                 {
; 0000 0056                     rx_counter1=0;
	CLR  R13
; 0000 0057                     rx_buffer_overflow1=1;
	SBI  0x1E,1
; 0000 0058                 };
_0xB:
; 0000 0059         };
_0x9:
; 0000 005A }
_0x61:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// USART2 Receiver interrupt service routine
;interrupt [USART2_RXC] void usart2_rx_isr(void)
; 0000 005E {
_usart2_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 005F     char status,data;
; 0000 0060     status=UCSR2A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,208
; 0000 0061     data=UDR2;
	LDS  R16,214
; 0000 0062     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xE
; 0000 0063         {
; 0000 0064             rx_buffer2[rx_wr_index2]=data;
	LDS  R30,_rx_wr_index2
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer2)
	SBCI R31,HIGH(-_rx_buffer2)
	ST   Z,R16
; 0000 0065             if (++rx_wr_index2 == RX_BUFFER_SIZE2) rx_wr_index2=0;
	LDS  R26,_rx_wr_index2
	SUBI R26,-LOW(1)
	STS  _rx_wr_index2,R26
	CPI  R26,LOW(0x32)
	BRNE _0xF
	LDI  R30,LOW(0)
	STS  _rx_wr_index2,R30
; 0000 0066             if (++rx_counter2 == RX_BUFFER_SIZE2)
_0xF:
	LDS  R26,_rx_counter2
	SUBI R26,-LOW(1)
	STS  _rx_counter2,R26
	CPI  R26,LOW(0x32)
	BRNE _0x10
; 0000 0067                 {
; 0000 0068                     rx_counter2=0;
	LDI  R30,LOW(0)
	STS  _rx_counter2,R30
; 0000 0069                     rx_buffer_overflow2=1;
	SBI  0x1E,2
; 0000 006A                 };
_0x10:
; 0000 006B         };
_0xE:
; 0000 006C }
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
; 0000 006F {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0070     milSecCounter++;
	LDI  R26,LOW(_milSecCounter)
	LDI  R27,HIGH(_milSecCounter)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0071 }
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
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0075 {
; 0000 0076     ADMUX=(adc_input & 0x07) | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 0077     if (adc_input & 0x08) ADCSRB |= 0x08;
; 0000 0078     else ADCSRB &= 0xf7;
; 0000 0079     // Delay needed for the stabilization of the ADC input voltage
; 0000 007A     delay_us(10);
; 0000 007B     // Start the AD conversion
; 0000 007C     ADCSRA|=0x40;
; 0000 007D     // Wait for the AD conversion to complete
; 0000 007E     while ((ADCSRA & 0x10)==0);
; 0000 007F     ADCSRA|=0x10;
; 0000 0080     return ADCW;
; 0000 0081 }
;
;// Get a character from the USART Receiver buffer
;char getchar(void)
; 0000 0085 {
_getchar:
; 0000 0086     char data;
; 0000 0087     switch(poutput)
	ST   -Y,R17
;	data -> R17
	LDS  R30,_poutput
	LDI  R31,0
; 0000 0088         {
; 0000 0089             case USART0:
	SBIW R30,0
	BRNE _0x1B
; 0000 008A                 while (rx_counter0==0);
_0x1C:
	TST  R12
	BREQ _0x1C
; 0000 008B                 data=rx_buffer0[rx_rd_index0];
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 008C                 if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	INC  R9
	LDI  R30,LOW(100)
	CP   R30,R9
	BRNE _0x1F
	CLR  R9
; 0000 008D                 #asm("cli")
_0x1F:
	cli
; 0000 008E                 --rx_counter0;
	DEC  R12
; 0000 008F                 #asm("sei")
	sei
; 0000 0090                 return data;
	MOV  R30,R17
	RJMP _0x20A0008
; 0000 0091             break;
; 0000 0092 
; 0000 0093             case USART1:
_0x1B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20
; 0000 0094                 while (rx_counter1==0);
_0x21:
	TST  R13
	BREQ _0x21
; 0000 0095                 data=rx_buffer1[rx_rd_index1];
	MOV  R30,R14
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	LD   R17,Z
; 0000 0096                 if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
	INC  R14
	LDI  R30,LOW(100)
	CP   R30,R14
	BRNE _0x24
	CLR  R14
; 0000 0097                 #asm("cli")
_0x24:
	cli
; 0000 0098                 --rx_counter1;
	DEC  R13
; 0000 0099                 #asm("sei")
	sei
; 0000 009A                 return data;
	MOV  R30,R17
	RJMP _0x20A0008
; 0000 009B             break;
; 0000 009C 
; 0000 009D             case USART2:
_0x20:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1A
; 0000 009E                 while (rx_counter2==0);
_0x26:
	LDS  R30,_rx_counter2
	CPI  R30,0
	BREQ _0x26
; 0000 009F                 data=rx_buffer2[rx_rd_index2];
	LDS  R30,_rx_rd_index2
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer2)
	SBCI R31,HIGH(-_rx_buffer2)
	LD   R17,Z
; 0000 00A0                 if (++rx_rd_index2 == RX_BUFFER_SIZE2) rx_rd_index2=0;
	LDS  R26,_rx_rd_index2
	SUBI R26,-LOW(1)
	STS  _rx_rd_index2,R26
	CPI  R26,LOW(0x32)
	BRNE _0x29
	LDI  R30,LOW(0)
	STS  _rx_rd_index2,R30
; 0000 00A1                 #asm("cli")
_0x29:
	cli
; 0000 00A2                 --rx_counter2;
	LDS  R30,_rx_counter2
	SUBI R30,LOW(1)
	STS  _rx_counter2,R30
; 0000 00A3                 #asm("sei")
	sei
; 0000 00A4                 return data;
	MOV  R30,R17
; 0000 00A5             break;
; 0000 00A6         }
_0x1A:
; 0000 00A7 }
_0x20A0008:
	LD   R17,Y+
	RET
;
;// Write a character to the USART Transmitter
;void putchar(char c)
; 0000 00AB {
_putchar:
; 0000 00AC     switch(poutput)
;	c -> Y+0
	LDS  R30,_poutput
	LDI  R31,0
; 0000 00AD         {
; 0000 00AE             case USART0:
	SBIW R30,0
	BRNE _0x2D
; 0000 00AF                 while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
_0x2E:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2E
; 0000 00B0                 UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 00B1             break;
	RJMP _0x2C
; 0000 00B2 
; 0000 00B3             case USART1:
_0x2D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x31
; 0000 00B4                 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
_0x32:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x32
; 0000 00B5                 UDR1=c;
	LD   R30,Y
	STS  206,R30
; 0000 00B6             break;
	RJMP _0x2C
; 0000 00B7 
; 0000 00B8             case USART2:
_0x31:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C
; 0000 00B9                 while ((UCSR2A & DATA_REGISTER_EMPTY)==0);
_0x36:
	LDS  R30,208
	ANDI R30,LOW(0x20)
	BREQ _0x36
; 0000 00BA                 UDR2=c;
	LD   R30,Y
	STS  214,R30
; 0000 00BB             break;
; 0000 00BC         }
_0x2C:
; 0000 00BD }
	ADIW R28,1
	RET
;
;unsigned int serialAvailable(void)
; 0000 00C0 {
_serialAvailable:
; 0000 00C1     switch(poutput)
	LDS  R30,_poutput
	LDI  R31,0
; 0000 00C2         {
; 0000 00C3             case USART0:
	SBIW R30,0
	BRNE _0x3C
; 0000 00C4                 return rx_counter0;
	MOV  R30,R12
	RJMP _0x20A0007
; 0000 00C5             break;
; 0000 00C6 
; 0000 00C7             case USART1:
_0x3C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3D
; 0000 00C8                 return rx_counter1;
	MOV  R30,R13
	RJMP _0x20A0007
; 0000 00C9             break;
; 0000 00CA 
; 0000 00CB             case USART2:
_0x3D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3B
; 0000 00CC                 return rx_counter2;
	LDS  R30,_rx_counter2
_0x20A0007:
	LDI  R31,0
	RET
; 0000 00CD             break;
; 0000 00CE         }
_0x3B:
; 0000 00CF }
	RET
;
;void get_request_and_send_response(void)
; 0000 00D2 {
_get_request_and_send_response:
; 0000 00D3     unsigned char array_index;
; 0000 00D4     char received_byte;
; 0000 00D5     char serial_command[10];
; 0000 00D6     poutput=USART0;
	SBIW R28,10
	ST   -Y,R17
	ST   -Y,R16
;	array_index -> R17
;	received_byte -> R16
;	serial_command -> Y+2
	LDI  R30,LOW(0)
	STS  _poutput,R30
; 0000 00D7     if (serialAvailable()>5)
	RCALL _serialAvailable
	SBIW R30,6
	BRSH PC+3
	JMP _0x3F
; 0000 00D8         {
; 0000 00D9             received_byte=getchar();
	RCALL _getchar
	MOV  R16,R30
; 0000 00DA             if (received_byte==STX)
	CPI  R16,2
	BREQ PC+3
	JMP _0x40
; 0000 00DB                 {
; 0000 00DC                     array_index=0;
	LDI  R17,LOW(0)
; 0000 00DD                     do
_0x42:
; 0000 00DE                         {
; 0000 00DF                             received_byte=getchar();
	RCALL _getchar
	MOV  R16,R30
; 0000 00E0                             serial_command[array_index]=received_byte;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 00E1                             ++array_index;
	SUBI R17,-LOW(1)
; 0000 00E2                         }
; 0000 00E3                     while (received_byte!=ETX);
	CPI  R16,3
	BRNE _0x42
; 0000 00E4                     if (strstr(serial_command,dev_id_chk)!=NULL)
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_dev_id_chk)
	LDI  R31,HIGH(_dev_id_chk)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0x44
; 0000 00E5                         {
; 0000 00E6                             if (strstr(serial_command,":P")!=NULL)  printf("%c%c%cT%+04.1fH%04.1f3V%03uI%03.1f5V%03uI%03.1fD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,voltage3k,current3k,voltage5k,current5k,dustconcentration,ETX,CR,LF);  // periodic data request
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x46,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0x45
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x31
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
	__GETW1R 5,6
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current3k
	LDS  R31,_current3k+1
	LDS  R22,_current3k+2
	LDS  R23,_current3k+3
	CALL __PUTPARD1
	__GETW1R 7,8
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current5k
	LDS  R31,_current5k+1
	LDS  R22,_current5k+2
	LDS  R23,_current5k+3
	CALL __PUTPARD1
	__GETW1R 3,4
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
	CALL _printf
	ADIW R28,54
; 0000 00E7                             else if (strstr(serial_command,":ON3K")!=NULL)
	RJMP _0x47
_0x45:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x46,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0x48
; 0000 00E8                                 {
; 0000 00E9                                     current3k=1.5;
	__GETD1N 0x3FC00000
	STS  _current3k,R30
	STS  _current3k+1,R31
	STS  _current3k+2,R22
	STS  _current3k+3,R23
; 0000 00EA                                     voltage3k=260;
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	__PUTW1R 5,6
; 0000 00EB                                 }
; 0000 00EC                             else if (strstr(serial_command,":ON5K")!=NULL)
	RJMP _0x49
_0x48:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x46,9
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0x4A
; 0000 00ED                                 {
; 0000 00EE                                     current5k=1.5;
	__GETD1N 0x3FC00000
	STS  _current5k,R30
	STS  _current5k+1,R31
	STS  _current5k+2,R22
	STS  _current5k+3,R23
; 0000 00EF                                     voltage5k=260;
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	__PUTW1R 7,8
; 0000 00F0                                 }
; 0000 00F1                             else if (strstr(serial_command,":OFF3K")!=NULL)
	RJMP _0x4B
_0x4A:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x46,15
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0x4C
; 0000 00F2                                 {
; 0000 00F3                                     current3k=0.0;
	LDI  R30,LOW(0)
	STS  _current3k,R30
	STS  _current3k+1,R30
	STS  _current3k+2,R30
	STS  _current3k+3,R30
; 0000 00F4                                     voltage3k=0;
	CLR  R5
	CLR  R6
; 0000 00F5                                 }
; 0000 00F6                             else if (strstr(serial_command,":OFF5K")!=NULL)
	RJMP _0x4D
_0x4C:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x46,22
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0x4E
; 0000 00F7                                 {
; 0000 00F8                                     current5k=0.0;
	LDI  R30,LOW(0)
	STS  _current5k,R30
	STS  _current5k+1,R30
	STS  _current5k+2,R30
	STS  _current5k+3,R30
; 0000 00F9                                     voltage5k=0;
	CLR  R7
	CLR  R8
; 0000 00FA                                 }
; 0000 00FB                             else if (strstr(serial_command,":TH")!=NULL) printf("%c%c%cT%+04.1fH%04.1f%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,ETX,CR,LF);
	RJMP _0x4F
_0x4E:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x46,29
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0x50
	__POINTW1FN _0x0,92
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x31
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
	CALL _printf
	ADIW R28,34
; 0000 00FC                             else if (strstr(serial_command,":VI")!=NULL) printf("%c%c%c3V%03uI%03.1f5V%03uI%03.1f%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),voltage3k,current3k,voltage5k,current5k,ETX,CR,LF);
	RJMP _0x51
_0x50:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x46,33
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE PC+3
	JMP _0x52
	__POINTW1FN _0x0,124
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x31
	CALL __PUTPARD1
	__GETW1R 5,6
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current3k
	LDS  R31,_current3k+1
	LDS  R22,_current3k+2
	LDS  R23,_current3k+3
	CALL __PUTPARD1
	__GETW1R 7,8
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
	CALL _printf
	ADIW R28,42
; 0000 00FD                             else if (strstr(serial_command,":D")!=NULL) printf("%c%c%cD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),dustconcentration,ETX,CR,LF);
	RJMP _0x53
_0x52:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x46,37
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BREQ _0x54
	__POINTW1FN _0x0,166
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x31
	CALL __PUTPARD1
	__GETW1R 3,4
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
	CALL _printf
	ADIW R28,30
; 0000 00FE                             memset(serial_command,0,sizeof(serial_command));
_0x54:
_0x53:
_0x51:
_0x4F:
_0x4D:
_0x4B:
_0x49:
_0x47:
	RJMP _0x60
; 0000 00FF                         }
; 0000 0100                     else if (strstr(serial_command,dev_id_chk)==NULL)
_0x44:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_dev_id_chk)
	LDI  R31,HIGH(_dev_id_chk)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	SBIW R30,0
	BRNE _0x56
; 0000 0101                         {
; 0000 0102                             memset(serial_command,0,sizeof(serial_command));
_0x60:
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
; 0000 0103                         }
; 0000 0104                 }
_0x56:
; 0000 0105         }
_0x40:
; 0000 0106 }
_0x3F:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET

	.DSEG
_0x46:
	.BYTE 0x28
;
;void mcuInit(void)
; 0000 0109 {

	.CSEG
_mcuInit:
; 0000 010A     // Crystal Oscillator division factor: 1
; 0000 010B     #pragma optsize-
; 0000 010C     CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 010D     CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 010E     #ifdef _OPTIMIZE_SIZE_
; 0000 010F     #pragma optsize+
; 0000 0110     #endif
; 0000 0111 
; 0000 0112     TCCR0A=0x00;
	OUT  0x24,R30
; 0000 0113     TCCR0B=0x03;
	LDI  R30,LOW(3)
	OUT  0x25,R30
; 0000 0114     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0115     OCR0A=0x00;
	OUT  0x27,R30
; 0000 0116     OCR0B=0x00;
	OUT  0x28,R30
; 0000 0117     TIMSK0=0x01;
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0118 
; 0000 0119     // USART0 initialization
; 0000 011A     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 011B     // USART0 Receiver: On
; 0000 011C     // USART0 Transmitter: On
; 0000 011D     // USART0 Mode: Asynchronous
; 0000 011E     // USART0 Baud Rate: 9600
; 0000 011F     UCSR0A=0x00;
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 0120     UCSR0B=0x98;
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 0121     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0122     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 0123     UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 0124 
; 0000 0125     // USART1 initialization
; 0000 0126     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0127     // USART1 Receiver: On
; 0000 0128     // USART1 Transmitter: On
; 0000 0129     // USART1 Mode: Asynchronous
; 0000 012A     // USART1 Baud Rate: 9600
; 0000 012B     UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  200,R30
; 0000 012C     UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  201,R30
; 0000 012D     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  202,R30
; 0000 012E     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  205,R30
; 0000 012F     UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  204,R30
; 0000 0130 
; 0000 0131     // USART2 initialization
; 0000 0132     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0133     // USART2 Receiver: On
; 0000 0134     // USART2 Transmitter: On
; 0000 0135     // USART2 Mode: Asynchronous
; 0000 0136     // USART2 Baud Rate: 9600
; 0000 0137     UCSR2A=0x00;
	LDI  R30,LOW(0)
	STS  208,R30
; 0000 0138     UCSR2B=0x98;
	LDI  R30,LOW(152)
	STS  209,R30
; 0000 0139     UCSR2C=0x06;
	LDI  R30,LOW(6)
	STS  210,R30
; 0000 013A     UBRR2H=0x00;
	LDI  R30,LOW(0)
	STS  213,R30
; 0000 013B     UBRR2L=0x67;
	LDI  R30,LOW(103)
	STS  212,R30
; 0000 013C 
; 0000 013D     // Analog Comparator initialization
; 0000 013E     // Analog Comparator: Off
; 0000 013F     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0140     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0141     ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0142 
; 0000 0143     // ADC initialization
; 0000 0144     // ADC Clock frequency: 1000.000 kHz
; 0000 0145     // ADC Voltage Reference: AVCC pin
; 0000 0146     // ADC Auto Trigger Source: Free Running
; 0000 0147     // Digital input buffers on ADC0: Off, ADC1: Off, ADC2: Off, ADC3: Off
; 0000 0148     // ADC4: On, ADC5: On, ADC6: On, ADC7: On
; 0000 0149     DIDR0=0x0F;
	LDI  R30,LOW(15)
	STS  126,R30
; 0000 014A     // Digital input buffers on ADC8: On, ADC9: On, ADC10: On, ADC11: On
; 0000 014B     // ADC12: On, ADC13: On, ADC14: On, ADC15: On
; 0000 014C     DIDR2=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 014D     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 014E     ADCSRA=0xA4;
	LDI  R30,LOW(164)
	STS  122,R30
; 0000 014F     ADCSRB&=0xF8;
	LDS  R30,123
	ANDI R30,LOW(0xF8)
	STS  123,R30
; 0000 0150 
; 0000 0151     #asm("sei")
	sei
; 0000 0152 }
	RET
;
;void main(void)
; 0000 0155 {
_main:
; 0000 0156     unsigned long timecounter;
; 0000 0157     int randval;
; 0000 0158     mcuInit();
	SBIW R28,4
;	timecounter -> Y+0
;	randval -> R16,R17
	RCALL _mcuInit
; 0000 0159     sprintf(dev_id_chk,"%c%c:",DEV_ID>>8,DEV_ID);
	LDI  R30,LOW(_dev_id_chk)
	LDI  R31,HIGH(_dev_id_chk)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,184
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x3531
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 015A     milSecCounter=0;
	LDI  R30,LOW(0)
	STS  _milSecCounter,R30
	STS  _milSecCounter+1,R30
	STS  _milSecCounter+2,R30
	STS  _milSecCounter+3,R30
; 0000 015B     timecounter=milSecCounter;
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	CALL __PUTD1S0
; 0000 015C     while ((milSecCounter-timecounter)<14999);
_0x57:
	CALL __GETD2S0
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	CALL __SUBD12
	__CPD1N 0x3A97
	BRLO _0x57
; 0000 015D     while (1)
_0x5A:
; 0000 015E         {
; 0000 015F             if ((milSecCounter-timecounter)>=19999)
	CALL __GETD2S0
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	CALL __SUBD12
	__CPD1N 0x4E1F
	BRSH PC+3
	JMP _0x5D
; 0000 0160                 {
; 0000 0161                     randval=rand();
	CALL _rand
	MOVW R16,R30
; 0000 0162                     temperature=((0.6*randval)/32767.0)+6.7; // random from 6.7 to 7.3
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F19999A
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x46FFFE00
	CALL __DIVF21
	__GETD2N 0x40D66666
	CALL __ADDF12
	STS  _temperature,R30
	STS  _temperature+1,R31
	STS  _temperature+2,R22
	STS  _temperature+3,R23
; 0000 0163                     humidity=5.0*randval/32767.0+55.0; //  random from 55 to 60
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x46FFFE00
	CALL __DIVF21
	__GETD2N 0x425C0000
	CALL __ADDF12
	STS  _humidity,R30
	STS  _humidity+1,R31
	STS  _humidity+2,R22
	STS  _humidity+3,R23
; 0000 0164                     dustconcentration=5.0*randval/32767.0+65.0; //  random from 65 to 70
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x46FFFE00
	CALL __DIVF21
	__GETD2N 0x42820000
	CALL __ADDF12
	CALL __CFD1U
	__PUTW1R 3,4
; 0000 0165                     printf("%c%c%cT%+04.1fH%04.1f3V%03uI%03.1f5V%03uI%03.1fD%03u%c%c%c",STX,(char)(DEV_ID>>8),(char)(DEV_ID),temperature,humidity,voltage3k,current3k,voltage5k,current5k,dustconcentration,ETX,CR,LF);
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x35
	CALL __PUTPARD1
	__GETD1N 0x31
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
	__GETW1R 5,6
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current3k
	LDS  R31,_current3k+1
	LDS  R22,_current3k+2
	LDS  R23,_current3k+3
	CALL __PUTPARD1
	__GETW1R 7,8
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_current5k
	LDS  R31,_current5k+1
	LDS  R22,_current5k+2
	LDS  R23,_current5k+3
	CALL __PUTPARD1
	__GETW1R 3,4
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
	CALL _printf
	ADIW R28,54
; 0000 0166                     milSecCounter=0;
	LDI  R30,LOW(0)
	STS  _milSecCounter,R30
	STS  _milSecCounter+1,R30
	STS  _milSecCounter+2,R30
	STS  _milSecCounter+3,R30
; 0000 0167                     timecounter=milSecCounter;
	LDS  R30,_milSecCounter
	LDS  R31,_milSecCounter+1
	LDS  R22,_milSecCounter+2
	LDS  R23,_milSecCounter+3
	CALL __PUTD1S0
; 0000 0168                 }
; 0000 0169             get_request_and_send_response();
_0x5D:
	RCALL _get_request_and_send_response
; 0000 016A         };
	RJMP _0x5A
; 0000 016B }
_0x5E:
	RJMP _0x5E
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
	JMP  _0x20A0004
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
	RJMP _0x20A0006
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
	RJMP _0x20A0006
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
_0x20A0006:
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
	RJMP _0x20A0005
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
_0x20A0005:
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
_0x20A0004:
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
_rand:
	LDS  R30,__seed_G102
	LDS  R31,__seed_G102+1
	LDS  R22,__seed_G102+2
	LDS  R23,__seed_G102+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G102,R30
	STS  __seed_G102+1,R31
	STS  __seed_G102+2,R22
	STS  __seed_G102+3,R23
	movw r30,r22
	andi r31,0x7F
	RET

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
_dev_id_chk:
	.BYTE 0x5
_temperature:
	.BYTE 0x4
_humidity:
	.BYTE 0x4
_current3k:
	.BYTE 0x4
_current5k:
	.BYTE 0x4
_rx_buffer0:
	.BYTE 0x64
_rx_buffer1:
	.BYTE 0x64
_rx_buffer2:
	.BYTE 0x32
_rx_wr_index2:
	.BYTE 0x1
_rx_rd_index2:
	.BYTE 0x1
_rx_counter2:
	.BYTE 0x1
_poutput:
	.BYTE 0x1
_milSecCounter:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG

	.CSEG
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

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
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

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
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

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
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

;END OF CODE MARKER
__END_OF_CODE:
