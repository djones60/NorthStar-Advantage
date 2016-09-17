; Disassembly of the file "C:\download\Old Computers\Z80\Advantage Boot Rom.BIN"
; 
; CPU Type: Z80
; 
; Created with dZ80 2.0
; 
; on Sunday, 04 of September 2016 at 12:48 AM
; 
; toward the end of the listing is screen character mapping and not code.
; need to figure out where that starts.
; also need to figure out the keyboard in, screen out, monitor, disk load, serial load routines.
;

; save registers and set up the stack.
0000 311700    ld      sp,0017h
0003 f5        push    af
0004 c5        push    bc
0005 d5        push    de
0006 e5        push    hl
0007 d9        exx     
0008 08        ex      af,af'
0009 f5        push    af
000a c5        push    bc
000b d5        push    de
000c e5        push    hl
000d dde5      push    ix
000f fde5      push    iy
0011 ed57      ld      a,i
0013 f5        push    af
0014 fd210000  ld      iy,0000h
0018 fd39      add     iy,sp
001a 3efc      ld      a,0fch			; boot rom to third 16k memory bank, i.e. 8000H ???
001c d3a2      out     (0a2h),a			; memory map register 2 ( they go from a0 to a3 )
001e c32180    jp      8021h
0021 f3        di      
0022 3e28      ld      a,28h			; 
0024 d3f8      out     (0f8h),a			; send a to shared register FxH
0026 af        xor     a
0027 e3        ex      (sp),hl
0028 10fd      djnz    0027h            ; (-03h)
002a 3d        dec     a
002b 20fa      jr      nz,0027h         ; (-06h)
002d 01a00f    ld      bc,0fa0h
0030 3e3f      ld      a,3fh			; 
0032 d3f8      out     (0f8h),a			; send a to shared register FxH
0034 dbe0      in      a,(0e0h)
0036 e608      and     08h
0038 20e8      jr      nz,0022h         ; (-18h)
003a 0b        dec     bc
003b 78        ld      a,b
003c b1        or      c
003d 20f5      jr      nz,0034h         ; (-0bh)
003f d3c0      out     (0c0h),a
0041 1828      jr      006bh            ; (+28h)	jump to to printing "LOAD SYSTEM"
; line below is a literal not code -> "LOAD SYSTEM"
0043 4c        ld      c,h				; L
0044 4f        ld      c,a				; O
0045 41        ld      b,c				; A
0046 44        ld      b,h				; D
0047 2053      jr      nz,009ch         ; (+53h) "space" S
0049 59        ld      e,c				; Y
004a 53        ld      d,e				; S
004b 54        ld      d,h				; T
004c 45        ld      b,l				; E
004d 4d        ld      c,l				; M
004e 1f        rra     					; home cursor
004f 80        add     a,b				; serial boot start char?

0050 80        add     a,b
0051 40        ld      b,b
0052 0c        inc     c
0053 1016      djnz    006bh            ; (+16h)
0055 b7        or      a
0056 1016      djnz    006eh            ; (+16h)
0058 05        dec     b
0059 ff        rst     38h
005a 1016      djnz    0072h            ; (+16h)
005c 04        inc     b
005d 0105ff    ld      bc,0ff05h
0060 00        nop     
0061 00        nop     
0062 00        nop     
0063 00        nop     
0064 00        nop     
0065 00        nop     
0066 00        nop     
0067 00        nop     
0068 00        nop     
0069 1898      jr      0003h            ; (-68h)
; this address gets loaded into hl and pushed on the stack after printing the "LOAD SYSTEM"
006b 3ef8      ld      a,0f8h			; sets up first video 16k ram to 0000H
006d d3a0      out     (0a0h),a
006f 3c        inc     a				; sets second video 16k ram to 0400H
0070 d3a1      out     (0a1h),a
0072 310002    ld      sp,0200h
0075 cdbd82    call    82bdh
0078 d3a3      out     (0a3h),a			; set 16k main ram to the last bank
007a d390      out     (90h),a
007c d3b0      out     (0b0h),a
007e 3e18      ld      a,18h
0080 d3f8      out     (0f8h),a
0082 db73      in      a,(73h)
0084 e6f8      and     0f8h
0086 d6e8      sub     0e8h
0088 32fd02    ld      (02fdh),a
008b 2011      jr      nz,009eh         ; (+11h)
008d 3e7e      ld      a,7eh
008f cd7482    call    8274h
0092 3ece      ld      a,0ceh
0094 d331      out     (31h),a
0096 3e37      ld      a,37h
0098 d331      out     (31h),a
009a db30      in      a,(30h)
009c db30      in      a,(30h)
009e 214380    ld      hl,8043h			; load hl with the address for "LOAD SYSTEM" above
00a1 0e0c      ld      c,0ch			; load c with the number of characters
00a3 46        ld      b,(hl)			; load b with the first character
00a4 cd6c83    call    DispChar			; display the char in b
00a7 23        inc     hl
00a8 0d        dec     c
00a9 20f8      jr      nz,00a3h         ; (-08h)	loop until c counts down to zero
00ab 216b80    ld      hl,806bh
00ae e5        push    hl
00af db83      in      a,(83h)			; make a standard 'beep' sound
00b1 cd2583    call    GetChar			; get keyboard char address GetChar
00b4 fe44      cp      44h				; check for a 'D'
00b6 280b      jr      z,00c3h          ; (+0bh)
00b8 fe53      cp      53h				; check for a 'S'
00ba cae381    jp      z,81e3h			; jump to serial boot
00bd d60d      sub     0dh
00bf c0        ret     nz

00c0 3c        inc     a
00c1 1819      jr      00dch            ; (+19h)
; check for a '1' for disk 1
00c3 cd2583    call    GetChar			; get keyboard char address GetChar
00c6 fe31      cp      31h				; check for a 1
00c8 d8        ret     c

00c9 fe35      cp      35h				; ascii '5' - hard disk boot? or check for disk < 5?
00cb d0        ret     nc
; convevt driver letter to binary and check for a return
00cc d630      sub     30h				; convert drive number to binary
00ce 47        ld      b,a
00cf af        xor     a
00d0 37        scf     
00d1 17        rla     
00d2 10fd      djnz    00d1h            ; (-03h)
00d4 57        ld      d,a
00d5 cd2583    call    GetChar
00d8 fe0d      cp      0dh				; check for a return
00da c0        ret     nz				; return to "load system" if we don't get it
; start booting from floppy
00db 7a        ld      a,d
00dc d9        exx     
00dd 4f        ld      c,a
00de d9        exx     
00df 3e1d      ld      a,1dh
00e1 d3f8      out     (0f8h),a
00e3 3e02      ld      a,02h
00e5 d360      out     (60h),a
00e7 060a      ld      b,0ah
00e9 3ea0      ld      a,0a0h
00eb cd8f81    call    818fh
00ee dbe0      in      a,(0e0h)
00f0 e620      and     20h
00f2 2803      jr      z,00f7h          ; (+03h)
00f4 10f3      djnz    00e9h            ; (-0dh)
00f6 c9        ret     

00f7 0664      ld      b,64h
00f9 3e80      ld      a,80h
00fb cd8f81    call    818fh
00fe dbe0      in      a,(0e0h)
0100 e620      and     20h
0102 2003      jr      nz,0107h         ; (+03h)
0104 10f3      djnz    00f9h            ; (-0dh)
0106 c9        ret     

0107 0604      ld      b,04h
0109 d382      out     (82h),a
010b 3e7d      ld      a,7dh
010d cd9e81    call    819eh
0110 db82      in      a,(82h)
0112 3e7d      ld      a,7dh
0114 cd9e81    call    819eh
0117 10f0      djnz    0109h            ; (-10h)
0119 d9        exx     
011a 0628      ld      b,28h
011c d9        exx     
011d 214e81    ld      hl,814eh
0120 db82      in      a,(82h)
0122 d9        exx     
0123 05        dec     b
0124 d9        exx     
0125 c8        ret     z

0126 0620      ld      b,20h
0128 0b        dec     bc
0129 78        ld      a,b
012a b1        or      c
012b c8        ret     z

012c dbe0      in      a,(0e0h)
012e e640      and     40h
0130 28f6      jr      z,0128h          ; (-0ah)
0132 0620      ld      b,20h
0134 0b        dec     bc
0135 78        ld      a,b
0136 b1        or      c
0137 c8        ret     z

0138 dbe0      in      a,(0e0h)
013a e640      and     40h
013c 20f6      jr      nz,0134h         ; (-0ah)
013e dbd0      in      a,(0d0h)
0140 e60f      and     0fh
0142 fe03      cp      03h				; ascii ctrl-'c' 
0144 20e2      jr      nz,0128h         ; (-1eh)
0146 3e04      ld      a,04h
0148 1e00      ld      e,00h
014a 06ff      ld      b,0ffh
014c 1859      jr      01a7h            ; (+59h)
; start of Floppy data CRC Routine from adv tech manual page 3-81
014e db80      in      a,(80h)			;GET BYTE					READL IN RDATA
0150 fec0      cp      0c0h
0152 d8        ret     c

0153 fef9      cp      0f9h
0155 d0        ret     nc

0156 57        ld      d,a				;MSB OF STORE ADDRESS
0157 12        ld      (de),a			;STORE IT ALSO
0158 13        inc     de
0159 07        rlca    
015a 4f        ld      c,a				;START OF CRC VALUE
015b 216581    ld      hl,8165h			;SET NEW RETURN ADDRESS		LXI H,BLOOP
015e db80      in      a,(80h)			;GET SECOND BYTE
0160 12        ld      (de),a
0161 13        inc     de
0162 a9        xor     c
0163 07        rlca    					;CRC CALC
0164 4f        ld      c,a
0165 db80      in      a,(80h)			;READ DATA LOOP				BLOOP IN RDATA
0167 12        ld      (de),a
0168 a9        xor     c				;FORM CRC
0169 07        rlca    
016a 4f        ld      c,a
016b 13        inc     de				;UPDATE STORE ADDRESS
016c db80      in      a,(80h)			;SECOND BYTE
016e 12        ld      (de),a
016f a9        xor     c
0170 07        rlca    
0171 4f        ld      c,a
0172 13        inc     de
0173 10f0      djnz    0165h            ; (-10h)					DJNZ BLOOP
										;HAVE COMPLETED A BLOC, GET CRC
0175 db80      in      a,(80h)			;CRC BYTE
0177 a9        xor     c				;SEE IF IT MATCHES COMPUTE]
0178 db82      in      a,(82h)			;CLEAR READ ENABLE
										;IF NOT, GO READ AGAIN
017a 20a1      jr      nz,011dh         ; (-5fh)
; end of Floppy data CRC Routine
017c 08        ex      af,af'
017d 3d        dec     a
017e 2027      jr      nz,01a7h         ; (+27h)
0180 210af8    ld      hl,0f80ah
0183 19        add     hl,de
0184 d3a0      out     (0a0h),a
0186 d3a1      out     (0a1h),a
0188 7e        ld      a,(hl)
0189 fec3      cp      0c3h
018b c26b80    jp      nz,806bh
018e e9        jp      (hl)
018f d9        exx     
0190 b1        or      c
0191 d9        exx     
0192 d381      out     (81h),a
0194 f610      or      10h
0196 d381      out     (81h),a
0198 ee10      xor     10h
019a d381      out     (81h),a
019c 3e28      ld      a,28h
019e 0efa      ld      c,0fah
01a0 0d        dec     c
01a1 20fd      jr      nz,01a0h         ; (-03h)
01a3 3d        dec     a
01a4 20f8      jr      nz,019eh         ; (-08h)
01a6 c9        ret     

01a7 08        ex      af,af'
01a8 dbe0      in      a,(0e0h)
01aa e640      and     40h
01ac 20fa      jr      nz,01a8h         ; (-06h)
01ae dbe0      in      a,(0e0h)
01b0 e640      and     40h
01b2 28fa      jr      z,01aeh          ; (-06h)
01b4 3e64      ld      a,64h
01b6 3d        dec     a
01b7 20fd      jr      nz,01b6h         ; (-03h)
01b9 3e15      ld      a,15h
01bb d3f8      out     (0f8h),a
01bd d382      out     (82h),a
01bf 3e18      ld      a,18h
01c1 3d        dec     a
01c2 20fd      jr      nz,01c1h         ; (-03h)
01c4 3e1d      ld      a,1dh
01c6 d3f8      out     (0f8h),a
01c8 78        ld      a,b
01c9 01e064    ld      bc,64e0h
01cc ed70      in      f,(c)
01ce fad681    jp      m,81d6h
01d1 10f9      djnz    01cch            ; (-07h)
01d3 c31d81    jp      811dh
01d6 47        ld      b,a
01d7 db81      in      a,(81h)
01d9 fefb      cp      0fbh
01db c21d81    jp      nz,811dh
01de db80      in      a,(80h)
01e0 0e00      ld      c,00h
01e2 e9        jp      (hl)
; Check and see if there is a serial card in slot 3
01e3 db73      in      a,(73h)
01e5 e6f8      and     0f8h
01e7 fef0      cp      0f0h
01e9 c0        ret     nz
; check for a return keypress
01ea cd2583    call    GetChar
01ed fe0d      cp      0dh				; check for a return
01ef c0        ret     nz
; start serial boot?
01f0 3e00      ld      a,00h
01f2 cd7482    call    8274h			; init serial port?
01f5 0604      ld      b,04h
01f7 50        ld      d,b
01f8 edb3      otir    
01fa db30      in      a,(30h)			; read serial data - clear junk
01fc db30      in      a,(30h)			; read serial data - clear junk
01fe cd8283    call    8382h			; send data in reg b - EOT
0201 48        ld      c,b
0202 0b        dec     bc
0203 78        ld      a,b
0204 b1        or      c
0205 2004      jr      nz,020bh         ; (+04h)
0207 7a        ld      a,d
0208 fe03      cp      03h				; look for ETX Charater
020a d0        ret     nc				; didn't find it so return to "load system"?

020b db31      in      a,(31h)			; check serial status
020d e602      and     02h
020f 28f1      jr      z,0202h          ; (-0fh)
0211 db30      in      a,(30h)			; input serial byte
0213 be        cp      (hl)
0214 20ec      jr      nz,0202h         ; (-14h)
0216 23        inc     hl
0217 15        dec     d
0218 20e8      jr      nz,0202h         ; (-18h)
021a 42        ld      b,d
021b 10fe      djnz    021bh            ; (-02h)
021d 15        dec     d
021e 20fb      jr      nz,021bh         ; (-05h)
0220 0e06      ld      c,06h
0222 46        ld      b,(hl)
0223 cd8283    call    8382h			; send byte in reg b
0226 23        inc     hl
0227 0d        dec     c
0228 20f8      jr      nz,0222h         ; (-08h)
022a cd6b82    call    826bh			; get a serial byte
022d fe02      cp      02h				; check for STX character?
022f 20f9      jr      nz,022ah         ; (-07h)
0231 cd6b82    call    826bh			; get a serial byte
0234 57        ld      d,a
0235 1e00      ld      e,00h
0237 43        ld      b,e
0238 dd210a00  ld      ix,000ah
023c dd19      add     ix,de
023e 210100    ld      hl,0001h
0241 12        ld      (de),a
0242 13        inc     de
0243 4f        ld      c,a
0244 09        add     hl,bc
0245 cd6b82    call    826bh			; get a serial byte
0248 fe10      cp      10h				; check for a DLE
024a 20f5      jr      nz,0241h         ; (-0bh)
024c cd6b82    call    826bh			; get serial byte
024f fe16      cp      16h				; check for SYN character
0251 28f2      jr      z,0245h          ; (-0eh)
0253 fe03      cp      03h				; check for a ETX character
0255 20ea      jr      nz,0241h         ; (-16h)
0257 cd6b82    call    826bh			; get serial byte
025a bd        cp      l
025b c0        ret     nz

025c cd6b82    call    826bh			; get serial bype
025f bc        cp      h
0260 c0        ret     nz
; end of serial boot, set memory pages 0 and 1 to regular memory and call loaded program
0261 cd6b82    call    826bh
0264 af        xor     a
0265 d3a0      out     (0a0h),a			; set memory page 0 and 1 to regular memory
0267 d3a1      out     (0a1h),a
0269 dde9      jp      (ix)				; boot loaded program?
; get serial byte routine
026b db31      in      a,(31h)			; check serial status
026d e602      and     02h
026f 28fa      jr      z,026bh          ; (-06h)
0271 db30      in      a,(30h)			; get serial byte
0273 c9        ret     
; init serial port?
0274 214f80    ld      hl,804fh
0277 013103    ld      bc,0331h
027a edb3      otir    
027c 10fe      djnz    027ch            ; (-02h) 
027e d338      out     (38h),a			; set buad rate
0280 c9        ret     
; mini monitor 'R' routine - return to calling program after it uses the mini monitor?
0281 3afd02    ld      a,(02fdh)
0284 b7        or      a
0285 c0        ret     nz
; start of mini monitor ?
0286 18a2      jr      022ah            ; (-5eh)
0288 062a      ld      b,2ah			; display a '*' prompt
028a cd6c83    call    DispChar
028d cd2583    call    GetChar
0290 fe44      cp      44h				; check for a 'D'
0292 284f      jr      z,02e3h          ; (+4fh)
0294 fe4a      cp      4ah				; check for a 'J'
0296 cacb83    jp      z,83cbh			; jump to the monitor jump routine
0299 fe49      cp      49h				; check for a 'I' ?
029b 287e      jr      z,031bh          ; (+7eh)
029d fe4f      cp      4fh				; check for a 'O'?
029f 2873      jr      z,0314h          ; (+73h)
02a1 fe51      cp      51h				; check for a 'Q'?
02a3 ca6b80    jp      z,806bh			; jump to the code that sets up the memory pages after displaying "Load System"
02a6 fe52      cp      52h				; checl for a 'R'?
02a8 cc8182    call    z,8281h
; the 'I', 'O', 'D' command jumps to here with the input result and when done
02ab 310002    ld      sp,0200h
02ae cdb382    call    82b3h
02b1 18d5      jr      0288h            ; (-2bh)
02b3 3af100    ld      a,(00f1h)
02b6 fee6      cp      0e6h
02b8 061f      ld      b,1fh
02ba c26c83    jp      nz,DispChar
; some sub routine that gets called before setting memory back A3
02bd d9        exx     
02be af        xor     a
02bf 264f      ld      h,4fh
02c1 2ef0      ld      l,0f0h
02c3 2d        dec     l
02c4 77        ld      (hl),a
02c5 20fc      jr      nz,02c3h         ; (-04h)
02c7 25        dec     h
02c8 20f7      jr      nz,02c1h         ; (-09h)
02ca 77        ld      (hl),a
02cb 2d        dec     l
02cc 20fc      jr      nz,02cah         ; (-04h)
02ce 216185    ld      hl,8561h
02d1 22f200    ld      (00f2h),hl
02d4 21f002    ld      hl,02f0h
02d7 22f800    ld      (00f8h),hl
02da 01ff0a    ld      bc,0affh
02dd 71        ld      (hl),c
02de 2c        inc     l
02df 10fc      djnz    02ddh            ; (-04h)
02e1 d9        exx     
02e2 c9        ret     
; mini monitor data input command 'D'
02e3 cd9183    call    8391h			; get address in bc from keyboard - ascii to binary
02e6 ed43fe02  ld      (02feh),bc		; save it to video memory that is off screen?
02ea 2afe02    ld      hl,(02feh)
02ed 46        ld      b,(hl)
02ee 23        inc     hl
02ef 22fe02    ld      (02feh),hl
02f2 cdd383    call    83d3h			; display binary in bc after converting it to ascii
02f5 062d      ld      b,2dh			; display a '-' 
02f7 cd6c83    call    DispChar
02fa cd2583    call    GetChar
02fd fe20      cp      20h				; check for a space
02ff 2005      jr      nz,0306h         ; (+05h)
0301 cd6c83    call    DispChar			; display the space gotten above
0304 18e4      jr      02eah            ; (-1ch) loop to the next address
0306 fe0d      cp      0dh				; check for a return
0308 28a1      jr      z,02abh          ; (-5fh)
030a cd9f83    call    839fh			; otherwise we've entered data so convert it and get the rest to store
030d 2afe02    ld      hl,(02feh)		
0310 2b        dec     hl
0311 71        ld      (hl),c
0312 18d6      jr      02eah            ; (-2ah) loop back and look for another space, return, or data
; mini monitor 'O' io output routine
0314 cd9183    call    8391h			; get the port in c and value in b
0317 ed41      out     (c),b
0319 1890      jr      02abh            ; (-70h)
; mini monitor 'I' port input routine
031b cd9c83    call    839ch			; get 8bit binary from keyboard in bc
031e ed40      in      b,(c)			; imput from io port
0320 cdd383    call    83d3h			; 
0323 1886      jr      02abh            ; (-7ah) go back to the monitor
GetChar 3afd02    ld      a,(02fdh)		; 8325h or 0325h in this disassembly
0328 b7        or      a
0329 2861      jr      z,038ch          ; (+61h)
032b dbd0      in      a,(0d0h)
032d cb77      bit     6,a
032f 28fa      jr      z,032bh          ; (-06h)
0331 47        ld      b,a
0332 3e19      ld      a,19h
0334 d3f8      out     (0f8h),a
0336 dbd0      in      a,(0d0h)
0338 a8        xor     b
0339 f23683    jp      p,8336h
033c dbd0      in      a,(0d0h)
033e e60f      and     0fh
0340 4f        ld      c,a
0341 3e1a      ld      a,1ah
0343 d3f8      out     (0f8h),a
0345 dbd0      in      a,(0d0h)
0347 a8        xor     b
0348 fa4583    jp      m,8345h
034b dbd0      in      a,(0d0h)
034d 87        add     a,a
034e 87        add     a,a
034f 87        add     a,a
0350 87        add     a,a
0351 81        add     a,c
0352 01f818    ld      bc,18f8h
0355 ed41      out     (c),b
0357 0d        dec     c
0358 20fd      jr      nz,0357h         ; (-03h)
035a 10fb      djnz    0357h            ; (-05h)
035c feff      cp      0ffh
035e 2803      jr      z,0363h          ; (+03h)
0360 32ff03    ld      (03ffh),a
0363 3aff03    ld      a,(03ffh)
0366 47        ld      b,a
0367 fe03      cp      03h
0369 caab82    jp      z,82abh
DispChar 78        ld      a,b			; 836ch or 036ch in this disassembly
036d d9        exx     
036e dd21f000  ld      ix,00f0h
0372 217b83    ld      hl,837bh
0375 22f600    ld      (00f6h),hl
0378 c38384    jp      8483h
037b d9        exx     
037c 3afd02    ld      a,(02fdh)
037f b7        or      a
0380 78        ld      a,b
0381 c0        ret     nz

0382 db31      in      a,(31h)			; wait for ok to transmit
0384 e601      and     01h
0386 28fa      jr      z,0382h          ; (-06h)
0388 78        ld      a,b
0389 d330      out     (30h),a			; send what was in reg b by way of reg a
038b c9        ret     

038c cd6b82    call    826bh
038f 18d5      jr      0366h            ; (-2bh)
; get 4 hex characters and retun 16bit binary in register b, trashes a, bc, hl
0391 cd2583    call    GetChar
0394 6f        ld      l,a
0395 cd2583    call    GetChar
0398 67        ld      h,a
0399 22fc00    ld      (00fch),hl
; call to here to get an 8 bit binary value from the keyboard
039c cd2583    call    GetChar
039f 6f        ld      l,a
03a0 cd2583    call    GetChar
03a3 67        ld      h,a
03a4 22fe00    ld      (00feh),hl
03a7 21fc00    ld      hl,00fch
03aa 0604      ld      b,04h
03ac 7e        ld      a,(hl)
03ad d630      sub     30h
03af fe0a      cp      0ah
03b1 3802      jr      c,03b5h          ; (+02h)
03b3 d607      sub     07h
03b5 cb40      bit     0,b
03b7 2007      jr      nz,03c0h         ; (+07h)
03b9 87        add     a,a
03ba 87        add     a,a
03bb 87        add     a,a
03bc 87        add     a,a
03bd 4f        ld      c,a
03be 1802      jr      03c2h            ; (+02h)
03c0 81        add     a,c
03c1 77        ld      (hl),a
03c2 23        inc     hl
03c3 10e7      djnz    03ach            ; (-19h)
03c5 2b        dec     hl
03c6 4e        ld      c,(hl)
03c7 2b        dec     hl
03c8 2b        dec     hl
03c9 46        ld      b,(hl)
03ca c9        ret     
; mini monitor jump to address routine
03cb cd9183    call    8391h			; get 16bit binary from keyboard
03ce 21ab82    ld      hl,82abh			; load hl with mini monitor start address
03d1 c5        push    bc				; push address to jump to onto stack
03d2 c9        ret     					; use return to jump to the address
; convert binary in bc to ascii and display it?
03d3 3af000    ld      a,(00f0h)
03d6 fe4b      cp      4bh
03d8 48        ld      c,b
03d9 3818      jr      c,03f3h          ; (+18h)
03db cdb382    call    82b3h
03de 04        inc     b
03df cd6c83    call    DispChar
03e2 cd6c83    call    DispChar
03e5 2afe02    ld      hl,(02feh)
03e8 2b        dec     hl
03e9 59        ld      e,c
03ea 4c        ld      c,h
03eb cdf883    call    83f8h
03ee 4d        ld      c,l
03ef cdf883    call    83f8h
03f2 4b        ld      c,e
03f3 0620      ld      b,20h
03f5 cd6c83    call    DispChar			; display a space char
03f8 1602      ld      d,02h
03fa 79        ld      a,c
03fb e6f0      and     0f0h
03fd 0f        rrca    
03fe 0f        rrca    
03ff 0f        rrca    
0400 0f        rrca    
0401 c630      add     a,30h
0403 fe3a      cp      3ah
0405 3802      jr      c,0409h          ; (+02h)
0407 c607      add     a,07h
0409 47        ld      b,a
040a cd6c83    call    DispChar
040d 79        ld      a,c
040e e60f      and     0fh
0410 15        dec     d
0411 20ee      jr      nz,0401h         ; (-12h)
0413 c9        ret     

0414 d620      sub     20h
0416 4f        ld      c,a
0417 af        xor     a
0418 47        ld      b,a
0419 dd6603    ld      h,(ix+03h)
041c dd6e02    ld      l,(ix+02h)
041f 09        add     hl,bc
0420 09        add     hl,bc
0421 09        add     hl,bc
0422 09        add     hl,bc
0423 09        add     hl,bc
0424 09        add     hl,bc
0425 09        add     hl,bc
0426 dd5600    ld      d,(ix+00h)
0429 dd5e01    ld      e,(ix+01h)
042c dd7e0a    ld      a,(ix+0ah)
042f 12        ld      (de),a
0430 1c        inc     e
0431 010207    ld      bc,0702h
0434 cb7e      bit     7,(hl)
0436 280a      jr      z,0442h          ; (+0ah)
0438 12        ld      (de),a
0439 1c        inc     e
043a 0d        dec     c
043b cb76      bit     6,(hl)
043d 2803      jr      z,0442h          ; (+03h)
; possible starting place for the screen character map.
; 96 printable characters by 10 bytes each = 960 bytes
; not sure or the bytes per character. 
; the cursor template is 5x16bit words
; doesn't look like this is a correct starting place
; the manual shows x561H as start of char map - page 3-30
043f 12        ld      (de),a
0440 1c        inc     e
0441 0d        dec     c
0442 7e        ld      a,(hl)
0443 e63f      and     3fh
0445 ddae0a    xor     (ix+0ah)
0448 12        ld      (de),a
0449 23        inc     hl
044a 1c        inc     e
044b 10f5      djnz    0442h            ; (-0bh)
044d dd7e0a    ld      a,(ix+0ah)
0450 0d        dec     c
0451 fa5884    jp      m,8458h
0454 12        ld      (de),a
0455 1c        inc     e
0456 18f8      jr      0450h            ; (-08h)
0458 0e0c      ld      c,0ch
045a 1835      jr      0491h            ; (+35h)
045c 7d        ld      a,l
045d 93        sub     e
045e d610      sub     10h
0460 280e      jr      z,0470h          ; (+0eh)
0462 4f        ld      c,a
0463 264f      ld      h,4fh
0465 41        ld      b,c
0466 af        xor     a
0467 6b        ld      l,e
0468 77        ld      (hl),a
0469 2c        inc     l
046a 10fc      djnz    0468h            ; (-04h)
046c 25        dec     h
046d f26584    jp      p,8465h
0470 eb        ex      de,hl
0471 2d        dec     l
0472 5d        ld      e,l
0473 060a      ld      b,0ah
0475 af        xor     a
0476 6b        ld      l,e
0477 77        ld      (hl),a
0478 2d        dec     l
0479 10fc      djnz    0477h            ; (-04h)
047b 24        inc     h
047c 7c        ld      a,h
047d fe50      cp      50h
047f 20f2      jr      nz,0473h         ; (-0eh)
0481 1873      jr      04f6h            ; (+73h)
; start of video driver
0483 e67f      and     7fh
0485 fe7f      cp      7fh
0487 ca1d85    jp      z,851dh
048a fe20      cp      20h
048c 3086      jr      nc,0414h         ; (-7ah)
048e 4f        ld      c,a
048f 1867      jr      04f8h            ; (+67h)
0491 79        ld      a,c
0492 dd6605    ld      h,(ix+05h)
0495 dd6e04    ld      l,(ix+04h)
0498 fe0d      cp      0dh				; check for return
049a 282b      jr      z,04c7h          ; (+2bh)
049c fe0a      cp      0ah				; check for line feed
049e 2843      jr      z,04e3h          ; (+43h)
04a0 fe0c      cp      0ch				; check for forespare - cursor right
04a2 282f      jr      z,04d3h          ; (+2fh)
04a4 fe1f      cp      1fh				; check for home cursor
04a6 2835      jr      z,04ddh          ; (+35h)
04a8 fe0e      cp      0eh				; check for clear to end of line
04aa 28c4      jr      z,0470h          ; (-3ch)
04ac fe0f      cp      0fh				; check for clear to end of screen
04ae 28ac      jr      z,045ch          ; (-54h)
04b0 fe18      cp      18h				; check for cursor on
04b2 2817      jr      z,04cbh          ; (+17h)
04b4 fe19      cp      19h				; check for cursor off
04b6 2817      jr      z,04cfh          ; (+17h)
04b8 fe08      cp      08h				; check for backspace
04ba 2868      jr      z,0524h          ; (+68h)
04bc fe0b      cp      0bh				; check for reverse line feed - cursor up
04be 2871      jr      z,0531h          ; (+71h)
04c0 fe1e      cp      1eh				; check for new line
04c2 2032      jr      nz,04f6h         ; (+32h)
04c4 dd7501    ld      (ix+01h),l
04c7 af        xor     a
04c8 0c        inc     c
04c9 1813      jr      04deh            ; (+13h)
04cb cb84      res     0,h
04cd 1824      jr      04f3h            ; (+24h)
04cf cbc4      set     0,h
04d1 1820      jr      04f3h            ; (+20h)
04d3 7a        ld      a,d
04d4 3c        inc     a
04d5 fe50      cp      50h
04d7 2005      jr      nz,04deh         ; (+05h)
04d9 cb4c      bit     1,h
04db 2019      jr      nz,04f6h         ; (+19h)
04dd af        xor     a
04de dd7700    ld      (ix+00h),a
04e1 2013      jr      nz,04f6h         ; (+13h)
04e3 dd7301    ld      (ix+01h),e
04e6 cbfc      set     7,h
04e8 7d        ld      a,l
04e9 c60a      add     a,0ah
04eb 4f        ld      c,a
04ec c6e6      add     a,0e6h
04ee 93        sub     e
04ef 2005      jr      nz,04f6h         ; (+05h)
04f1 184e      jr      0541h            ; (+4eh)
04f3 dd7405    ld      (ix+05h),h
; a jump vector points here - see end of the file
04f6 cbf9      set     7,c
04f8 dd5600    ld      d,(ix+00h)
04fb dd5e01    ld      e,(ix+01h)
04fe 060a      ld      b,0ah
0500 ddcb0546  bit     0,(ix+05h)
0504 2805      jr      z,050bh          ; (+05h)
0506 7b        ld      a,e
0507 80        add     a,b
0508 5f        ld      e,a
0509 180d      jr      0518h            ; (+0dh)
050b dd6609    ld      h,(ix+09h)
050e dd6e08    ld      l,(ix+08h)
0511 1a        ld      a,(de)
0512 ae        xor     (hl)
0513 12        ld      (de),a
0514 23        inc     hl
0515 1c        inc     e
0516 10f9      djnz    0511h            ; (-07h)
0518 cb79      bit     7,c
051a ca9184    jp      z,8491h
051d dd6e06    ld      l,(ix+06h)
0520 dd6607    ld      h,(ix+07h)
0523 e9        jp      (hl)
0524 7a        ld      a,d
0525 3d        dec     a
0526 f2c884    jp      p,84c8h
0529 cb4c      bit     1,h
052b 20c9      jr      nz,04f6h         ; (-37h)
052d dd36004f  ld      (ix+00h),4fh
0531 7b        ld      a,e
0532 d614      sub     14h
0534 dd7701    ld      (ix+01h),a
0537 5f        ld      e,a
0538 7d        ld      a,l
0539 d60a      sub     0ah
053b bb        cp      e
053c 20b8      jr      nz,04f6h         ; (-48h)
053e cbf4      set     6,h
0540 4b        ld      c,e
0541 1650      ld      d,50h
0543 6b        ld      l,e
0544 060a      ld      b,0ah
0546 15        dec     d
0547 af        xor     a
0548 12        ld      (de),a
0549 1c        inc     e
054a 10fc      djnz    0548h            ; (-04h)
054c 5d        ld      e,l
054d b2        or      d
054e 20f4      jr      nz,0544h         ; (-0ch)
0550 dd7104    ld      (ix+04h),c
0553 cb54      bit     2,h
0555 209c      jr      nz,04f3h         ; (-64h)
0557 79        ld      a,c
0558 d390      out     (90h),a
055a 189a      jr      04f6h            ; (-66h)
;
; this may be where the screen char generator map starts
; at least it looks like it from looking at the pattern in the hex dump
;
055c 00        nop     
055d 00        nop     
055e 00        nop     
055f 00        nop     
0560 00        nop  
; another possible starting place for the screen character map 
; based on sample code from the manual page 3-30   
0561 00        nop     
0562 00        nop     
0563 00        nop     
0564 00        nop     
0565 00        nop     
0566 00        nop     
0567 00        nop     
0568 08        ex      af,af'
0569 08        ex      af,af'
056a 08        ex      af,af'
056b 08        ex      af,af'
056c 08        ex      af,af'
056d 00        nop     
056e 08        ex      af,af'
056f 14        inc     d
0570 14        inc     d
0571 14        inc     d
0572 00        nop     
0573 00        nop     
0574 00        nop     
0575 00        nop     
0576 14        inc     d
0577 14        inc     d
0578 3e14      ld      a,14h
057a 3e14      ld      a,14h
057c 14        inc     d
057d 08        ex      af,af'
057e 1e28      ld      e,28h
0580 1c        inc     e
0581 0a        ld      a,(bc)
0582 3c        inc     a
0583 08        ex      af,af'
0584 323204    ld      (0432h),a
0587 08        ex      af,af'
0588 1026      djnz    05b0h            ; (+26h)
058a 2610      ld      h,10h
058c 2828      jr      z,05b6h          ; (+28h)
058e 102a      djnz    05bah            ; (+2ah)
0590 24        inc     h
0591 1a        ld      a,(de)
0592 08        ex      af,af'
0593 08        ex      af,af'
0594 1000      djnz    0596h            ; (+00h)
0596 00        nop     
0597 00        nop     
0598 00        nop     
0599 04        inc     b
059a 08        ex      af,af'
059b 1010      djnz    05adh            ; (+10h)
059d 1008      djnz    05a7h            ; (+08h)
059f 04        inc     b
05a0 1008      djnz    05aah            ; (+08h)
05a2 04        inc     b
05a3 04        inc     b
05a4 04        inc     b
05a5 08        ex      af,af'
05a6 1008      djnz    05b0h            ; (+08h)
05a8 2a1c08    ld      hl,(081ch)
05ab 1c        inc     e
05ac 2a0800    ld      hl,(0008h)
05af 08        ex      af,af'
05b0 08        ex      af,af'
05b1 3e08      ld      a,08h
05b3 08        ex      af,af'
05b4 00        nop     
05b5 80        add     a,b
05b6 00        nop     
05b7 00        nop     
05b8 00        nop     
05b9 08        ex      af,af'
05ba 08        ex      af,af'
05bb 1000      djnz    05bdh            ; (+00h)
05bd 00        nop     
05be 00        nop     
05bf 3e00      ld      a,00h
05c1 00        nop     
05c2 00        nop     
05c3 00        nop     
05c4 00        nop     
05c5 00        nop     
05c6 00        nop     
05c7 00        nop     
05c8 00        nop     
05c9 08        ex      af,af'
05ca 02        ld      (bc),a
05cb 02        ld      (bc),a
05cc 04        inc     b
05cd 08        ex      af,af'
05ce 1020      djnz    05f0h            ; (+20h)
05d0 201c      jr      nz,05eeh         ; (+1ch)
05d2 22262a    ld      (2a26h),hl
05d5 32221c    ld      (1c22h),a
05d8 08        ex      af,af'
05d9 1808      jr      05e3h            ; (+08h)
05db 08        ex      af,af'
05dc 08        ex      af,af'
05dd 08        ex      af,af'
05de 1c        inc     e
05df 1c        inc     e
05e0 22020c    ld      (0c02h),hl
05e3 1020      djnz    0605h            ; (+20h)
05e5 3e3e      ld      a,3eh
05e7 02        ld      (bc),a
05e8 04        inc     b
05e9 0c        inc     c
05ea 02        ld      (bc),a
05eb 221c04    ld      (041ch),hl
05ee 0c        inc     c
05ef 14        inc     d
05f0 24        inc     h
05f1 3e04      ld      a,04h
05f3 04        inc     b
05f4 3e20      ld      a,20h
05f6 3c        inc     a
05f7 02        ld      (bc),a
05f8 02        ld      (bc),a
05f9 221c0c    ld      (0c1ch),hl
05fc 1020      djnz    061eh            ; (+20h)
05fe 3c        inc     a
05ff 22221c    ld      (1c22h),hl
0602 3e02      ld      a,02h
0604 04        inc     b
0605 08        ex      af,af'
0606 1020      djnz    0628h            ; (+20h)
0608 201c      jr      nz,0626h         ; (+1ch)
060a 22221c    ld      (1c22h),hl
060d 22221c    ld      (1c22h),hl
0610 1c        inc     e
0611 22221e    ld      (1e22h),hl
0614 02        ld      (bc),a
0615 04        inc     b
0616 1800      jr      0618h            ; (+00h)
0618 00        nop     
0619 08        ex      af,af'
061a 00        nop     
061b 00        nop     
061c 08        ex      af,af'
061d 00        nop     
061e 80        add     a,b
061f 08        ex      af,af'
0620 00        nop     
0621 00        nop     
0622 08        ex      af,af'
0623 08        ex      af,af'
0624 1004      djnz    062ah            ; (+04h)
0626 08        ex      af,af'
0627 1020      djnz    0649h            ; (+20h)
0629 1008      djnz    0633h            ; (+08h)
062b 04        inc     b
062c 00        nop     
062d 00        nop     
062e 3e00      ld      a,00h
0630 3e00      ld      a,00h
0632 00        nop     
0633 1008      djnz    063dh            ; (+08h)
0635 04        inc     b
0636 02        ld      (bc),a
0637 04        inc     b
0638 08        ex      af,af'
0639 101c      djnz    0657h            ; (+1ch)
063b 220408    ld      (0804h),hl
063e 08        ex      af,af'
063f 00        nop     
0640 08        ex      af,af'
0641 1c        inc     e
0642 222e2a    ld      (2a2eh),hl
0645 2e20      ld      l,20h
0647 1e1c      ld      e,1ch
0649 222222    ld      (2222h),hl
064c 3e22      ld      a,22h
064e 223c22    ld      (223ch),hl
0651 223c22    ld      (223ch),hl
0654 223c1c    ld      (1c3ch),hl
0657 222020    ld      (2020h),hl
065a 2022      jr      nz,067eh         ; (+22h)
065c 1c        inc     e
065d 3c        inc     a
065e 222222    ld      (2222h),hl
0661 22223c    ld      (3c22h),hl
0664 3e20      ld      a,20h
0666 203c      jr      nz,06a4h         ; (+3ch)
0668 2020      jr      nz,068ah         ; (+20h)
066a 3e3e      ld      a,3eh
066c 2020      jr      nz,068eh         ; (+20h)
066e 3c        inc     a
066f 2020      jr      nz,0691h         ; (+20h)
0671 201c      jr      nz,068fh         ; (+1ch)
0673 222020    ld      (2020h),hl
0676 2e22      ld      l,22h
0678 1e22      ld      e,22h
067a 22223e    ld      (3e22h),hl
067d 222222    ld      (2222h),hl
0680 1c        inc     e
0681 08        ex      af,af'
0682 08        ex      af,af'
0683 08        ex      af,af'
0684 08        ex      af,af'
0685 08        ex      af,af'
0686 1c        inc     e
0687 0e04      ld      c,04h
0689 04        inc     b
068a 04        inc     b
068b 04        inc     b
068c 24        inc     h
068d 1822      jr      06b1h            ; (+22h)
068f 24        inc     h
0690 2830      jr      z,06c2h          ; (+30h)
0692 2824      jr      z,06b8h          ; (+24h)
0694 222020    ld      (2020h),hl
0697 2020      jr      nz,06b9h         ; (+20h)
0699 2020      jr      nz,06bbh         ; (+20h)
069b 3e22      ld      a,22h
069d 362a      ld      (hl),2ah
069f 2a2222    ld      hl,(2222h)
06a2 222232    ld      (3222h),hl
06a5 322a26    ld      (262ah),a
06a8 2622      ld      h,22h
06aa 1c        inc     e
06ab 222222    ld      (2222h),hl
06ae 22221c    ld      (1c22h),hl
06b1 3c        inc     a
06b2 22223c    ld      (3c22h),hl
06b5 2020      jr      nz,06d7h         ; (+20h)
06b7 201c      jr      nz,06d5h         ; (+1ch)
06b9 222222    ld      (2222h),hl
06bc 2a241a    ld      hl,(1a24h)
06bf 3c        inc     a
06c0 22223c    ld      (3c22h),hl
06c3 2824      jr      z,06e9h          ; (+24h)
06c5 221c22    ld      (221ch),hl
06c8 201c      jr      nz,06e6h         ; (+1ch)
06ca 02        ld      (bc),a
06cb 221c3e    ld      (3e1ch),hl
06ce 08        ex      af,af'
06cf 08        ex      af,af'
06d0 08        ex      af,af'
06d1 08        ex      af,af'
06d2 08        ex      af,af'
06d3 08        ex      af,af'
06d4 222222    ld      (2222h),hl
06d7 222222    ld      (2222h),hl
06da 1c        inc     e
06db 222222    ld      (2222h),hl
06de 221414    ld      (1414h),hl
06e1 08        ex      af,af'
06e2 222222    ld      (2222h),hl
06e5 2a2a2a    ld      hl,(2a2ah)
06e8 14        inc     d
06e9 222214    ld      (1422h),hl
06ec 08        ex      af,af'
06ed 14        inc     d
06ee 222222    ld      (2222h),hl
06f1 221408    ld      (0814h),hl
06f4 08        ex      af,af'
06f5 08        ex      af,af'
06f6 08        ex      af,af'
06f7 3e02      ld      a,02h
06f9 04        inc     b
06fa 08        ex      af,af'
06fb 1020      djnz    071dh            ; (+20h)
06fd 3e1c      ld      a,1ch
06ff 1010      djnz    0711h            ; (+10h)
0701 1010      djnz    0713h            ; (+10h)
0703 101c      djnz    0721h            ; (+1ch)
0705 2020      jr      nz,0727h         ; (+20h)
0707 1008      djnz    0711h            ; (+08h)
0709 04        inc     b
070a 02        ld      (bc),a
070b 02        ld      (bc),a
070c 1c        inc     e
070d 04        inc     b
070e 04        inc     b
070f 04        inc     b
0710 04        inc     b
0711 04        inc     b
0712 1c        inc     e
0713 08        ex      af,af'
0714 14        inc     d
0715 220000    ld      (0000h),hl
0718 00        nop     
0719 00        nop     
071a c0        ret     nz

071b 00        nop     
071c 00        nop     
071d 00        nop     
071e 00        nop     
071f 00        nop     
0720 3e10      ld      a,10h
0722 08        ex      af,af'
0723 04        inc     b
0724 00        nop     
0725 00        nop     
0726 00        nop     
0727 00        nop     
0728 00        nop     
0729 00        nop     
072a 3804      jr      c,0730h          ; (+04h)
072c 3c        inc     a
072d 24        inc     h
072e 1e20      ld      e,20h
0730 203c      jr      nz,076eh         ; (+3ch)
0732 222222    ld      (2222h),hl
0735 3c        inc     a
0736 00        nop     
0737 00        nop     
0738 1e20      ld      e,20h
073a 2020      jr      nz,075ch         ; (+20h)
073c 1e02      ld      e,02h
073e 02        ld      (bc),a
073f 1e22      ld      e,22h
0741 22221e    ld      (1e22h),hl
0744 00        nop     
0745 00        nop     
0746 1c        inc     e
0747 223e20    ld      (203eh),hl
074a 1c        inc     e
074b 0c        inc     c
074c 12        ld      (de),a
074d 103c      djnz    078bh            ; (+3ch)
074f 1010      djnz    0761h            ; (+10h)
0751 10dc      djnz    072fh            ; (-24h)
0753 222222    ld      (2222h),hl
0756 1e02      ld      e,02h
0758 1c        inc     e
0759 2020      jr      nz,077bh         ; (+20h)
075b 2c        inc     l
075c 322222    ld      (2222h),a
075f 220008    ld      (0800h),hl
0762 00        nop     
0763 08        ex      af,af'
0764 08        ex      af,af'
0765 08        ex      af,af'
0766 1c        inc     e
0767 84        add     a,h
0768 00        nop     
0769 04        inc     b
076a 04        inc     b
076b 04        inc     b
076c 14        inc     d
076d 08        ex      af,af'
076e 2020      jr      nz,0790h         ; (+20h)
0770 24        inc     h
0771 2830      jr      z,07a3h          ; (+30h)
0773 2824      jr      z,0799h          ; (+24h)
0775 1808      jr      077fh            ; (+08h)
0777 08        ex      af,af'
0778 08        ex      af,af'
0779 08        ex      af,af'
077a 08        ex      af,af'
077b 1c        inc     e
077c 00        nop     
077d 00        nop     
077e 34        inc     (hl)
077f 2a2a2a    ld      hl,(2a2ah)
0782 2a0000    ld      hl,(0000h)
0785 2c        inc     l
0786 322222    ld      (2222h),a
0789 220000    ld      (0000h),hl
078c 1c        inc     e
078d 222222    ld      (2222h),hl
0790 1c        inc     e
0791 fc2222    call    m,2222h
0794 223c20    ld      (203ch),hl
0797 20dc      jr      nz,0775h         ; (-24h)
0799 24        inc     h
079a 24        inc     h
079b 24        inc     h
079c 1c        inc     e
079d 04        inc     b
079e 0600      ld      b,00h
07a0 00        nop     
07a1 2c        inc     l
07a2 322020    ld      (2020h),a
07a5 2000      jr      nz,07a7h         ; (+00h)
07a7 00        nop     
07a8 1e20      ld      e,20h
07aa 1c        inc     e
07ab 02        ld      (bc),a
07ac 3c        inc     a
07ad 08        ex      af,af'
07ae 08        ex      af,af'
07af 1c        inc     e
07b0 08        ex      af,af'
07b1 08        ex      af,af'
07b2 08        ex      af,af'
07b3 04        inc     b
07b4 00        nop     
07b5 00        nop     
07b6 222222    ld      (2222h),hl
07b9 261a      ld      h,1ah
07bb 00        nop     
07bc 00        nop     
07bd 222214    ld      (1422h),hl
07c0 14        inc     d
07c1 08        ex      af,af'
07c2 00        nop     
07c3 00        nop     
07c4 22222a    ld      (2a22h),hl
07c7 2a1400    ld      hl,(0014h)
07ca 00        nop     
07cb 221408    ld      (0814h),hl
07ce 14        inc     d
07cf 22e222    ld      (22e2h),hl
07d2 22261a    ld      (1a26h),hl
07d5 02        ld      (bc),a
07d6 1c        inc     e
07d7 00        nop     
07d8 00        nop     
07d9 3e04      ld      a,04h
07db 08        ex      af,af'
07dc 103e      djnz    081ch            ; (+3eh)
07de 04        inc     b
07df 08        ex      af,af'
07e0 08        ex      af,af'
07e1 1008      djnz    07ebh            ; (+08h)
07e3 08        ex      af,af'
07e4 04        inc     b
07e5 08        ex      af,af'
07e6 08        ex      af,af'
07e7 08        ex      af,af'
07e8 00        nop     
07e9 08        ex      af,af'
07ea 08        ex      af,af'
07eb 08        ex      af,af'
07ec 1008      djnz    07f6h            ; (+08h)
07ee 08        ex      af,af'
07ef 04        inc     b
07f0 08        ex      af,af'
07f1 08        ex      af,af'
07f2 1002      djnz    07f6h            ; (+02h)
07f4 1c        inc     e
07f5 2000      jr      nz,07f7h         ; (+00h)
07f7 00        nop     
07f8 00        nop     
07f9 00        nop  
; looks like jump vectors   
07fa c3f684    jp      84f6h
07fd c38384    jp      8483h			; vector to start of video driver
