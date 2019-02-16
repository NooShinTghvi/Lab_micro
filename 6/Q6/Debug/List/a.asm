
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _negin=R4
	.DEF _negin_msb=R5
	.DEF _x=R6
	.DEF _x_msb=R7
	.DEF _pushed=R8
	.DEF _pushed_msb=R9
	.DEF _count__=R10
	.DEF _count___msb=R11
	.DEF _a=R12
	.DEF _a_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

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
	JMP  _timer0_ovf_isr
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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;#include <stdlib.h>
;#include <stdio.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// Timer 0 overflow interrupt service routine
; unsigned int  negin =0;
; unsigned int x =0;
; int pushed = 0;
; int count__ =0;
; unsigned int a;
; unsigned char c[10];
;interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
; 0000 0012 interrupt [10] void timer0_ovf_isr(void) {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0013     if (pushed >= 1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x3
; 0000 0014         count__ ++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0015     }
; 0000 0016 
; 0000 0017 // Place your code here
; 0000 0018 
; 0000 0019 }
_0x3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (1<<ADLAR))
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char  read_adc(unsigned char adc_input)
; 0000 0021 {
_read_adc:
; .FSTART _read_adc
; 0000 0022 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 0023 // Delay needed for the stabilization of the ADC input voltage
; 0000 0024 delay_us(10);
	__DELAY_USB 27
; 0000 0025 // Start the AD conversion
; 0000 0026 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0027 // Wait for the AD conversion to complete
; 0000 0028 while ((ADCSRA & (1<<ADIF))==0);
_0x4:
	SBIS 0x6,4
	RJMP _0x4
; 0000 0029 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 002A return ADCH;
	IN   R30,0x5
	JMP  _0x20C0001
; 0000 002B }
; .FEND
;
;
;void main(void)
; 0000 002F {
_main:
; .FSTART _main
; 0000 0030 // Declare your local variables here
; 0000 0031 
; 0000 0032 // Input/Output Ports initialization
; 0000 0033 // Port A initialization
; 0000 0034 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0035 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0036 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0037 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0038 
; 0000 0039 // Port B initialization
; 0000 003A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 003B DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 003C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 003D PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 003E 
; 0000 003F // Port C initialization
; 0000 0040 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0041 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0042 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0043 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0044 
; 0000 0045 // Port D initialization
; 0000 0046 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0047 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0048 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0049 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 004A 
; 0000 004B // Timer/Counter 0 initialization
; 0000 004C // Clock source: System Clock
; 0000 004D // Clock value: 31.250 kHz
; 0000 004E // Mode: Normal top=0xFF
; 0000 004F // OC0 output: Disconnected
; 0000 0050 // Timer Period: 8.192 ms
; 0000 0051 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0052 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0053 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0054 
; 0000 0055 // Timer/Counter 1 initialization
; 0000 0056 // Clock source: System Clock
; 0000 0057 // Clock value: Timer1 Stopped
; 0000 0058 // Mode: Normal top=0xFFFF
; 0000 0059 // OC1A output: Disconnected
; 0000 005A // OC1B output: Disconnected
; 0000 005B // Noise Canceler: Off
; 0000 005C // Input Capture on Falling Edge
; 0000 005D // Timer1 Overflow Interrupt: Off
; 0000 005E // Input Capture Interrupt: Off
; 0000 005F // Compare A Match Interrupt: Off
; 0000 0060 // Compare B Match Interrupt: Off
; 0000 0061 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0062 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0063 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0064 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0065 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0066 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0067 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0068 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0069 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 006A OCR1BL=0x00;
	OUT  0x28,R30
; 0000 006B 
; 0000 006C // Timer/Counter 2 initialization
; 0000 006D // Clock source: System Clock
; 0000 006E // Clock value: Timer2 Stopped
; 0000 006F // Mode: Normal top=0xFF
; 0000 0070 // OC2 output: Disconnected
; 0000 0071 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0072 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0073 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0074 OCR2=0x00;
	OUT  0x23,R30
; 0000 0075 
; 0000 0076 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0077 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0078 
; 0000 0079 // External Interrupt(s) initialization
; 0000 007A // INT0: Off
; 0000 007B // INT1: Off
; 0000 007C // INT2: Off
; 0000 007D MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 007E MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 007F 
; 0000 0080 // USART initialization
; 0000 0081 // USART disabled
; 0000 0082 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0083 
; 0000 0084 // Analog Comparator initialization
; 0000 0085 // Analog Comparator: Off
; 0000 0086 // The Analog Comparator's positive input is
; 0000 0087 // connected to the AIN0 pin
; 0000 0088 // The Analog Comparator's negative input is
; 0000 0089 // connected to the AIN1 pin
; 0000 008A ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 008B 
; 0000 008C // ADC initialization
; 0000 008D // ADC Clock frequency: 1000.000 kHz
; 0000 008E // ADC Voltage Reference: AREF pin
; 0000 008F // ADC Auto Trigger Source: ADC Stopped
; 0000 0090 // Only the 8 most significant bits of
; 0000 0091 // the AD conversion result are used
; 0000 0092 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0093 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0094 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0095 
; 0000 0096 // SPI initialization
; 0000 0097 // SPI disabled
; 0000 0098 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0099 
; 0000 009A // TWI initialization
; 0000 009B // TWI disabled
; 0000 009C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 009D 
; 0000 009E // Alphanumeric LCD initialization
; 0000 009F // Connections are specified in the
; 0000 00A0 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00A1 // RS - PORTA Bit 0
; 0000 00A2 // RD - PORTA Bit 1
; 0000 00A3 // EN - PORTA Bit 2
; 0000 00A4 // D4 - PORTA Bit 4
; 0000 00A5 // D5 - PORTA Bit 5
; 0000 00A6 // D6 - PORTA Bit 6
; 0000 00A7 // D7 - PORTA Bit 7
; 0000 00A8 // Characters/line: 8
; 0000 00A9 lcd_init(8);
	LDI  R26,LOW(8)
	CALL _lcd_init
; 0000 00AA 
; 0000 00AB // Global enable interrupts
; 0000 00AC #asm("sei")
	sei
; 0000 00AD 
; 0000 00AE 
; 0000 00AF 
; 0000 00B0 while (1) {
_0x7:
; 0000 00B1 
; 0000 00B2       if (count__ ==12){
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xA
; 0000 00B3             if (pushed >=1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0xB
; 0000 00B4                 x++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00B5                 pushed =0;
	CLR  R8
	CLR  R9
; 0000 00B6             }
; 0000 00B7 
; 0000 00B8             if (!(x%15)){
_0xB:
	MOVW R26,R6
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL __MODW21U
	SBIW R30,0
	BRNE _0xC
; 0000 00B9                 x=0;
	CLR  R6
	CLR  R7
; 0000 00BA                 //lcd_clear();
; 0000 00BB             }
; 0000 00BC             pushed =0;
_0xC:
	CLR  R8
	CLR  R9
; 0000 00BD             negin =0;
	CLR  R4
	CLR  R5
; 0000 00BE             count__ =0;
	CLR  R10
	CLR  R11
; 0000 00BF       }
; 0000 00C0 
; 0000 00C1       lcd_gotoxy(x,0);
_0xA:
	CALL SUBOPT_0x0
; 0000 00C2       //lcd_putchar('h');
; 0000 00C3       a=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	MOV  R12,R30
	CLR  R13
; 0000 00C4       itoa(a,c);
	ST   -Y,R13
	ST   -Y,R12
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	CALL _itoa
; 0000 00C5       if (c[0]=='2' && c[1]=='5' && c[2]=='3'){
	LDS  R26,_c
	CPI  R26,LOW(0x32)
	BRNE _0xE
	__GETB2MN _c,1
	CPI  R26,LOW(0x35)
	BRNE _0xE
	__GETB2MN _c,2
	CPI  R26,LOW(0x33)
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
; 0000 00C6              if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x10
; 0000 00C7                      lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 00C8                     lcd_putchar('1');
	LDI  R26,LOW(49)
	CALL _lcd_putchar
; 0000 00C9                     continue;
	RJMP _0x7
; 0000 00CA 
; 0000 00CB              }
; 0000 00CC              lcd_putchar('A'+negin);
_0x10:
	MOV  R26,R4
	SUBI R26,-LOW(65)
	CALL SUBOPT_0x2
; 0000 00CD              pushed++;
; 0000 00CE              if (pushed %60==59)
	BRNE _0x11
; 0000 00CF                 negin++;
	CALL SUBOPT_0x3
; 0000 00D0              if (negin==3)
_0x11:
	CALL SUBOPT_0x4
	BRNE _0x12
; 0000 00D1                 negin =0;
	CLR  R4
	CLR  R5
; 0000 00D2 
; 0000 00D3       }
_0x12:
; 0000 00D4       else if (   c[0]=='1' && c[1]=='2' && c[2]=='8') {
	RJMP _0x13
_0xD:
	LDS  R26,_c
	CPI  R26,LOW(0x31)
	BRNE _0x15
	__GETB2MN _c,1
	CPI  R26,LOW(0x32)
	BRNE _0x15
	__GETB2MN _c,2
	CPI  R26,LOW(0x38)
	BREQ _0x16
_0x15:
	RJMP _0x14
_0x16:
; 0000 00D5                if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x17
; 0000 00D6                      lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 00D7                     lcd_putchar('2');
	LDI  R26,LOW(50)
	CALL _lcd_putchar
; 0000 00D8                       continue;
	RJMP _0x7
; 0000 00D9 
; 0000 00DA                 }
; 0000 00DB              lcd_putchar('D'+negin);
_0x17:
	MOV  R26,R4
	SUBI R26,-LOW(68)
	CALL SUBOPT_0x2
; 0000 00DC               pushed++;
; 0000 00DD                if (pushed %60==59)
	BRNE _0x18
; 0000 00DE                negin++;
	CALL SUBOPT_0x3
; 0000 00DF               if (negin==3)
_0x18:
	CALL SUBOPT_0x4
	BRNE _0x19
; 0000 00E0                 negin =0;
	CLR  R4
	CLR  R5
; 0000 00E1 
; 0000 00E2              }
_0x19:
; 0000 00E3 
; 0000 00E4       else if (   c[0]=='8' && c[1]=='1'){
	RJMP _0x1A
_0x14:
	LDS  R26,_c
	CPI  R26,LOW(0x38)
	BRNE _0x1C
	__GETB2MN _c,1
	CPI  R26,LOW(0x31)
	BREQ _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
; 0000 00E5              if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x1E
; 0000 00E6                     lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 00E7                     lcd_putchar('3');
	LDI  R26,LOW(51)
	CALL _lcd_putchar
; 0000 00E8                     continue;
	RJMP _0x7
; 0000 00E9              }
; 0000 00EA              lcd_putchar('G'+negin);
_0x1E:
	MOV  R26,R4
	SUBI R26,-LOW(71)
	CALL SUBOPT_0x2
; 0000 00EB               pushed++;
; 0000 00EC                if (pushed %60==59)
	BRNE _0x1F
; 0000 00ED                negin++;
	CALL SUBOPT_0x3
; 0000 00EE               if (negin==3)
_0x1F:
	CALL SUBOPT_0x4
	BRNE _0x20
; 0000 00EF                 negin =0;
	CLR  R4
	CLR  R5
; 0000 00F0 
; 0000 00F1       }
_0x20:
; 0000 00F2       else if (   c[0]=='2' && c[1]=='0' && c[2]=='3'){
	RJMP _0x21
_0x1B:
	LDS  R26,_c
	CPI  R26,LOW(0x32)
	BRNE _0x23
	__GETB2MN _c,1
	CPI  R26,LOW(0x30)
	BRNE _0x23
	__GETB2MN _c,2
	CPI  R26,LOW(0x33)
	BREQ _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 00F3                if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x25
; 0000 00F4                      lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 00F5                     lcd_putchar('4');
	LDI  R26,LOW(52)
	CALL _lcd_putchar
; 0000 00F6                     continue;
	RJMP _0x7
; 0000 00F7 
; 0000 00F8                 }
; 0000 00F9              lcd_putchar('J'+negin);
_0x25:
	MOV  R26,R4
	SUBI R26,-LOW(74)
	CALL SUBOPT_0x2
; 0000 00FA                pushed++;
; 0000 00FB                 if (pushed%60==59)
	BRNE _0x26
; 0000 00FC                 negin++;
	CALL SUBOPT_0x3
; 0000 00FD               if (negin==3)
_0x26:
	CALL SUBOPT_0x4
	BRNE _0x27
; 0000 00FE                 negin =0;
	CLR  R4
	CLR  R5
; 0000 00FF 
; 0000 0100       }
_0x27:
; 0000 0101       else if (   c[0]=='1' && c[1]=='1' && c[2]=='4'){
	RJMP _0x28
_0x22:
	LDS  R26,_c
	CPI  R26,LOW(0x31)
	BRNE _0x2A
	__GETB2MN _c,1
	CPI  R26,LOW(0x31)
	BRNE _0x2A
	__GETB2MN _c,2
	CPI  R26,LOW(0x34)
	BREQ _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
; 0000 0102              if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x2C
; 0000 0103                      lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 0104                     lcd_putchar('5');
	LDI  R26,LOW(53)
	CALL _lcd_putchar
; 0000 0105                       continue;
	RJMP _0x7
; 0000 0106 
; 0000 0107                 }
; 0000 0108              lcd_putchar('M'+negin);
_0x2C:
	MOV  R26,R4
	SUBI R26,-LOW(77)
	CALL SUBOPT_0x2
; 0000 0109               pushed++;
; 0000 010A                if (pushed %60==59)
	BRNE _0x2D
; 0000 010B                negin++;
	CALL SUBOPT_0x3
; 0000 010C               if (negin==3)
_0x2D:
	CALL SUBOPT_0x4
	BRNE _0x2E
; 0000 010D                 negin =0;
	CLR  R4
	CLR  R5
; 0000 010E 
; 0000 010F       }
_0x2E:
; 0000 0110       else if (   c[0]=='7' && c[1]=='5') {
	RJMP _0x2F
_0x29:
	LDS  R26,_c
	CPI  R26,LOW(0x37)
	BRNE _0x31
	__GETB2MN _c,1
	CPI  R26,LOW(0x35)
	BREQ _0x32
_0x31:
	RJMP _0x30
_0x32:
; 0000 0111             if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x33
; 0000 0112                      lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 0113                     lcd_putchar('6');
	LDI  R26,LOW(54)
	CALL _lcd_putchar
; 0000 0114                     continue;
	RJMP _0x7
; 0000 0115 
; 0000 0116                 }
; 0000 0117              lcd_putchar('P'+negin);
_0x33:
	MOV  R26,R4
	SUBI R26,-LOW(80)
	CALL SUBOPT_0x2
; 0000 0118               pushed++;
; 0000 0119                if (pushed %60==59)
	BRNE _0x34
; 0000 011A                negin++;
	CALL SUBOPT_0x3
; 0000 011B               if (negin==3)
_0x34:
	CALL SUBOPT_0x4
	BRNE _0x35
; 0000 011C                 negin =0;
	CLR  R4
	CLR  R5
; 0000 011D 
; 0000 011E       }
_0x35:
; 0000 011F       else if (   c[0]=='1' && c[1]=='4' && c[2]=='5'){
	RJMP _0x36
_0x30:
	LDS  R26,_c
	CPI  R26,LOW(0x31)
	BRNE _0x38
	__GETB2MN _c,1
	CPI  R26,LOW(0x34)
	BRNE _0x38
	__GETB2MN _c,2
	CPI  R26,LOW(0x35)
	BREQ _0x39
_0x38:
	RJMP _0x37
_0x39:
; 0000 0120              if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x3A
; 0000 0121                      lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 0122                     lcd_putchar('7');
	LDI  R26,LOW(55)
	CALL _lcd_putchar
; 0000 0123                     continue;
	RJMP _0x7
; 0000 0124 
; 0000 0125              }
; 0000 0126              lcd_putchar('S'+negin);
_0x3A:
	MOV  R26,R4
	SUBI R26,-LOW(83)
	CALL SUBOPT_0x2
; 0000 0127               pushed++;
; 0000 0128                if (pushed %60==59)
	BRNE _0x3B
; 0000 0129                  negin++;
	CALL SUBOPT_0x3
; 0000 012A               if (negin==3)
_0x3B:
	CALL SUBOPT_0x4
	BRNE _0x3C
; 0000 012B                 negin =0;
	CLR  R4
	CLR  R5
; 0000 012C       }
_0x3C:
; 0000 012D       else if (   c[0]=='9' && c[1]=='3'){
	RJMP _0x3D
_0x37:
	LDS  R26,_c
	CPI  R26,LOW(0x39)
	BRNE _0x3F
	__GETB2MN _c,1
	CPI  R26,LOW(0x33)
	BREQ _0x40
_0x3F:
	RJMP _0x3E
_0x40:
; 0000 012E              if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x41
; 0000 012F                      lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 0130                     lcd_putchar('8');
	LDI  R26,LOW(56)
	CALL _lcd_putchar
; 0000 0131                       continue;
	RJMP _0x7
; 0000 0132                 }
; 0000 0133              lcd_putchar('T'+negin);
_0x41:
	MOV  R26,R4
	SUBI R26,-LOW(84)
	CALL SUBOPT_0x2
; 0000 0134               pushed++;
; 0000 0135                if (pushed %60==59)
	BRNE _0x42
; 0000 0136                negin++;
	CALL SUBOPT_0x3
; 0000 0137               if (negin==3)
_0x42:
	CALL SUBOPT_0x4
	BRNE _0x43
; 0000 0138                 negin =0;
	CLR  R4
	CLR  R5
; 0000 0139 
; 0000 013A       }
_0x43:
; 0000 013B       else if (   c[0]=='6' && c[1]=='5'){
	RJMP _0x44
_0x3E:
	LDS  R26,_c
	CPI  R26,LOW(0x36)
	BRNE _0x46
	__GETB2MN _c,1
	CPI  R26,LOW(0x35)
	BREQ _0x47
_0x46:
	RJMP _0x45
_0x47:
; 0000 013C               if (pushed>=900){
	CALL SUBOPT_0x1
	BRLT _0x48
; 0000 013D                      lcd_gotoxy(x,0);
	CALL SUBOPT_0x0
; 0000 013E                     lcd_putchar('9');
	LDI  R26,LOW(57)
	CALL _lcd_putchar
; 0000 013F                       continue;
	RJMP _0x7
; 0000 0140                 }
; 0000 0141              lcd_putchar('W'+negin);
_0x48:
	MOV  R26,R4
	SUBI R26,-LOW(87)
	CALL SUBOPT_0x2
; 0000 0142               pushed++;
; 0000 0143                if (pushed %60==59)
	BRNE _0x49
; 0000 0144                  negin++;
	CALL SUBOPT_0x3
; 0000 0145               if (negin==3)
_0x49:
	CALL SUBOPT_0x4
	BRNE _0x4A
; 0000 0146                 negin =0;
	CLR  R4
	CLR  R5
; 0000 0147 
; 0000 0148       }
_0x4A:
; 0000 0149       else if (   c[0]=='2' && c[1]=='4' && c[2]=='1'){
	RJMP _0x4B
_0x45:
	LDS  R26,_c
	CPI  R26,LOW(0x32)
	BRNE _0x4D
	__GETB2MN _c,1
	CPI  R26,LOW(0x34)
	BRNE _0x4D
	__GETB2MN _c,2
	CPI  R26,LOW(0x31)
	BREQ _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 014A              lcd_putchar('Y'+negin);
	MOV  R26,R4
	SUBI R26,-LOW(89)
	CALL SUBOPT_0x2
; 0000 014B               pushed++;
; 0000 014C                if (pushed %60==59)
	BRNE _0x4F
; 0000 014D                  negin++;
	CALL SUBOPT_0x3
; 0000 014E               if (negin==2)
_0x4F:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x50
; 0000 014F                 negin =0;
	CLR  R4
	CLR  R5
; 0000 0150       }
_0x50:
; 0000 0151       else if (   c[0]=='1' && c[1]=='2' && c[2]=='5'){
	RJMP _0x51
_0x4C:
	LDS  R26,_c
	CPI  R26,LOW(0x31)
	BRNE _0x53
	__GETB2MN _c,1
	CPI  R26,LOW(0x32)
	BRNE _0x53
	__GETB2MN _c,2
	CPI  R26,LOW(0x35)
	BREQ _0x54
_0x53:
	RJMP _0x52
_0x54:
; 0000 0152              lcd_putchar('0');
	LDI  R26,LOW(48)
	RJMP _0x5A
; 0000 0153               pushed=1;
; 0000 0154 
; 0000 0155       }
; 0000 0156       else if (   c[0]=='7' && c[1]=='9'){
_0x52:
	LDS  R26,_c
	CPI  R26,LOW(0x37)
	BRNE _0x57
	__GETB2MN _c,1
	CPI  R26,LOW(0x39)
	BREQ _0x58
_0x57:
	RJMP _0x56
_0x58:
; 0000 0157              lcd_putchar('#');
	LDI  R26,LOW(35)
_0x5A:
	CALL _lcd_putchar
; 0000 0158               pushed=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 0159       }
; 0000 015A 
; 0000 015B 
; 0000 015C //      lcd_putchar(c[2]);
; 0000 015D //      lcd_gotoxy(1,0);
; 0000 015E //      lcd_putchar(c[1]);
; 0000 015F //       lcd_gotoxy(2,0);
; 0000 0160 //        lcd_putchar(c[0]);
; 0000 0161      // delay_ms(50);
; 0000 0162      // lcd_clear();
; 0000 0163       // Place your code here
; 0000 0164 
; 0000 0165       }
_0x56:
_0x51:
_0x4B:
_0x44:
_0x3D:
_0x36:
_0x2F:
_0x28:
_0x21:
_0x1A:
_0x13:
	RJMP _0x7
; 0000 0166 }
_0x59:
	RJMP _0x59
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x20C0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x5
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x5
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040004
_0x2040005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x20C0001
_0x2040004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_c:
	.BYTE 0xA
__seed_G100:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	ST   -Y,R6
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:96 WORDS
SUBOPT_0x2:
	CALL _lcd_putchar
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	MOVW R26,R8
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

;END OF CODE MARKER
__END_OF_CODE:
