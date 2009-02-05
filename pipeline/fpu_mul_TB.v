
`timescale 1ps / 1ps
module fpu_mul_tb;

reg clk;
reg rst;
reg enable;
reg [63:0]opa;
reg [63:0]opb;
wire ready;
wire [63:0] outfp;




	fpu_mul UUT (
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.opa(opa),
		.opb(opb),
		.ready(ready),
		.outfp(outfp));

initial
begin : STIMUL 
	#0
	rst = 1'b1;
	enable = 1'b0;
    #10000; 
	rst = 1'b0;
	enable = 1'b1; 
//inputA:5.6700000000e+001
//inputB:2.9900000000e+000
opa = 64'b0100000001001100010110011001100110011001100110011001100110011010;
opb = 64'b0100000000000111111010111000010100011110101110000101000111101100;	
	 #10000; 
//inputA:3.6600000000e-003
//inputB:9.9700000000e-008
opa = 64'b0011111101101101111110111001001110001001101101010010000000001000;
opb = 64'b0011111001111010110000110101010011110010110110010100110101111010;	 
	   #10000; 
//inputA:4.5000000000e+048
//inputB:2.0000000000e+067
opa = 64'b0100101000001000101000011101011111010100101101100000000110000001;
opb = 64'b0100110111100111101111010010100111010001110010000111101000011001;
	   #10000; 
//inputA:2.9999997039e-317
//inputB:4.0000000000e+067
opa = 64'b0000000000000000000000000000000000000000010111001010011100000011;
opb = 64'b0100110111110111101111010010100111010001110010000111101000011001;	
	  #10000; 
//inputA:-4.6990000000e+000
//inputB:6.0000000000e+089
opa = 64'b1100000000010010110010111100011010100111111011111001110110110010;
opb = 64'b0101001010010010110110011101010111010010010011000000001010101011;	
	   #10000; 
//inputA:3.0000000000e-200
//inputB:4.0000000000e-077
opa = 64'b0001011010000010010111101110110110001111111110110011100111000001;
opb = 64'b0011000000010010100001101101100000001110110000011001000011011100;	 
	   #10000; 
//inputA:5.0000000000e-250
//inputB:4.0000000000e-100
opa = 64'b0000110000101100101000111000111100110101000010110010001011011111;
opb = 64'b0010101101001011111111110010111011100100100011100000010100110000;		 
	   #10000; 
//inputA:1.#INF000000e+000
//inputB:2.0000000000e-200
opa = 64'b0111111111110000000000000000000000000000000000000000000000000000;
opb = 64'b0001011001111000011111101001001000010101010011101111011110101100;	 
	    #10000; 
//inputA:8.9999000000e+004
//inputB:1.6000000000e+001
opa = 64'b0100000011110101111110001111000000000000000000000000000000000000;
opb = 64'b0100000000110000000000000000000000000000000000000000000000000000;
//Output:1.695330000000000e+002	  
	#100000;
if (outfp==64'h4065310E56041894)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);	
	#10000; //0
	//Output:3.649020000000000e-010
if (outfp==64'h3DF9136C82DFC196)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);	 
	#10000; //0
	//Output:8.999999999999999e+115
if (outfp==64'h580245EF347B07BD)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);	 
	#10000; //0
	//Output:1.199999881578528e-249
if (outfp==64'h0000000000000000)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);
	#10000; //0
	//Output:-2.819400000000000e+090
if (outfp==64'hD2B625266303A947)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);	   
	#10000; //0
	//Output:1.200000000000000e-276
if (outfp==64'h06A5459E5A08DFFE)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);	
	#10000; //0
	//Output:0.000000000000000e+000
if (outfp==64'h0000000000000000)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);
	#10000; //0
	//Output:3.595386269724632e+108
if (outfp==64'h7FF0000000000000)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);	   
	#10000; //0
	//Output:1.439984000000000e+006
if (outfp==64'h4135F8F000000000)
	$display($time,"ps Answer is correct %h", outfp);
else
	$display($time,"ps Error! out is incorrect %h", outfp);
	#130000; 
	$finish;
end 
	
always
begin : CLOCK_clk

	clk = 1'b0;
	#5000; 
	clk = 1'b1;
	#5000; 
end


endmodule
