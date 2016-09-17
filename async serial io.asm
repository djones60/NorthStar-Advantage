;Code copied from Advantage Tech manual Table 3-26 on page 3-65
;With changes to use board in slot 1 (default)
;Table 3-22 on page 3-55 shows first digit of I/O address
; Board slot 1 First digit of I/O = 5
;
;Serial I/O addresses documented in Table 3-24 on page 3-57
;I/O Address Operation Description
; X0 Input/Output USART data
; X1 Input/Output USART Status/Command
; X8 Output Baud rate register
; XA Output Interrupt Mask
;The first digit is determined by the board slot where SIO fitted
;
;Baud rate/16 values in Table 3-25 on page 3-64
;May reduce from 9600 to 4800 for more reliable transfer from DOS PC
; Decimal Hex
;
;	19200	127	7F
;	9600	126	7E
;	4800	124	7C
;	2400	120	78
;	1200	112	70
;	300		64	40
;
PORTA EQU 50H ;Set for SIO boardlet in slot 1
BAUD EQU PORTA+8 ;Set Baud rate for channel
DATA EQU PORTA ;USART data address
CTRL EQU PORTA+1 ;USART control/status.
BDRT EQU 126 ;Set Baud rate to 9600 (or 124 for 4800 Baud)
;
; Input and output routines
;
CINA	IN CTRL ;Check USART status
		ANI 2 ;Get RxReady bit
		JRZ CINA ;Wait till character ready
		IN DATA ;Read character (Presumably DB30 should be DB50)
		ANI 7FH ;Mask off top bit
		RET
;
COUTA	IN CTRL ;Check USART status (Ditto, DB31 should be DB51)
		ANI 1 ;Get TxReady bit
		JRZ COUTA ;Wait till ready
		MTV A,B ;Output char is in B reg
		OUT DATA ;Output character
		RET
;
; SIO Boardlet initialization routine
;
INIT	MVI A,BDRT
		OUT BAUD ;Set baud rate
;
; Interrupt masks are cleared at power up
;
		MVI A,3 ;Give USART conmands
		OUT CTRL ;to reset.
		OUT CTRL
		MVI A,40H ;Page H-12 explain this resets USART
		OUT CTRL
		MVI A,0CEH ;Give mode command 0CEH = %11001110 x16 clock, 0AEH 10101110 for 8N1, x16 clock
		OUT CTRL ;2 STOP BITS, 8-Bit, 16*CLK page H-14
		MVI A,27H ;Give command 027H = %00010111 page H-17
		OUT CTRL ;CMD: RTS,ER,RXF,DTR,TXEN
		CALL INJNK ;Read junk twice
INJNK	IN DATA
		RET
;
END

