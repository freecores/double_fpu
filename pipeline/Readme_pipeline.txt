The verilog files, fpu_addsub.v and fpu_mul.v, are pipelined versions of
floating point operators.  Rounding is not supported by these operators, and
denormalized numbers are treated as 0.  If infinity or NaN is on either of the inputs,
then infinity will be the output.  Both operators, addsub and mul, have a latency
of 18 clock cycles, and then an output is available on each clock cycle after the latency.

For addition and subtraction, fpu_addsub.v was synthesized with an estimated 
frequency of 276 MHz for a Virtex5 device.  The synthesis results are below.  
The file, fpu_addsub_TB.v, is the testbench used to simulate fpu_addsub.v.

For multiplication, fpu_mul.v was synthesized with an estimated 
frequency of 426 MHz for a Virtex5 device.  The synthesis results are below.  
The file, fpu_mul_TB.v, is the testbench used to simulate fpu_mul.v. 

Please email me any questions.

David Lundgren
davidklun@gmail.com

addsub synthesis results:

---------------------------------------
Resource Usage Report for fpu 

Mapping to part: xc5vsx95tff1136-2
Cell usage:
FDE             16 uses
FDR             6 uses
FDRE            2350 uses
GND             1 use
MUXCY           7 uses
MUXCY_L         183 uses
VCC             1 use
XORCY           130 uses
XORCY_L         4 uses
LUT1            14 uses
LUT2            386 uses
LUT3            448 uses
LUT4            133 uses
LUT5            103 uses
LUT6            496 uses

I/O ports: 197
I/O primitives: 196
IBUF           131 uses
OBUF           65 uses

BUFGP          1 use

SRL primitives:
SRL16E         16 uses

I/O Register bits:                  0
Register bits not including I/Os:   2372 (4%)

Global Clock Buffers: 1 of 32 (3%)

Total load per clock:
   fpu|clk: 2388

Mapping Summary:
Total  LUTs: 1596 (2%)

------------------------------

multiply synthesis results:

---------------------------------------
Resource Usage Report for fpu_mul 

Mapping to part: xc5vsx95tff1136-2
Cell usage:
DSP48E          9 uses
FDE             80 uses
FDRE            1221 uses
FDRSE           11 uses
GND             1 use
MUXCY           4 uses
MUXCY_L         82 uses
VCC             1 use
XORCY           75 uses
XORCY_L         3 uses
LUT1            25 uses
LUT2            203 uses
LUT3            57 uses
LUT4            30 uses
LUT5            7 uses
LUT6            14 uses

I/O ports: 196
I/O primitives: 195
IBUF           130 uses
OBUF           65 uses

BUFGP          1 use

SRL primitives:
SRLC32E        1 use
SRL16E         27 uses

I/O Register bits:                  0
Register bits not including I/Os:   1312 (2%)

Global Clock Buffers: 1 of 32 (3%)

Total load per clock:
   fpu_mul|clk: 1349

Mapping Summary:
Total  LUTs: 364 (0%)
