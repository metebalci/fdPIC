
# picDIV-pic-as

This is a port of a part of picDIV (http://www.leapsecond.com/pic/picdiv.htm) project, specifically pd07 (http://www.leapsecond.com/pic/src/pd07.asm) that is the 10MHz to 1Hz/1pps clock downconverter code to run on a PIC.

The copyright of the original idea and the implementation belongs to the author of picDIV (Tom Van Baak (tvb)  www.LeapSecond.com/pic).

The original code (pd07.asm) is written for Microchip MPASM assembler (MPASM) which is not supported anymore. The ported source code (pd07.S) has the same functionality (of pd07) but compiles in MPLAB XC8 PIC Assembler (pic-as toolchain).

Additionally this port is targeted for PIC12F629 rather than PIC12F675. The functionality of the code is same, but there is no ADC/no 'ANSEL' register in 12F629.
