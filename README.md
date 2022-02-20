
# fdPIC - frequency divider PIC

This is another implementation of the picDIV idea (http://www.leapsecond.com/pic/picdiv.htm). The original picDIV project is written in Microchip MPASM assembler (MPASM) which is not supported anymore. I first planned to port its source code to MPLAB XC8 PIC Assembler but then I decided to implement it on my way. 

# How it works ?

picDIV is a cool idea. Although PIC is a microcontroller, because it is very simple, it is very easy to calculate the amount of time it takes for instructions to be executed. The frequency input is used as the clock input (CLKIN) of PIC. Each instruction cycle of PIC takes 4 clock cycles. Almost all instructions run in 1 clock cycle, only the instructions modifying PC (goto, decfsz) takes 2 clock cycles. By using proper number of instructions, it is possible to toggle a GPIO output of PIC at exactly predefined cycles. So if the output is toggled every 125 instruction cycles, this is going to be a frequency divider, with the output frequency = fCLKIN / 1000.

# How to find the values for constants (COUNTER_1, COUNTER_2, COUNTER_3): search.py

The picDIV project has different source files for common frequency division ratios, whereas fdPIC has a single (assembly) source file (fdPIC.S) where you can change 3 constants to set the integer frequency division ratio. A simple python code (search.py) is provided to find the constant values for the frequency division ratio you want. The code is written to support most of the ratios that are multiples of 5 but not every ratio is supported.

For example, the constants for ratio=1000 can be found like this:

```
$ python search.py 1000
searching for: 1000
      125 => a=  1, b=  1, c= 21
      125 => a=  1, b=  2, c= 10
      125 => a=  1, b= 11, c=  1
```

# Example

With COUNTER_1=1, COUNTER_2=1, COUNTER_3=21, and CLKIN=1MHz, output is 1KHz.

![scope.png](scope.png)

# Compile

The fdPIC.S is compiled in MPLAB X IDE using MPLAB XC8 PIC Assembler (pic-as) toolchain.

# Hardware

I am testing and using the project with PIC12F629. I guess it can easily be modified and run on other mid-range PICs. I do not know about the other PIC families, so I cannot say how easy it would be to use the code.

The input goes to GP5/CLKIN pin. MCLR is enabled, so it has to be pulled up to Vdd (10K resistor). I use the ICSP pins (GP0 and GP1) solely for ICSP, so nothing is connected to them. The output is GP2. GP4 is not used. All GPIO is set as outputs and driven to low at initialization but this does not affect ICSP pins or CLKIN. CLKIN is configured in configuration bits.
