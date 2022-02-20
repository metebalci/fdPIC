; fdPIC - frequency divider PIC
; Copyright (C) 2022 Mete Balci

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
#include <xc.inc> 
    
; PROCESSOR directive is not needed but if you use a different processor,
; make sure the configuration etc. below is correct and test
PROCESSOR 12F629

; PIC12F629
; mid-range 8-bit PIC, 8-bit data, 14-bit instructions, hardware architecture
; fetch-execute cycles are pipelined, each instruction executes in single cycle
; if PC is changed, pipeline is cleared, so it takes 2 cycles
; below goto and decfsz when it is 0 is such instructions
    
; GPIO configuration
; GP0 and GP1 is used solely for ICSP
; GP2 is output (GP5 scaled down by a factor calculated below)
; GP3 is MCLR/Vpp, used solely for ICSP
; GP4 is not used, set as output and driven as low
; GP5 is external clock input
    
; configuration bits
; http://ww1.microchip.com/downloads/en/devicedoc/31027a.pdf
; https://ww1.microchip.com/downloads/en/devicedoc/41190c.pdf	
; possible values of FOSC for PIC12F629
; from file:///C:/Program%20Files/Microchip/xc8/v2.36/docs/chips/12f629.html
; EXTRCCLK	RC oscillator: CLKOUT function on GP4/OSC2/CLKOUT pin, RC on GP5/OSC1/CLKIN
; EXTRCIO	RC oscillator: I/O function on GP4/OSC2/CLKOUT pin, RC on GP5/OSC1/CLKIN
; INTRCCLK	INTOSC oscillator: CLKOUT function on GP4/OSC2/CLKOUT pin, I/O function on GP5/OSC1/CLKIN
; INTRCIO	INTOSC oscillator: I/O function on GP4/OSC2/CLKOUT pin, I/O function on GP5/OSC1/CLKIN
; EC		EC: I/O function on GP4/OSC2/CLKOUT pin, CLKIN on GP5/OSC1/CLKIN
; HS		HS oscillator: High speed crystal/resonator on GP4/OSC2/CLKOUT and GP5/OSC1/CLKIN
; XT		XT oscillator: Crystal/resonator on GP4/OSC2/CLKOUT and GP5/OSC1/CLKIN
; LP		LP oscillator: Low power crystal on GP4/OSC2/CLKOUT and GP5/OSC1/CLKIN
    
config FOSC	= "EC"		; external clock at GP5/CLKIN
config MCLRE	= "ON"		; GP3/MCLR is reset, externally pulled up
config WDTE	= "OFF"		; no watchdog timer
    
; each half period should take 1/8 of actual freq division cycles
; because instruction cycle is 1/4 ext input and 
;  each output half cycle (1 and 0) is one loop below  
; thus the freq division has to be a multiple of 8, e.g. cannot be 100
    
; loop takes (10 + counter1 * (5 + counter2 * (5 + (counter3 * 5)))) cycles
; counter values cannot be zero, they have to be minimum 1
    
; example configurations, found by search.py, there are multiple alternatives
    
;   freq div	|   loop    |	counter 1   |   counter 2   |   counter 3   |
;       1000	|       125 |	1	    |   1	    |   21	    |    
;      10000	|      1250 |	1	    |   1	    |   246	    |
;     100000	|     12500 |	1	    |   11	    |   226	    |
;    1000000	|    125000 |	29	    |   7	    |   122	    |
;   10000000	|   1250000 |	14	    |   72	    |   247	    |
    
COUNTER_1 EQU 1
COUNTER_2 EQU 1
COUNTER_3 EQU 21
    
; register file
psect udata_bank0
    
tmp1: DB 00h
tmp2: DB 00h
tmp3: DB 00h
 
; the code section starts
; this is relocated but reset vector is set to 
; what end directive at the end of the file points to (start label)
psect code

start:
    ; comparator off
    BANKSEL (CMCON)
    movlw   00000111B       
    movwf   BANKMASK(CMCON)

    ; it is recommended to set all unused GPIO as output and drive low    
    ; it does not matter CLKIN is configured as output
    ; it is set as CLKIN by the configuration bits above
    
    ; set all GPIO as output
    BANKSEL (TRISIO)
    clrf    BANKMASK(TRISIO)

    ; drive all low
    ; no bank selection is done in loop, so last BANKSEL is used
    ; which is this one, GPIO
    BANKSEL (GPIO)
    clrf    BANKMASK(GPIO)

loop:   
    ; toggle GP2
    movlw   0x04
    xorwf   BANKMASK(GPIO), F
    ; the nops below are to make loop iteration 10 cycles + delay loops
    nop
    nop
    nop
    nop
    
    ; initialize first loop
    movlw   COUNTER_1
    movwf   tmp1
    
    ; counter1 * (5 + counter2 * (5 + (counter3 * 5))) cycles
    delay1:
        ; initialize second loop
        movlw   COUNTER_2
        movwf   tmp2
	
        ; counter2 * (5 + (counter3 * 5)) cycles
        delay2: 
            ; initialize third loop
            movlw   COUNTER_3
            movwf   tmp3

            ; (counter3 * 5) cycles
            delay3:
                nop
                nop
                decfsz	tmp3, F
                goto	delay3
                nop

            decfsz  tmp2, F
            goto    delay2
            nop

        decfsz	tmp1, F
        goto	delay1
        nop
	
    goto    loop
	
end start
