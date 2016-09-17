;*************************************************************************
;
;  Based on the Quick binary file loader for the Sol-20 on DeRamp.com
;  	Do a CTRL-C at the Advantage "Load System" prompt to enter
;	Mini-Monitor.  Then enter the following program and start it.
;	Then send the PC2FLOP.COM (8-bit binary) into the Advantage
;	serial port. Finally, reset the computer, entern the monitor and 
;	run PC2FLOP from C100H or what ever address we assembled it.
;
;************************************************************************

PORTA	EQU 50H			;Set for SIO boardlet in slot 1
BAUD	EQU PORTA+8		;Set Baud rate for channel
DATA	EQU PORTA		;USART data address
CTRL	EQU PORTA+1		;USART control/status.
sioRdrf	equ	02h			;mask to test for receive data
BDRT	EQU 126			;Set Baud rate to 9600 
						;	baud	dec hex
						;	19200	127	7F
						;	9600	126	7E
						;	4800	124	7C
						;	2400	120	78
						;	1200	112	70
						;	300		64	40

		org	0C000H		; Advantage boot 16k ram window
		call INIT		; set up the serial port

		lxi	h,0C100H 	; original load at 0100h but for the Advantage needs to be above C000H

loop	in	CTRL		;wait for a character
		ani	sioRdrf	
		jz	loop

		in	DATA		;get the character
		mov	m,a			;store it
		inx	h			;move to next location
		jmp	loop
;
; SIO Boardlet initialization routine
;
INIT	MVI A,BDRT
		OUT BAUD		;Set baud rate
;
; Set up the serial port in slot #1
; Interrupt masks are cleared at power up
;
		MVI A,3			;Give USART conmands
		OUT CTRL		;to reset.
		OUT CTRL
		MVI A,40H		;Page H-12 explain this resets USART
		OUT CTRL
		MVI A,0AEH		;Give mode command 0CEH = %11001110 x16 clock, 0AEH 10101110 for 8N1, x16 clock
		OUT CTRL		;2 STOP BITS, 8-Bit, 16*CLK page H-14
		MVI A,27H		;Give command 027H = %00010111 page H-17
		OUT CTRL		;CMD: RTS,ER,RXF,DTR,TXEN
		CALL INJNK		;Read junk twice
INJNK	IN DATA
		RET
;
end
