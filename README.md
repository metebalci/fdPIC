
# picDIV-pic-as

This is a port of a part of picDIV (http://www.leapsecond.com/pic/picdiv.htm) project, specifically pd07 (http://www.leapsecond.com/pic/src/pd07.asm) that is the 10MHz to 1Hz/1pps clock downconverter code to run on a PIC. I only need 10MHz to 1Hz downconversion, so I did not port the others (yet).

The copyright of the original idea and the implementation belongs to the author of picDIV (Tom Van Baak (tvb) https://www.leapsecond.com/pic).

The original code (pd07.asm) is written for Microchip MPASM assembler (MPASM) which is not supported anymore. The ported source code (pd07.S) has the same functionality (of pd07) but compiles in MPLAB XC8 PIC Assembler (pic-as toolchain). The common delay functionality in the original project is in delayw.asm so I also ported it to a delayw.S.

Additionally this port is targeted for PIC12F629 rather than PIC12F675. The functionality of the code is same, but there is no ADC/no 'ANSEL' register in 12F629.

I have also added a few comments to the source code.

# License

The original source code does not include a specific license. The author says: "The PIC source code is provided for your understanding. You are welcome to use the code in your own designs. But please give some credit to the author.". I assume GPL fits so I selected GPL 3.0 as the license of this port.

# Compiling

I use MPLAB X IDE v6 and pic-as toolchain. You have to select pic-as toolchain as the XC8 compiler will look for _main symbol.

# Test

I have tested the code on a PIC12F629, and as far as I can say it is working as indicated.
