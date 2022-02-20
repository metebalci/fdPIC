
# fdPIC - frequency divider PIC

This is another implementation of the picDIV idea (http://www.leapsecond.com/pic/picdiv.htm). The original picDIV project is written in Microchip MPASM assembler (MPASM) which is not supported anymore. I first planned to port its source code to MPLAB XC8 PIC Assembler but then I decided to implement it on my way. 

# frequency division 

The picDIV project has different source files for common frequency division ratios, whereas fdPIC has a single (assembly) source file (fdPIC.S) where you can change 3 constants to set the integer frequency division ratio. Also, a simple python code (search.py) is provided to find the constant values for the frequency division ratio you want. The code is written to support most of the ratios that are multiples of 5. 

# Hardware

I am testing and using the project with PIC12F629. I guess it can easily be modified and run on other mid-range PICs.

# Compile

The fdPIC.S is compiled in MPLAB X IDE using MPLAB XC8 PIC Assembler (pic-as) toolchain.
